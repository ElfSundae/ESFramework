//
//  ESApp+WebViewUserAgent.m
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"

@interface _ESAppInternalWebViewDelegate : NSObject  <UIWebViewDelegate>
@end

@implementation _ESAppInternalWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        [ESApp _es_setDefaultWebViewUserAgent:request.allHTTPHeaderFields[@"User-Agent"]];
        return NO;
}

@end

static UIWebView *_esWebViewForFetchingUserAgent = nil;
static _ESAppInternalWebViewDelegate *_esWebViewForFetchingUserAgentDelegate = nil;

@implementation ESApp (WebViewUserAgent)

+ (void)_es_getDefaultWebViewUserAgent
{
        if (_esWebViewForFetchingUserAgent != nil) {
                return;
        }
        
        _esWebViewForFetchingUserAgent = [[UIWebView alloc] initWithFrame:CGRectZero];
        _ESAppInternalWebViewDelegate *delegate = [[_ESAppInternalWebViewDelegate alloc] init];
        _esWebViewForFetchingUserAgentDelegate = delegate;
        _esWebViewForFetchingUserAgent.delegate = delegate;
        [_esWebViewForFetchingUserAgent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0x123.com"]]];
}

+ (void)_es_setDefaultWebViewUserAgent:(NSString *)userAgent
{
        if (ESIsStringWithAnyText(userAgent)) {
                [ESApp sharedApp]->_esWebViewDefaultUserAgent = userAgent;
        }
        
        _esWebViewForFetchingUserAgent.delegate = nil;
        [_esWebViewForFetchingUserAgent stopLoading];
        _esWebViewForFetchingUserAgent = nil;
        _esWebViewForFetchingUserAgentDelegate = nil;
}

@end
