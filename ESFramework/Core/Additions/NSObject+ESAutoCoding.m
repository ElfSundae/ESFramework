//
//  NSObject+ESAutoCoding.m
//  ESFramework
//
//  Created by Elf Sundae on 15/8/22.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "NSObject+ESAutoCoding.h"
#import "ESDefines.h"

ESDefineAssociatedObjectKey(codableProperties);

@implementation NSObject (ESAutoCoding)

- (void)es_encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in self.codableProperties) {
        id object = [self valueForKey:key];
        if (object) {
            [aCoder encodeObject:object forKey:key];
        }
    }
}

- (id)es_copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in self.codableProperties) {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    return copy;
}

- (void)es_setWithCoder:(NSCoder *)aDecoder
{
    BOOL secureAvailable = [aDecoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)];
    BOOL secureSupported = [self.class respondsToSelector:@selector(supportsSecureCoding)] && [self.class supportsSecureCoding];

    NSDictionary *properties = self.codableProperties;
    for (NSString *key in properties) {
        Class propertyClass = properties[key];

        id object = nil;
        if (secureAvailable) {
            object = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
        } else {
            object = [aDecoder decodeObjectForKey:key];
        }

        if (object) {
            if (!secureSupported ||
                ([object isKindOfClass:propertyClass] || [object isKindOfClass:NSNull.class])) {
                [self setValue:object forKey:key];
            }
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
    return [self dictionaryWithValuesForKeys:self.codableProperties.allKeys];
}

- (NSString *)es_description
{
    return [NSString stringWithFormat:@"<%@: %p>\n%@", self.class, self, self.dictionaryRepresentation];
}

+ (instancetype)es_objectWithContentsOfFile:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];

    if (data) {
        // attempt to deserialise data as a plist
        id object = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:NULL];
        if (object) {
            // check if object is an NSCoded unarchive
            if ([object respondsToSelector:@selector(objectForKeyedSubscript:)] && object[@"$archiver"]) {
                if (@available(iOS 12.0, *)) {
                    object = [NSKeyedUnarchiver unarchivedObjectOfClass:self.class fromData:data error:NULL];
                } else {
                    @try {
                        // -unarchiveObjectWithData: raises an NSInvalidArgumentException if data is not a valid archive.
                        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    } @catch (NSException *exception) {
                        object = nil;
                    }
                }
            }

            return object;
        }
    }

    return data;
}

- (BOOL)es_writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile
{
    // note: NSData, NSDictionary and NSArray already implement this method
    // and do not save using NSCoding, however the +es_objectWithContentsOfFile
    // method will correctly recover these objects anyway

    NSData *data = nil;

    if (@available(iOS 12.0, *)) {
        BOOL secureCoding = [self.class respondsToSelector:@selector(supportsSecureCoding)] && [self.class supportsSecureCoding];
        data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:secureCoding error:NULL];
    } else {
        data = [NSKeyedArchiver archivedDataWithRootObject:self];
    }

    return [data writeToFile:filePath atomically:useAuxiliaryFile];
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

@end
