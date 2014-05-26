//
//  ESHTTPClient.m
//  ESFramework
//
//  Created by Elf Sundae on 5/25/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESHTTPClient.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESHTTPClient

@implementation ESHTTPClient

+ (void)load
{
        @autoreleasepool {
                [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        }
}

ES_SINGLETON_IMP(sharedClient);

- (instancetype)init
{
        return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
        self = [super initWithBaseURL:url];
        if (self) {
                [self setDefaultHeader:@"User-Agent" value:[ESApp sharedApp].userAgent];
        }
        return self;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESHTTPJSONClient
@implementation ESHTTPJSONClient

- (id)initWithBaseURL:(NSURL *)url
{
        self = [super initWithBaseURL:NSURLWith(@"http://phone.app100646015.twsapp.com/")];
        if (self) {
                [self registerHTTPOperationClass:[ESJSONRequestOperation class]];
                [self setDefaultHeader:@"Accept-Encoding" value:@"gzip"];
        }
        return self;
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSError

@implementation NSError (ESHTTPClient)

- (BOOL)isHTTPNetworkError
{
        if ([self.domain isEqualToString:NSURLErrorDomain]) {
                NSInteger code = self.code;
                return (NSURLErrorTimedOut == code ||
                        NSURLErrorCannotFindHost == code ||
                        NSURLErrorCannotConnectToHost == code ||
                        NSURLErrorNetworkConnectionLost == code ||
                        NSURLErrorDNSLookupFailed == code ||
                        NSURLErrorNotConnectedToInternet == code);
        }
        return NO;
}

- (BOOL)isHTTPResponseDecodingError
{
        if ([self.domain isEqualToString:AFNetworkingErrorDomain]) {
                return (NSURLErrorCannotDecodeContentData == self.code);
        }
        return NO;
}

@end