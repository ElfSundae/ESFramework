//
//  NSObject+ESModel.m
//  ESFramework
//
//  Created by Elf Sundae on 5/8/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSObject+ESModel.h"
#import <objc/runtime.h>
#import "NSDictionary+ESAdditions.h"

static const void *_es_codablePropertiesKeys = &_es_codablePropertiesKeys;

@implementation NSObject (ESModel)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constructors

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
        self = [self init];
        if (self) {
                [self modelSetWithCoder:aDecoder];
        }
        return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
        for (NSString *key in [[self class] modelCodablePropertiesKeys]) {
                id value = [self valueForKey:key];
                if (value) {
                        [aCoder encodeObject:value forKey:key];
                }
        }
}

- (void)modelSetWithCoder:(NSCoder *)aDecoder
{
        for (NSString *key in [[self class] modelCodablePropertiesKeys]) {
                id value = [aDecoder decodeObjectForKey:key];
                if (value) {
                        [self setValue:value forKey:key];
                }
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclass

+ (NSString *)modelFilePath
{
        return ESPathForLibraryResource(@"ESModel/%@.archive", NSStringFromClass(self));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constructors

+ (instancetype)modelWithContentsOfFile:(NSString *)filePath
{
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if ([object isKindOfClass:[self class]]) {
                return object;
        }
        return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties Access

+ (NSArray *)modelCodablePropertiesKeys
{
        NSArray *_propertyKeys = [self getAssociatedObject:_es_codablePropertiesKeys];
        if (!_propertyKeys) {
                NSMutableArray *keys = [NSMutableArray array];
                
                Class subclass = [self class];
                while (subclass != [NSObject class]) {
                        unsigned int propertyCount = 0;
                        objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
                        for (unsigned int i = 0; i < propertyCount; i++) {
                                
                                objc_property_t property = properties[i];
                                
                                // get property type
                                // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
                                BOOL isTypeCodable = NO;
                                char *propertyTypeEncoding = property_copyAttributeValue(property, "T");
                                //printf("+++++:%s\n", propertyTypeEncoding);
                                switch (propertyTypeEncoding[0]) {
                                        case '@':
                                        {
                                                // id
                                                if (strlen(propertyTypeEncoding) > 3) {
                                                        isTypeCodable = YES;
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
                                        {
                                                // NSNumber
                                                isTypeCodable = YES;
                                                break;
                                        }
                                        case '{':
                                        {
                                                // NSValue, struct(CGRect, CGSize, etc...)
                                                isTypeCodable = YES;
                                                break;
                                        }
                                        default:
                                                isTypeCodable = NO;
                                                break;
                                                
                                }
                                if (NO == isTypeCodable) {
                                        continue;
                                }
                                
                                // get property name
                                const char *propertyName = property_getName(property);
                                // printf("-----:%s\n", propertyName);
                                NSString *key = @(propertyName);
                                
                                char *ivar = property_copyAttributeValue(property, "V");
                                if (ivar) {
                                        // check if ivar has a KVC compliant name
                                        NSString *ivarName = @(ivar);
                                        if ([ivarName isEqualToString:key] ||
                                            [ivarName isEqualToString:[@"_" stringByAppendingString:key]]) {
                                                // no setter, but `setValue:forKey:` will still work
                                                [keys addObject:key];
                                        }
                                        free(ivar);
                                } else {
                                        // check if property is dynamic and readwrite
                                        char *dynamic = property_copyAttributeValue(property, "D");
                                        char *readonly = property_copyAttributeValue(property, "R");
                                        if (dynamic && !readonly) {
                                                // no setter, but `setValue:forKey:` will still work
                                                [keys addObject:key];
                                        }
                                        free(dynamic);
                                        free(readonly);
                                }
                        }
                        free(properties);
                        subclass = [subclass superclass];
                }
                
                // store keys
                _propertyKeys = (NSArray *)keys;
                [self setAssociatedObject_nonatomic_retain:_propertyKeys key:_es_codablePropertiesKeys];
        }
        return _propertyKeys;
}

- (NSDictionary *)modelDictionaryRepresentation
{
        return [self dictionaryWithValuesForKeys:[self.class modelCodablePropertiesKeys]];
}

- (NSString *)modelDescription
{
        NSMutableString *description = [NSMutableString string];
        [description appendFormat:@"<%@: %p:\n", [self class], self];
        [self.modelDictionaryRepresentation each:^(id key, id obj) {
                [description appendFormat:@"%@ = %@\n", key, obj];
        }];
        [description appendFormat:@">"];
        return description;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - File Access

- (void)modelWriteToFileWithBlock:(void (^)(BOOL result))block
{
        [self modelWriteToFile:[self.class modelFilePath] atomically:YES withBlock:block];
}

- (void)modelWriteToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESDispatchOnDefaultQueue(^{
                BOOL res = [self modelWriteToFile:path atomically:useAuxiliaryFile];
                if (block) {
                        block(res);
                }
        });
}

- (BOOL)modelWriteToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
        NSString *filePath = ESTouchFilePath(path);
        if (!filePath) {
                return NO;
        }
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        return [data writeToFile:path atomically:useAuxiliaryFile];
}

@end
