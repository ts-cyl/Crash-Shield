//
//  NMECrashShieldManager.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//
#import <objc/runtime.h>
#import "NMECrashShieldManager.h"
#import "NMECrashShield.h"

@implementation NMECrashShieldManager

+ (void)registerStabilitySDK {
    [self registerStabilityWithAbility:(NMEShieldTypeExceptDangLingPointer)];
}

+ (void)registerStabilityWithAbility:(NMEShieldType)ability {
    if (ability & NMEShieldTypeUnrecognizedSelector) {
        [self registerUnrecognizedSelector];
    }
    if (ability & NMEShieldTypeContainer) {
        [self registerContainer];
    }
    if (ability & NMEShieldTypeNSNull) {
        [self registerNSNull];
    }
    if (ability & NMEShieldTypeKVO) {
        [self registerKVO];
    }
    if (ability & NMEShieldTypeTimer) {
        [self registerTimer];
    }
    if (ability & NMEShieldTypeKVC) {
        [self registerKVC];
    }
    if (ability & NMEShieldTypeUITableView) {
        [self registerUITableView];
    }
}

+ (void)registerStabilityWithAbility:(NMEShieldType)ability withClassNames:(NSArray *)arr {
    if ((ability & NMEShieldTypeDangLingPointer) && [arr count]) {
        [self registerDanglingPointer:arr];
    }
    [self registerStabilityWithAbility:ability];
}

+ (void)registerNSNull {
    [NSNull registerNSNullShield];}

+ (void)registerContainer {
    
    [NSArray registerNSArrayShield];
    [NSMutableArray registerNSMutableArrayShield];
    [NSDictionary registerNSDictionaryShield];
    [NSMutableDictionary registerNSMutableDictionary];
    [NSString registerNSStringShield];
    [NSMutableString registerNSMutableStringShield];
    [NSAttributedString registerNSAttributedStringShield];
    [NSMutableAttributedString registerNSMutableAttributedStringShield];
}

+ (void)registerUnrecognizedSelector {
    [NSObject registerNSObjectUnRecogziedSelectorShield];
}

+ (void)registerKVO {
    [NSObject registerNSObjectKVOShield];
}

+ (void)registerKVC {
    [NSObject registerNSObjectKVC];
}


+ (void)registerTimer {
    [NSTimer registerNSTimerShiled];
}

+ (void)registerUITableView {
    [UITableView registerUITableViewShield];
}

+ (void)registerDanglingPointer:(NSArray *)arr {
    NSMutableArray *avaibleList = arr.mutableCopy;
    for (NSString *className in arr) {
        NSBundle *classBundle = [NSBundle bundleForClass:NSClassFromString(className)];
        if (classBundle != [NSBundle mainBundle]) {
            [avaibleList removeObject:className];
        }
    }
}

+ (void)registerRecordHandler:(nonnull id<NMERecordProtocol>)record {
    [NMERecord registerRecordHandler:record];
}

@end
