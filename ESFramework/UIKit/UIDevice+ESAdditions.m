//
//  UIDevice+ESInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIDevice+ESAdditions.h"
#import <sys/sysctl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "ESHelpers.h"

@implementation UIDevice (ESAdditions)

+ (void)load
{
    ESSwizzleInstanceMethod(self, @selector(systemName), @selector(es_systemName));
}

- (NSString *)es_systemName
{
    NSString *name = [self es_systemName];
    if ([name isEqualToString:@"iPhone OS"]) {
        name = @"iOS";
    }
    return name;
}

- (NSString *)platform
{
    static NSString *_platform = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = (char *)malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        _platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
    });
    return _platform;
}

- (nullable id)es_attributeOfFileSystemForKey:(NSFileAttributeKey)key
{
    return [NSFileManager.defaultManager attributesOfFileSystemForPath:ESPathForDocuments() error:NULL][key];
}

- (long long)diskFreeSize
{
    return [[self es_attributeOfFileSystemForKey:NSFileSystemFreeSize] longLongValue];
}

- (NSString *)diskFreeSizeString
{
    return [NSByteCountFormatter stringFromByteCount:self.diskFreeSize countStyle:NSByteCountFormatterCountStyleFile];
}

- (long long)diskSize
{
    return [[self es_attributeOfFileSystemForKey:NSFileSystemSize] longLongValue];
}

- (NSString *)diskSizeString
{
    return [NSByteCountFormatter stringFromByteCount:self.diskSize countStyle:NSByteCountFormatterCountStyleFile];
}

- (CGSize)screenSizeInPoints
{
    return UIScreen.mainScreen.bounds.size;
}

- (CGSize)screenSizeInPixels
{
    return UIScreen.mainScreen.currentMode.size;
}

- (BOOL)isJailbroken
{
    static BOOL _isJailbroken = NO;
#if !TARGET_IPHONE_SIMULATOR
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = @[
            @"/Application/Cydia.app",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/bin/bash",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/private/var/lib/cydia",
            @"/private/var/lib/apt",
        ];
        for (NSString *path in paths) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                _isJailbroken = YES;
                break;
            }
        }

        if (!_isJailbroken) {
            FILE *bash = fopen("/bin/bash", "r");
            if (bash) {
                fclose(bash);
                _isJailbroken = YES;
            }
        }

        if (!_isJailbroken && 0 == popen("ls", "r")) {
            _isJailbroken = YES;
        }

        if (!_isJailbroken) {
            NSString *path = [@"/private/" stringByAppendingString:ESUUID()];
            if ([@"foo" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
                _isJailbroken = YES;
            }
        }
    });
#endif
    return _isJailbroken;
}

- (nullable NSString *)carrierName
{
    return CTTelephonyNetworkInfo.new.subscriberCellularProvider.carrierName;
}

@end
