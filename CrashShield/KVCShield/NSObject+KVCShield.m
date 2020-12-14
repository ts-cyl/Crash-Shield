//
//  NSObject+KVC.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/19.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSObject+KVCShield.h"
#import "NMECrashShield.h"

static BOOL hook_NSObject_setValue_forUndefinedKey() {
    static char associatedKey;
    Class hookClass = [NSObject class];
    SEL hookSel = @selector(setValue:forUndefinedKey:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSObject *self, SEL _cmd ,id value, NSString *key) = nil;
    id newImpBlock = ^void(NSObject *self ,id value, NSString *key) {

        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason:%@ is not key value coding-compliant for the key:%@",
                            [self class], NSStringFromSelector(@selector(setValue:forUndefinedKey:)),[self class],key];
        [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeKVC];

    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


@implementation NSObject (KVC)
+(void)registerNSObjectKVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSObject_setValue_forUndefinedKey();
    });
}
@end
