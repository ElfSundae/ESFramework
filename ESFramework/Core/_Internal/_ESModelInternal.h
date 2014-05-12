//
//  _ESModelInternal.h
//  ESFramework
//
//  Created by Elf Sundae on 5/8/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDefines.h"

@protocol _ESModelRepresentation <NSObject>
@required
- (id)es_propertyListRepresentation;
- (id)es_jsonRepresentation;
- (NSString *)es_shortDescription;
@end


@interface NSString (_ESModelRepresentation) <_ESModelRepresentation>
- (id)es_propertyListRepresentation;
- (id)es_jsonRepresentation;
- (NSString *)es_shortDescription;
@end

@interface NSNumber (_ESModelRepresentation) <_ESModelRepresentation>
- (id)es_propertyListRepresentation;
- (id)es_jsonRepresentation;
- (NSString *)es_shortDescription;

@end

@interface NSData (_ESModelRepresentation) <_ESModelRepresentation>
- (id)es_propertyListRepresentation;
- (id)es_jsonRepresentation;
- (NSString *)es_shortDescription;
@end

@interface NSArray (_ESModelRepresentation) <_ESModelRepresentation>
- (id)es_propertyListRepresentation;
- (id)es_jsonRepresentation;
- (NSString *)es_shortDescription;

@end

@interface NSDictionary (_ESModelRepresentation) <_ESModelRepresentation>
- (id)es_propertyListRepresentation;
- (id)es_jsonRepresentation;
- (NSString *)es_shortDescription;
@end

@interface NSDate (_ESModelRepresentation) <_ESModelRepresentation>
- (id)es_propertyListRepresentation;
- (id)es_jsonRepresentation;
- (NSString *)es_shortDescription;
@end

