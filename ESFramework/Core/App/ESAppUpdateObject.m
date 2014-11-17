//
//  ESAppUpdateData.m
//  ESFramework
//
//  Created by Elf Sundae on 5/17/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESAppUpdateObject.h"
#import "NSString+ESAdditions.h"
#import "ESApp.h"

@implementation ESAppUpdateObject

- (instancetype)init
{
        self = [super init];
        if (self) {
                _alertTitle = ESLocalizedString(@"Check Updates");
                _alertTitleForUpdateExists = _alertTitle;
                _alertUpdateButtonTitle = ESLocalizedString(@"Update Now");
                _alertCancelButtonTitle = ESLocalizedString(@"Cancel");
        }
        return self;
}

- (NSString *)updateURL
{
        if (!_updateURL || [_updateURL isEmpty]) {
                return [[ESApp sharedApp].appID appLinkForAppStore];
        }
        return _updateURL;
}

+ (instancetype)sharedObject
{
        return [self modelSharedInstance];
}

+ (void)destorySharedObject
{
        [self setModelSharedInstance:nil];
}

- (void)save
{
        //TODO:
#warning todo
        //[self saveModelSharedInstance];
}

- (void)fillWithDictionary:(NSDictionary *)dictionary
{
        
}

@end
