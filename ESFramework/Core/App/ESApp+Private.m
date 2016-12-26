//
//  ESApp+Private.m
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"
#import "ESValue.h"
#import "NSUserDefaults+ESAdditions.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - _ESAppFetchWebViewUserAgent

static UIWebView *__gWebViewForFetchingUserAgent = nil;
static NSString *__gWebViewDefaultUserAgent = nil;

NSString *_ESWebViewDefaultUserAgent(void)
{
    return __gWebViewDefaultUserAgent;
}

@interface _ESAppFetchWebViewUserAgent : NSObject <UIWebViewDelegate>
@end

@implementation _ESAppFetchWebViewUserAgent

+ (void)load
{
    [self fetchUserAgent];
}

+ (void)fetchUserAgent
{
    if (__gWebViewForFetchingUserAgent || __gWebViewDefaultUserAgent) {
        return;
    }
    __gWebViewForFetchingUserAgent = [[UIWebView alloc] initWithFrame:CGRectZero];
    __gWebViewForFetchingUserAgent.delegate = (id<UIWebViewDelegate>)self;
    [__gWebViewForFetchingUserAgent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0x123.com"]]];
}

+ (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    __gWebViewDefaultUserAgent = ESStringValue(request.allHTTPHeaderFields[@"User-Agent"]);
    __gWebViewForFetchingUserAgent = nil;
    return NO;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (_Private)

@implementation ESApp (_Private)
@end
