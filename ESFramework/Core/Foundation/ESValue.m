//
//  ESValue.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESValue.h"

static NSNumberFormatter *__sharedNumberFormatter = nil;

@implementation ESValue

+ (void)load
{
        @autoreleasepool {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                        __sharedNumberFormatter = [[NSNumberFormatter alloc] init];
                });
        }
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
BOOL ESIntVal(int *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj intValue];
                return YES;
        }
        return NO;
}

BOOL ESUIntVal(unsigned int *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedIntValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__sharedNumberFormatter numberFromString:obj] unsignedIntValue];
                        return YES;
                }
        }
        return NO;
}

BOOL ESIntegerVal(NSInteger *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj integerValue];
                return YES;
        }
        return NO;
}

BOOL ESUIntegerVal(NSUInteger *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedIntegerValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__sharedNumberFormatter numberFromString:obj] unsignedIntegerValue];
                        return YES;
                }
        }
        return NO;
}

BOOL ESLongVal(long *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj longValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__sharedNumberFormatter numberFromString:obj] longValue];
                        return YES;
                }
        }
        return NO;
}

BOOL ESULongVal(unsigned long *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedLongValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__sharedNumberFormatter numberFromString:obj] unsignedLongValue];
                        return YES;
                }
        }
        return NO;
}

BOOL ESLongLongVal(long long *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj longLongValue];
                return YES;
        }
        return NO;
}

BOOL ESULongLongVal(unsigned long long *var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj unsignedLongLongValue];
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]]) {
                        *var = [[__sharedNumberFormatter numberFromString:obj] unsignedLongLongValue];
                        return YES;
                }
        }
        return NO;
}

BOOL ESFloatVal(float *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj floatValue];
                return YES;
        }
        return NO;
}

BOOL ESDoubleVal(double *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj doubleValue];
                return YES;
        }
        return NO;
}

/**
 * If @obj is a NSString instance, returns YES on encountering one of "Y",
 * "y", "T", "t", or a digit 1-9. It ignores any trailing characters.
 */
BOOL ESBoolVal(BOOL *var, id obj)
{
        if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                *var = [obj boolValue];
                return YES;
        }
        return NO;
}

BOOL ESStringVal(NSString **var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSString class]]) {
                        *var = obj;
                        return YES;
                } else if ([obj isKindOfClass:[NSNumber class]]) {
                        *var = [obj stringValue];
                        return YES;
                }
        }
        return NO;
}

BOOL ESURLVal(NSURL **var, id obj)
{
        if (obj) {
                if ([obj isKindOfClass:[NSURL class]]) {
                        *var = obj;
                        return YES;
                } else if ([obj isKindOfClass:[NSString class]] && ![(NSString *)obj isEqualToString:@""]) {
                        *var = [NSURL URLWithString:(NSString *)obj];
                        return YES;
                }
        }
        return NO;
}
