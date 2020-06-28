//
//  NSObject+ESAutoCoding.m
//  ESFramework
//
//  Created by Elf Sundae on 2015/08/22.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "NSObject+ESAutoCoding.h"
#import <objc/runtime.h>

static const void *codablePropertiesKey = &codablePropertiesKey;

@implementation NSObject (ESAutoCoding)

- (void)setWithCoder:(NSCoder *)aDecoder
{
    NSDictionary *properties = self.codableProperties;
    for (NSString *key in properties) {
        Class propertyClass = properties[key];

        id object = nil;
        @try {
            object = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
        } @catch (NSException *exception) {}

        if (object) {
            [self setValue:object forKey:key];
        }
    }
}

- (NSDictionary<NSString *, Class> *)codableProperties
{
    NSDictionary *codableProperties = objc_getAssociatedObject([self class], codablePropertiesKey);

    if (!codableProperties) {
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        Class class = [self class];
        while (class != [NSObject class]) {
            [properties addEntriesFromDictionary:[class codableProperties]];
            class = [class superclass];
        }
        codableProperties = [NSDictionary dictionaryWithDictionary:properties];

        // make the association atomically so that we don't need to bother with an @synchronize
        objc_setAssociatedObject([self class], codablePropertiesKey, codableProperties, OBJC_ASSOCIATION_RETAIN);
    }

    return codableProperties;
}

- (NSDictionary<NSString *, id> *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in self.codableProperties) {
        id value = [self valueForKey:key];
        if (value) {
            dict[key] = value;
        }
    }
    return [dict copy];
}

- (NSData *)archivedData
{
#if TARGET_OS_MACCATALYST
    return [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:NULL];
#else
    if (@available(iOS 11, macOS 10.13, tvOS 11, watchOS 4, *)) {
        return [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:NULL];
    } else {
        return [NSKeyedArchiver archivedDataWithRootObject:self];
    }
#endif
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)atomically
{
    return [self.archivedData writeToFile:path atomically:atomically];
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically
{
    return [self.archivedData writeToURL:url atomically:atomically];
}

+ (nullable instancetype)objectWithArchivedData:(NSData *)data
{
    if (!data) {
        return nil;
    }

    id object = nil;

#if TARGET_OS_MACCATALYST
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:NULL];
    if (unarchiver) {
        unarchiver.requiresSecureCoding = NO;
        object = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        [unarchiver finishDecoding];
    }
#else
    if (@available(iOS 11, macOS 10.13, tvOS 11, watchOS 4, *)) {
        // This initializer enables requiresSecureCoding by default, and sets
        // the decodingFailurePolicy to NSDecodingFailurePolicySetErrorAndReturn.
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:NULL];
        if (unarchiver) {
            unarchiver.requiresSecureCoding = NO;
            object = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
            [unarchiver finishDecoding];
        }
    } else {
        @try {
            // -unarchiveObjectWithData: raises an NSInvalidArgumentException
            // if data is not a valid archive.
            object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } @catch (NSException *exception) {}
    }
#endif

    return [object isKindOfClass:self] ? object : nil;
}

+ (nullable instancetype)objectWithContentsOfFile:(NSString *)path
{
    return [self objectWithArchivedData:[NSData dataWithContentsOfFile:path]];
}

+ (nullable instancetype)objectWithContentsOfURL:(NSURL *)url
{
    return [self objectWithArchivedData:[NSData dataWithContentsOfURL:url]];
}

+ (NSDictionary<NSString *, Class> *)codableProperties
{
    NSMutableDictionary *codableProperties = [NSMutableDictionary dictionary];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);

    @autoreleasepool {
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = @(propertyName);

            Class propertyClass = nil;

            // get codable property class
            // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
            char *typeEncoding = property_copyAttributeValue(property, "T");
            switch (typeEncoding[0]) {
                case '@': {
                    if (strlen(typeEncoding) >= 3) {
                        char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                        NSString *name = @(className);
                        NSRange range = [name rangeOfString:@"<"];
                        if (range.length > 0) {
                            name = [name substringToIndex:range.location];
                        }
                        propertyClass = NSClassFromString(name) ?: [NSObject class];
                        free(className);
                    }
                    break;
                }

                case 'c':
                case 'i':
                case 's':
                case 'l':
                case 'q':
                case 'C':
                case 'I':
                case 'S':
                case 'L':
                case 'Q':
                case 'f':
                case 'd':
                case 'B':
                    propertyClass = [NSNumber class];
                    break;

                case '{':
                    propertyClass = [NSValue class];
                    break;
            } /* switch-case */
            free(typeEncoding);

            if (!propertyClass) {
                continue;
            }

            // check if there is a backing ivar
            char *ivar = property_copyAttributeValue(property, "V");
            if (ivar) {
                // check if ivar has KVC-compliant name
                NSString *ivarName = @(ivar);
                if ([ivarName isEqualToString:key] ||
                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]]) {
                    // no setter, but setValue:forKey: will still work
                    codableProperties[key] = propertyClass;
                }
                free(ivar);
            } else {
                // check if property is dynamic and readwrite
                char *dynamic = property_copyAttributeValue(property, "D");
                char *readonly = property_copyAttributeValue(property, "R");
                if (dynamic && !readonly) {
                    // no ivar, but setValue:forKey: will still work
                    codableProperties[key] = propertyClass;
                }
                free(dynamic);
                free(readonly);
            }
        } /* for-loop */
    } /* @autoreleasepool */

    free(properties);

    return [codableProperties copy];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    // No -init should be called, see https://github.com/nicklockwood/AutoCoding/pull/32
    [self setWithCoder:aDecoder];
    return self;
}
#pragma clang diagnostic pop

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in self.codableProperties) {
        id object = [self valueForKey:key];
        if (object) {
            [aCoder encodeObject:object forKey:key];
        }
    }
}

@end
