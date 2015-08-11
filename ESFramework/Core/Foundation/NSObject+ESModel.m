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

ES_CATEGORY_FIX(NSObject_ESModel)

ESDefineAssociatedObjectKey(ESModelSharedInstance);
ESDefineAssociatedObjectKey(ESModelCodablePropertiesKeys);

@implementation NSObject (ESModel)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constructors

+ (instancetype)modelInstance
{
        return [[self alloc] init];
}

+ (instancetype)modelWithContentsOfFile:(NSString *)filePath
{
        if (!ESIsStringWithAnyText(filePath)) {
                return nil;
        }
        id object = nil;
        @try {
                object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        }
        @catch (NSException *exception) {
        }
        
        if ([object isKindOfClass:[self class]]) {
                return object;
        }
        
        return nil;
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
        self = [self init];
        if (self) {
                [self setModelWithCoder:aDecoder];
        }
        return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
        for (NSString *key in [[self class] modelCodablePropertiesKeys]) {
                id value = nil;
                @try {
                        value = [self valueForKey:key];
                }
                @catch (NSException *exception) {
                }
                
                if (value) {
                        [aCoder encodeObject:value forKey:key];
                }
        }
}

- (void)setModelWithCoder:(NSCoder *)aDecoder
{
        for (NSString *key in [[self class] modelCodablePropertiesKeys]) {
                id value = nil;
                @try {
                        value = [aDecoder decodeObjectForKey:key];
                }
                @catch (NSException *exception) {
                }
                if (value) {
                        [self setValue:value forKey:key];
                }
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Shared Instance

+ (instancetype)modelSharedInstance
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                id shared = [[self class] modelWithContentsOfFile:[self modelSharedInstanceFilePath]];
                if (!shared) {
                        shared = [self modelInstance];
                }
                ESSetAssociatedObject(self, ESModelSharedInstanceKey, shared, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
        return ESGetAssociatedObject(self, ESModelSharedInstanceKey);
}

+ (void)setModelSharedInstance:(id)instance
{
        if ([instance isKindOfClass:[self class]]) {
                ESSetAssociatedObject(self, ESModelSharedInstanceKey, instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else if (!instance) {
                ESSetAssociatedObject(self, ESModelSharedInstanceKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                NSString *filePath = [self modelSharedInstanceFilePath];
                if (filePath) {
                        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                }
        } else {
                printf("%s <Error> instance should be %s, but given %s.\n", __PRETTY_FUNCTION__, class_getName([self class]), class_getName([instance class]));
        }
}

+ (void)saveModelSharedInstance:(void (^)(BOOL result))block
{
        [[self modelSharedInstance] modelWriteToFile:[self modelSharedInstanceFilePath] atomically:YES withBlock:block];
}

+ (void)saveModelSharedInstance
{
        [[self modelSharedInstance] modelWriteToFile:[self modelSharedInstanceFilePath] atomically:YES];
}

+ (NSString *)modelSharedInstanceFilePath
{
        return ESPathForCachesResource(NSStringWith(@"ESModel/%@.archive", NSStringFromClass(self)));
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - File Access

- (void)modelWriteToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESDispatchOnDefaultQueue(^{
                BOOL res = [self modelWriteToFile:path atomically:useAuxiliaryFile];
                if (block) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                block(res);
                        });
                }
        });
}

- (BOOL)modelWriteToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
        if (!ESTouchDirectoryAtFilePath(path)) {
                return NO;
        }
        
        @try {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
                return [data writeToFile:path atomically:useAuxiliaryFile];
        }
        @catch (NSException *exception) {
                return NO;
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties Access

+ (NSArray *)modelCodablePropertiesKeys
{
        NSArray *_propertyKeys = ESGetAssociatedObject(self, ESModelCodablePropertiesKeysKey);
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
                                if (!isTypeCodable) {
                                        continue;
                                }
                                
                                // get property name
                                const char *propertyName = property_getName(property);
                                // printf("-----:%s\n", propertyName);
                                NSString *key = @(propertyName);
                                
                                // -Elf, maybe already exists,
                                // found this bug in "SQLitePersistentObject"
                                if ([keys containsObject:key]) {
                                        continue;
                                }
                                
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
                ESSetAssociatedObject(self, ESModelCodablePropertiesKeysKey, _propertyKeys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        [self.modelDictionaryRepresentation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [description appendFormat:@"%@ = %@\n", key, obj];
        }];
        [description appendFormat:@">"];
        return description;
}


@end
