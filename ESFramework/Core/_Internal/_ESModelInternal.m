//
//  _ESModelInternal.m
//  ESFramework
//
//  Created by Elf Sundae on 5/8/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "_ESModelInternal.h"
#import "ESHash.h"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation NSString (_ESModelRepresentation)
- (id)es_propertyListRepresentation
{
        return self;
}

- (id)es_jsonRepresentation
{
        return self;
}

- (NSString *)es_shortDescription
{
        NSString *string = self;
        if (string.length > 16) {
                string = [[string substringToIndex:15] stringByAppendingString:@"..."];
        }
        return [NSString stringWithFormat:@"\"%@\"", string];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation NSNumber (_ESModelRepresentation)
- (id)es_propertyListRepresentation
{
        return self;
}

- (id)es_jsonRepresentation
{
        return self;
}

- (NSString *)es_shortDescription
{
        return self.description;
}
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation NSData (_ESModelRepresentation)
- (id)es_propertyListRepresentation
{
        return self;
}

- (id)es_jsonRepresentation
{
        return [self base64EncodedString];
}

@end



@implementation NSArray (_ESModelRepresentation)

@end


@implementation NSDictionary (_ESModelRepresentation)

@end


@implementation NSDate (_ESModelRepresentation)

@end
