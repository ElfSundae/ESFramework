//
//  ESValue.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESValue.h"

static NSNumberFormatter *__sharedNumberFormatter = nil;

@interface ESValue : NSObject
@end

@implementation ESValue

+ (void)load
{
        __sharedNumberFormatter = [[NSNumberFormatter alloc] init];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

int ESIntValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                return [obj intValue];
        }
        return 0;
}

unsigned int ESUIntValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
                return [obj unsignedIntValue];
        } else if ([obj isKindOfClass:[NSString class]]) {
                return [[__sharedNumberFormatter numberFromString:obj] unsignedIntValue];
        }
        return 0;
}

NSInteger ESIntegerValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                return [obj integerValue];
        }
        return 0;
}

NSUInteger ESUIntegerValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
                return [obj unsignedIntegerValue];
        } else if ([obj isKindOfClass:[NSString class]]) {
                return [[__sharedNumberFormatter numberFromString:obj] unsignedIntegerValue];
        }
        return 0;
}

long ESLongValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
                return [obj longValue];
        } else if ([obj isKindOfClass:[NSString class]]) {
                return [[__sharedNumberFormatter numberFromString:obj] longValue];
        }
        return 0;
}

unsigned long ESULongValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
                return [obj unsignedLongValue];
        } else if ([obj isKindOfClass:[NSString class]]) {
                return [[__sharedNumberFormatter numberFromString:obj] unsignedLongValue];
        }
        return 0;
}

long long ESLongLongValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                return [obj longLongValue];
        }
        return 0;
}

unsigned long long ESULongLongValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
                return [obj unsignedLongLongValue];
        } else if ([obj isKindOfClass:[NSString class]]) {
                return [[__sharedNumberFormatter numberFromString:obj] unsignedLongLongValue];
        }
        return 0;
}

float ESFloatValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                return [obj floatValue];
        }
        return 0.f;
}

double ESDoubleValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                return [obj doubleValue];
        }
        return 0.0;
}

BOOL ESBoolValue(id obj) {
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                return [obj boolValue];
        }
        return NO;
}

NSString *ESStringValue(id obj) {
        if ([obj isKindOfClass:[NSString class]]) {
                return obj;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
                return [(NSNumber *)obj stringValue];
        }
        return nil;
}

NSURL *ESURLValue(id obj) {
        if ([obj isKindOfClass:[NSURL class]]) {
                return obj;
        } else if (ESIsStringWithAnyText(obj)) {
                return [NSURL URLWithString:obj];
        }
        return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functions

BOOL ESIntVal(int *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                *var = [obj intValue];
                return YES;
        }
        return NO;
}

BOOL ESUIntVal(unsigned int *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]]) {
                *var = [obj unsignedIntValue];
                return YES;
        } else if ([obj isKindOfClass:[NSString class]]) {
                *var = [[__sharedNumberFormatter numberFromString:obj] unsignedIntValue];
                return YES;
        }
        return NO;
}

BOOL ESIntegerVal(NSInteger *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                *var = [obj integerValue];
                return YES;
        }
        return NO;
}

BOOL ESUIntegerVal(NSUInteger *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]]) {
                *var = [obj unsignedIntegerValue];
                return YES;
        } else if ([obj isKindOfClass:[NSString class]]) {
                *var = [[__sharedNumberFormatter numberFromString:obj] unsignedIntegerValue];
                return YES;
        }
        return NO;
}

BOOL ESLongVal(long *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]]) {
                *var = [obj longValue];
                return YES;
        } else if ([obj isKindOfClass:[NSString class]]) {
                *var = [[__sharedNumberFormatter numberFromString:obj] longValue];
                return YES;
        }
        return NO;
}

BOOL ESULongVal(unsigned long *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]]) {
                *var = [obj unsignedLongValue];
                return YES;
        } else if ([obj isKindOfClass:[NSString class]]) {
                *var = [[__sharedNumberFormatter numberFromString:obj] unsignedLongValue];
                return YES;
        }
        return NO;
}

BOOL ESLongLongVal(long long *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                *var = [obj longLongValue];
                return YES;
        }
        return NO;
}

BOOL ESULongLongVal(unsigned long long *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]]) {
                *var = [obj unsignedLongLongValue];
                return YES;
        } else if ([obj isKindOfClass:[NSString class]]) {
                *var = [[__sharedNumberFormatter numberFromString:obj] unsignedLongLongValue];
                return YES;
        }
        return NO;
}

BOOL ESFloatVal(float *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                *var = [obj floatValue];
                return YES;
        }
        return NO;
}

BOOL ESDoubleVal(double *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                *var = [obj doubleValue];
                return YES;
        }
        return NO;
}

BOOL ESBoolVal(BOOL *var, id obj)
{
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
                *var = [obj boolValue];
                return YES;
        }
        return NO;
}

BOOL ESStringVal(NSString **var, id obj)
{
        if ([obj isKindOfClass:[NSString class]]) {
                *var = obj;
                return YES;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
                *var = [obj stringValue];
                return YES;
        }
        return NO;
}

BOOL ESURLVal(NSURL **var, id obj)
{
        if ([obj isKindOfClass:[NSURL class]]) {
                *var = obj;
                return YES;
        }
        
        if (ESIsStringWithAnyText(obj)) {
                *var = [NSURL URLWithString:(NSString *)obj];
        }
        return NO;
}
