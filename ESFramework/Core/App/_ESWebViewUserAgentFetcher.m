//
//  _ESWebViewUserAgentFetcher.m
//  ESFramework
//
//  Created by Elf Sundae on 2016/12/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "_ESWebViewUserAgentFetcher.h"
#import "ESValue.h"

static UIWebView *__gWebView = nil;
static NSString *__gDefaultUserAgent = nil;

@interface _ESWebViewUserAgentFetcher () <UIWebViewDelegate>
@end

@implementation _ESWebViewUserAgentFetcher

+ (void)load
{
    [self fetchUserAgent];
}

+ (NSString *)defaultUserAgent
{
    return __gDefaultUserAgent;
}

+ (void)fetchUserAgent
{
    __gWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    __gWebView.delegate = (id<UIWebViewDelegate>)self;
    [__gWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://0x123.com"]]];
}

+ (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    __gDefaultUserAgent = ESStringValue(request.allHTTPHeaderFields[@"User-Agent"]);
    __gWebView = nil;
    
    return NO;
}

@end
