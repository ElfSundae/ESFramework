//
//  ESAppUpdateData.h
//  ESFramework
//
//  Created by Elf Sundae on 5/17/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ESModel.h"

/**
 * App Update Result.
 */
typedef NS_ENUM(NSUInteger, ESAppUpdateResult) {
        /**
         * No updates.
         */
        ESAppUpdateResultNone           = 0,
        /**
         * Exists a new version, and it is a optional update.
         */
        ESAppUpdateResultOptional       = 1 << 0,
        /**
         * Exists a new version, and it is must be forced updated.
         * In this case, you should call `exit(0);` after showing alert.
         */
        ESAppUpdateResultForced         = 1 << 1,
};

/**
 * Condition mask that used to detect if should alert.
 * For example, when app is just launched you may want only alert when there's truely a new version,
 * and in "App Setting => Check Updates", you may want alert no matter how.
 *
 */
typedef NS_ENUM(NSUInteger, ESAppUpdateAlertMask) {
        /**
         * Don't show alert.
         */
        ESAppUpdateAlertMaskNone         = 0,
        /**
         * Only show alert when updates exist.
         */
        ESAppUpdateAlertMaskExistUpdates = (ESAppUpdateResultOptional | ESAppUpdateResultForced),
        /**
         * Only show alert when there's a forced update.
         */
        ESAppUpdateAlertMaskOnlyForced   = ESAppUpdateResultForced,
        /**
         * Shows alert no matter how.
         */
        ESAppUpdateAlertMaskAll          = 0xFF,
};

/**
 * Data model for app updates.
 *
 * Call `-fillWithDictionary:` when you get information from your server, you should subclass
 * and implement `-fillWithDictionary:` method, and you should call `-save` within `-fillWithDictionary`
 * or the outside.
 *
 * To show a "Check Update" alert when app launch (and there's a new version), or when the user
 * tapped "Check Update" in app's "Settings", you can call `[ESApp showAppUpdateAlert:alertMask:]`.
 *
 * `ESAppUpdateObject` will be backed by filesystem, thus you can check `updateResult`
 * to detect if there's a forced update when app launched even if the device's network connection
 * is no reached, that you can `showAppUpdateAlert`, `exit(0)` will be called after alert dismissed.
 * **Note** in this situation you may check `+[ESApp isFreshLaunch:]` at first.
 *
 */
@interface ESAppUpdateObject : NSObject

@property (nonatomic) ESAppUpdateResult updateResult;
/**
 * If it's not provided, `[ESApp sharedApp].appID` will be used.
 */
@property (nonatomic, copy) NSString *updateURL;

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertTitleForUpdateExists;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, copy) NSString *alertUpdateButtonTitle;
@property (nonatomic, copy) NSString *alertCancelButtonTitle;

/**
 * Shared instance.
 */
+ (instancetype)sharedObject;
/**
 * Destory shared instance from memory.
 * Called after using `+data`
 */
+ (void)destorySharedObject;
/**
 * Cached to file.
 */
- (void)save;

///=============================================
/// @name Subclass
///=============================================

/**
 * Set properties.
 */
- (void)fillWithDictionary:(NSDictionary *)dictionary;

@end
