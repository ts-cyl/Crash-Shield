//
//  NSTimer+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSTimer+Shield.h"
#import "NMERecord.h"
#import <objc/runtime.h>
#import "NMEMethodSwizzling.h"

@interface NMETimerProxy : NSObject

@property (nonatomic, weak) NSTimer *sourceTimer;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL aSelector;

@end

@implementation NMETimerProxy

- (void)trigger:(id)userinfo  {
    id strongTarget = self.target;
    if (strongTarget && ([strongTarget respondsToSelector:self.aSelector])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.aSelector withObject:userinfo];
#pragma clang diagnostic pop
    } else {
        NSTimer *sourceTimer = self.sourceTimer;
        if (sourceTimer) {
            [sourceTimer invalidate];
        }
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error target is %@ method is %@, reason : an object dealloc not invalidate Timer.",[self class], NSStringFromSelector(self.aSelector)];
        
        [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeTimer)];
    }
}

@end

@interface NSTimer (ShieldProperty)

@property (nonatomic, strong) NMETimerProxy *timerProxy;

@end

static BOOL hook_NSTimer_scheduledTimerWithTimeInterval() {
    static char associatedKey;
    Class hookClass = object_getClass([NSTimer class]);
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSTimer *(*hookOrginFunction)(Class self, SEL _cmd ,NSTimeInterval ti ,id aTarget ,SEL aSelector ,id userInfo ,BOOL yesOrNo) = nil;
    id newImpBlock = ^NSTimer *(Class self ,NSTimeInterval ti ,id aTarget ,SEL aSelector ,id userInfo ,BOOL yesOrNo) {
    
        if (yesOrNo) {
            NSTimer *timer = nil ;
            @autoreleasepool {
                NMETimerProxy *proxy = [NMETimerProxy new];
                proxy.target = aTarget;
                proxy.aSelector = aSelector;
                timer.timerProxy = proxy;
                timer = hookOrginFunction ? hookOrginFunction(self,hookSel,ti, proxy, @selector(trigger:), userInfo, yesOrNo) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,ti, proxy, @selector(trigger:), userInfo, yesOrNo);
                proxy.sourceTimer = timer;
            }
            return timer;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,ti, aTarget, aSelector, userInfo, yesOrNo) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,ti, aTarget, aSelector, userInfo, yesOrNo);
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


@implementation NSTimer (Shield)

- (void)setTimerProxy:(NMETimerProxy *)timerProxy {
    objc_setAssociatedObject(self, @selector(timerProxy), timerProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NMETimerProxy *)timerProxy {
    return objc_getAssociatedObject(self, @selector(timerProxy));
}

+(void)registerNSTimerShiled{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSTimer_scheduledTimerWithTimeInterval();
    });
}
@end
