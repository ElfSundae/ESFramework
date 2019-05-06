//
//  UIDevice+ESInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIDevice+ESAdditions.h"
#import <sys/sysctl.h>
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

- (NSString *)modelIdentifier
{
    static NSString *_modelIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
        _modelIdentifier = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = (char *)malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        _modelIdentifier = @(machine);
        free(machine);
#endif
    });
    return _modelIdentifier;
}
}

- (long long)diskTotalSpace
{
    return [[[NSFileManager.defaultManager attributesOfFileSystemForPath:NSHomeDirectory() error:NULL]
             objectForKey:NSFileSystemSize] longLongValue];
}

- (NSString *)diskTotalSpaceString
{
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    formatter.adaptive = NO;
    return [formatter stringFromByteCount:self.diskTotalSpace];
}

- (long long)diskFreeSpace
{
    if (@available(iOS 11.0, *)) {
        return [[[[NSURL fileURLWithPath:NSHomeDirectory()] resourceValuesForKeys:@[ NSURLVolumeAvailableCapacityForImportantUsageKey ] error:NULL]
                 objectForKey:NSURLVolumeAvailableCapacityForImportantUsageKey] longLongValue];
    } else {
        return [[[NSFileManager.defaultManager attributesOfFileSystemForPath:NSHomeDirectory() error:NULL]
                 objectForKey:NSFileSystemFreeSize] longLongValue];
    }
}

- (NSString *)diskFreeSpaceString
{
    return [NSByteCountFormatter stringFromByteCount:self.diskFreeSpace countStyle:NSByteCountFormatterCountStyleFile];
}

- (long long)diskUsedSpace
{
    return self.diskTotalSpace - self.diskFreeSpace;
}

- (NSString *)diskUsedSpaceString
{
    return [NSByteCountFormatter stringFromByteCount:self.diskUsedSpace countStyle:NSByteCountFormatterCountStyleFile];
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

@end
