//
//  ESValue.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-3.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESValue.h"
#import "ESDefines.h"

NSNumberFormatter *ESSharedNumberFormatter(void)
{
        static NSNumberFormatter *__gSharedNumberFormatter = nil;
        static dispatch_once_t onceTokenNumberFormatter;
        dispatch_once(&onceTokenNumberFormatter, ^{
                __gSharedNumberFormatter = [[NSNumberFormatter alloc] init];
        });
        return __gSharedNumberFormatter;
}

NSNumber *NSNumberFromString(NSString *string)
{
        return ([string isKindOfClass:[NSString class]] ?
                [ESSharedNumberFormatter() numberFromString:string] :
                nil);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESValueWithDefault

int ESIntValueWithDefault(id obj, int defaultValue)
{
        return (([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) ?
                [obj intValue] : defaultValue);
}

unsigned int ESUIntValueWithDefault(id obj, unsigned int defaultValue)
{
        return ([obj isKindOfClass:[NSNumber class]] ? [obj unsignedIntValue] :
                ([obj isKindOfClass:[NSString class]] ? [NSNumberFromString(obj) unsignedIntValue] :
                 defaultValue));
}

NSInteger ESIntegerValueWithDefault(id obj, NSInteger defaultValue)
{
        return (([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) ?
                [obj integerValue] : defaultValue);
}

NSUInteger ESUIntegerValueWithDefault(id obj, NSUInteger defaultValue)
{
        return ([obj isKindOfClass:[NSNumber class]] ? [obj unsignedIntegerValue] :
                ([obj isKindOfClass:[NSString class]] ? [NSNumberFromString(obj) unsignedIntegerValue] :
                 defaultValue));
}

long ESLongValueWithDefault(id obj, long defaultValue)
{
        return ([obj isKindOfClass:[NSNumber class]] ? [obj longValue] :
                ([obj isKindOfClass:[NSString class]] ? [NSNumberFromString(obj) longValue] :
                 defaultValue));
}

unsigned long ESULongValueWithDefault(id obj, unsigned long defaultValue)
{
        return ([obj isKindOfClass:[NSNumber class]] ? [obj longValue] :
                ([obj isKindOfClass:[NSString class]] ? [NSNumberFromString(obj) longValue] :
                 defaultValue));
}

long long ESLongLongValueWithDefault(id obj, long long defaultValue)
{
        return (([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) ?
                [obj longLongValue] : defaultValue);
}

unsigned long long ESULongLongValueWithDefault(id obj, unsigned long long defaultValue)
{
        return ([obj isKindOfClass:[NSNumber class]] ? [obj unsignedLongLongValue] :
                ([obj isKindOfClass:[NSString class]] ? [NSNumberFromString(obj) unsignedLongLongValue] :
                 defaultValue));
}

float ESFloatValueWithDefault(id obj, float defaultValue)
{
        return (([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) ?
                [obj floatValue] : defaultValue);
}

double ESDoubleValueWithDefault(id obj, double defaultValue)
{
        return (([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) ?
                [obj doubleValue] : defaultValue);
}

BOOL ESBoolValueWithDefault(id obj, BOOL defaultValue)
{
        return (([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) ?
                [obj boolValue] : defaultValue);
}

NSString *ESStringValueWithDefault(id obj, NSString *defaultValue)
{
        return ([obj isKindOfClass:[NSString class]] ? obj :
                ([obj isKindOfClass:[NSNumber class]] ? [(NSNumber *)obj stringValue] : defaultValue));
}

NSURL *ESURLValueWithDefault(id obj, NSURL *defaultValue)
{
        return ([obj isKindOfClass:[NSURL class]] ? obj :
                (ESIsStringWithAnyText(obj) ? [NSURL URLWithString:obj] : defaultValue));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESValue

int ESIntValue(id obj)
{
        return ESIntValueWithDefault(obj, 0);
}

unsigned int ESUIntValue(id obj)
{
        return ESUIntValueWithDefault(obj, 0);
}

NSInteger ESIntegerValue(id obj)
{
        return ESIntegerValueWithDefault(obj, 0);
}

NSUInteger ESUIntegerValue(id obj)
{
        return ESUIntegerValueWithDefault(obj, 0);
}

long ESLongValue(id obj)
{
        return ESLongValueWithDefault(obj, 0);
}

unsigned long ESULongValue(id obj)
{
        return ESULongValueWithDefault(obj, 0);
}

long long ESLongLongValue(id obj)
{
        return ESLongLongValueWithDefault(obj, 0);
}

unsigned long long ESULongLongValue(id obj)
{
        return ESULongLongValueWithDefault(obj, 0);
}

float ESFloatValue(id obj)
{
        return ESFloatValueWithDefault(obj, 0.);
}

double ESDoubleValue(id obj)
{
        return ESDoubleValueWithDefault(obj, 0.0);
}

BOOL ESBoolValue(id obj)
{
        return ESBoolValueWithDefault(obj, NO);
}

NSString *ESStringValue(id obj)
{
        return ESStringValueWithDefault(obj, nil);
}

NSURL *ESURLValue(id obj)
{
        return ESURLValueWithDefault(obj, nil);
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
                *var = [NSNumberFromString(obj) unsignedIntValue];
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
                *var = [NSNumberFromString(obj) unsignedIntegerValue];
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
                *var = [NSNumberFromString(obj) longValue];
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
                *var = [NSNumberFromString(obj) unsignedLongValue];
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
                *var = [NSNumberFromString(obj) unsignedLongLongValue];
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
                return YES;
        }
        return NO;
}
