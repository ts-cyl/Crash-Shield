//
//  NMEShieldStubObject.h
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMEShieldStubObject : NSObject
- (instancetype)init __unavailable;

+ (NMEShieldStubObject *)shareInstance;
- (BOOL)addFunc:(SEL)sel;
+ (BOOL)addClassFunc:(SEL)sel;

@end
