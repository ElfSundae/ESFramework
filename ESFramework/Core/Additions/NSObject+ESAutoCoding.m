//
//  NSObject+ESAutoCoding.m
//  ESFramework
//
//  Created by Elf Sundae on 15/8/22.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "NSObject+ESAutoCoding.h"
#import "NSDictionary+ESAdditions.h"
#import <objc/runtime.h>

ESDefineAssociatedObjectKey(es_codableProperties);

@implementation NSObject (ESAutoCoding)

- (id)initWithCoder_es:(NSCoder *)aDecoder
{
    self = [self init];
    if (!self) {
        return nil;
    }

    BOOL secureSupported = ([[self class] respondsToSelector:@selector(supportsSecureCoding)] &&
                            [[self class] supportsSecureCoding]);
    BOOL secureAvailable = [aDecoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)];

    NSDictionary *properties = [[self class] es_codableProperties];

    for (NSString *key in properties) {
        Class propertyClass = properties[key];

        id value = nil;

        if (secureAvailable) {
            value = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
        } else {
            value = [aDecoder decodeObjectForKey:key];
        }

        if (value) {
            if (!secureSupported || [value isKindOfClass:propertyClass]) {
                [self setValue:value forKey:key];
            }
        }
    }

    return self;
}

- (void)es_encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [[self class] es_codableProperties]) {
        id value = [self valueForKey:key];

        if (value) {
            [aCoder encodeObject:value forKey:key];
        }
    }
}

- (id)es_copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];

    for (NSString *key in [[self class] es_codableProperties]) {
        [copy setValue:[self valueForKey:key] forKey:key];
    }

    return copy;
}

+ (instancetype)es_objectWithContentsOfFile:(NSString *)filePath
{
    id object = nil;

    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } @catch (NSException *exception) {

    }

    return [object isKindOfClass:[self class]] ? object : nil;
}

- (BOOL)es_writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile
{
    if (ESTouchDirectoryAtFilePath(filePath)) {
        @try {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
            if (data) {
                return [data writeToFile:filePath atomically:useAuxiliaryFile];
            }
        } @catch (NSException *exception) {

        }
    }

    return NO;
}

+ (NSDictionary *)es_codableProperties
{
    NSDictionary *cached = ESGetAssociatedObject([self class], es_codablePropertiesKey);
    if (cached) {
        return cached;
    }

    @autoreleasepool {
        NSMutableDictionary *codableProperties = [NSMutableDictionary dictionary];

        Class superClass = [self class];
        while (superClass != [NSObject class]) {
            unsigned int propertiesCount = 0;
            objc_property_t *properties = class_copyPropertyList(superClass, &propertiesCount);

            for (unsigned int i = 0; i < propertiesCount; ++i) {

                objc_property_t property = properties[i];
                Class propertyClass = nil;

                // get codable property class
                // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
                char *propertyTypeEncoding = property_copyAttributeValue(property, "T");

                switch (propertyTypeEncoding[0]) {
                    case '@': {
                        if (strlen(propertyTypeEncoding) >= 3) {
                            char *className = strndup(propertyTypeEncoding + 2, strlen(propertyTypeEncoding) - 3);
                            NSString *name = @(className);
                            NSRange range = [name rangeOfString:@"<"];
                            if (range.location != NSNotFound) {
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
                    case 'B': {
                        propertyClass = [NSNumber class];
                        break;
                    }

                    case '{': {
                        propertyClass = [NSValue class];
                        break;
                    }
                }
                free(propertyTypeEncoding);

                if (!propertyClass) {
                    continue;
                }

                const char *propertyName = property_getName(property);
                NSString *key = @(propertyName);

                // -Elf, maybe already exists,
                // found this bug in "SQLitePersistentObject"
                if (codableProperties[key]) {
                    continue;
                }

                // check if there is a backing ivar
                char *ivar = property_copyAttributeValue(property, "V");
                if (ivar) {
                    // check if ivar has KVC-compliant name
                    NSString *ivarName = @(ivar);
                    if ([ivarName isEqualToString:key] || [ivarName isEqualToString:[@"_" stringByAppendingString:key]]) {
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

            }

            free(properties);
            superClass = [superClass superclass];
        }

        cached = [codableProperties copy];
    }

    ESSetAssociatedObject([self class], es_codablePropertiesKey, cached, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return cached;
}

- (NSDictionary *)es_dictionaryRepresentation
{
    return [self dictionaryWithValuesForKeys:[[self class] es_codableProperties].allKeys];
}

- (NSString *)es_description
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"<%@: %p\n", [self class], self];
    [[self es_dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [description appendFormat:@"%@ = %@\n", key, obj];
    }];
    [description appendString:@">"];
    return [description copy];
}

@end
