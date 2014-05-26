//
//  ESJSONRequestOperation.m
//  ESFramework
//
//  Created by Elf Sundae on 5/26/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESJSONRequestOperation.h"

@implementation ESJSONRequestOperation

+ (NSSet *)acceptableContentTypes {        
        return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",
                @"text/html", @"text/plain", @"text/xml",
                @"application/octet-stream", @"application/javascript", @"multipart/form-data",
                @"application/gzip", @"application/xml", @"application/xhtml+xml", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
        return YES;
}

@end
