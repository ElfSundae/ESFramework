//
//  ESHTTPClient.h
//  ESFramework
//
//  Created by Elf Sundae on 5/25/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <ESFrameworkCore/ESFrameworkCore.h>
#import "AFNetworking.h"
#import "ESJSONRequestOperation.h"

/**
 * `ESHTTPClient` and `ESHTTPxxxxClient` sets are designed as a super class for subclassing.
 *
 * Subclasses needs implement `-initWithBaseURL:` to give a baseURL.
 *
 *	@interface YouHTTPClient : ESHTTPJSONClient
 *	@end
 *
 *	@implementation YouHTTPClient
 *
 *	- (id)initWithBaseURL:(NSURL *)url
 *	{
 *	        self = [super initWithBaseURL:NSURLWith(@"http://example.com/")];
 *	        if (self) {
 *	                [self setDefaultHeader:@"Accept-Encoding" value:@"gzip"];
 *	                self.parameterEncoding = AFJSONParameterEncoding;
 *	                [self registerHTTPOperationClass:[ESJSONRequestOperation class]];
 *	        }
 *	        return self;
 *	}
 *	
 *	@end
 *
 *
 * + ESHTTPClient has set "User-Agent" header with `[ESApp sharedApp].userAgent`
 *
 */
@interface ESHTTPClient : AFHTTPClient
ES_SINGLETON_DEC(sharedClient);
@end

/**
 * `ESHTTPJSONClient` will  handle all HTTP response as JSON.
 *
 * It has set default headers:
 *
 *      "Accept-Encoding" => "gzip"
 *
 */
@interface ESHTTPJSONClient : ESHTTPClient
@end

@interface NSError (ESHTTPClient)
- (BOOL)isHTTPNetworkError;
- (BOOL)isHTTPResponseDecodingError;
@end
