//
//  NMECrashShieldManager.h
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, NMEShieldType) {
    NMEShieldTypeUnrecognizedSelector = 1 << 1,
    NMEShieldTypeContainer = 1 << 2,
    NMEShieldTypeNSNull = 1 << 3,
    NMEShieldTypeKVO = 1 << 4,
    NMEShieldTypeTimer = 1 << 5,
    NMEShieldTypeKVC = 1 << 6,
    NMEShieldTypeUITableView = 1 << 7,
    NMEShieldTypeDangLingPointer = 1 << 8,
    NMEShieldTypeExceptDangLingPointer = (NMEShieldTypeUnrecognizedSelector | NMEShieldTypeContainer |
                                          NMEShieldTypeNSNull| NMEShieldTypeKVO | NMEShieldTypeTimer | NMEShieldTypeKVC | NMEShieldTypeUITableView)
};

@protocol NMERecordProtocol <NSObject>

- (void)recordWithReason:(NSError *)reason;

@end

@interface NMECrashShieldManager : NSObject

/**
 注册异常上报
 */
+ (void)registerRecordHandler:(id<NMERecordProtocol>)record;

/**
 开始防崩策略，默认只要开启就打开防Crash
 */
+ (void)registerStabilitySDK;

/**
 注册指定的防崩策略（目前不支持野指针）
 
 @param ability ability
 */
+ (void)registerStabilityWithAbility:(NMEShieldType)ability;

/**
 野指针防护，需要过滤系统类
 
 @param ability ability description
 @param classNames 野指针类列表
 */
+ (void)registerStabilityWithAbility:(NMEShieldType)ability withClassNames:(nonnull NSArray<NSString *> *)classNames;
@end

NS_ASSUME_NONNULL_END
