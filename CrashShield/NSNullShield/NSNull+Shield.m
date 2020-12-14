//
//  NSNull+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSNull+Shield.h"
#import "NMECrashShield.h"

static BOOL hook_NSNull_forwardingTargetForSelector() {
    static char associatedKey;
    Class hookClass = [NSNull class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(forwardingTargetForSelector:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSNull* self, SEL _cmd ,SEL aSelector) = nil;
    id newImpBlock = ^id(NSNull* self ,SEL aSelector) {
    
        static NSArray *sTmpOutput = nil;
        if (sTmpOutput == nil) {
            sTmpOutput = @[@"", @0, @[], @{}];
        }
        
        for (id tmpObj in sTmpOutput) {
            if ([tmpObj respondsToSelector:aSelector]) {
                return tmpObj;
            }
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,aSelector) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,aSelector);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation NSNull (Shield)
+(void)registerNSNullShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSNull_forwardingTargetForSelector();
    });
}
@end
