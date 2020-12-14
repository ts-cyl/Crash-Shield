//
//  NMERecord.h
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NMECrashShieldManager.h"

@interface NMERecord : NSObject
/**
 注册异常上报
 
 @param record 异常上报
 */
+ (void)registerRecordHandler:(nullable id<NMERecordProtocol>)record;

/**
 异常上报
 
 @param reason Sting 原因， maybe nil
 */
+ (void)recordFatalWithReason:(nullable NSString *)reason
                    errorType:(NMEShieldType)type;
@end
