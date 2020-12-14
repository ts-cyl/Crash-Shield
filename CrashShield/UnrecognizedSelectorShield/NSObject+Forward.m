//
//  NSObject+Forward.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSObject+Forward.h"
#import "NMERecord.h"
#import "NMEShieldStubObject.h"
#import "NMEMethodSwizzling.h"
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <objc/runtime.h>

static BOOL hook_NSObject_instance_forwardingTargetForSelector() {
    static char associatedKey;
    Class hookClass = [NSObject class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(forwardingTargetForSelector:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSObject* self, SEL _cmd ,SEL aSelector) = nil;
    id newImpBlock = ^id(NSObject* self ,SEL aSelector) {
        //---------------忽略系统的类---------------------
//        static struct dl_info app_info;
//        if (app_info.dli_saddr == nil) {
//            dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
//        }
//        struct dl_info self_info;
//        dladdr((__bridge void *)[self class], &self_info);
//
//
//        if (strcmp(app_info.dli_fname, self_info.dli_fname)) {
//            return hookOrginFunction ? hookOrginFunction(self,hookSel,aSelector) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,aSelector);
//        }
        //------------------------------------
        if ([self isKindOfClass:[NSNumber class]] && [NSString instancesRespondToSelector:aSelector]) {
            NSNumber *number = (NSNumber *)self;
            NSString *str = [number stringValue];
            return str;
        } else if ([self isKindOfClass:[NSString class]] && [NSNumber instancesRespondToSelector:aSelector]) {
            NSString *str = (NSString *)self;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            NSNumber *number = [formatter numberFromString:str];
            return number;
        }
        
        BOOL aBool = [self respondsToSelector:aSelector];
        NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
        
        if (aBool || signatrue) {
            return hookOrginFunction ? hookOrginFunction(self,hookSel,aSelector) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,aSelector);
        } else {
            NMEShieldStubObject *stub = [NMEShieldStubObject shareInstance];
            [stub addFunc:aSelector];
            
            NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to SmartFunction Object default implement like send message to nil.",
                                [self class], NSStringFromSelector(aSelector)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeUnrecognizedSelector];
            
            return stub;
        }
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
    
}

static BOOL hook_NSObject_class_forwardingTargetForSelector() {
    static char associatedKey;
    Class hookClass = object_getClass([NSObject class]);
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(forwardingTargetForSelector:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(Class self, SEL _cmd ,SEL aSelector) = nil;
    id newImpBlock = ^id(Class self ,SEL aSelector) {
        
        BOOL aBool = [self respondsToSelector:aSelector];
    
        NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
        
        if (aBool || signatrue) {
            return hookOrginFunction ? hookOrginFunction(self,hookSel,aSelector) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,aSelector);
        } else {
            [NMEShieldStubObject addClassFunc:aSelector];
            NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to SmartFunction Object default implement like send message to nil.",
                                [self class], NSStringFromSelector(aSelector) ];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeUnrecognizedSelector];
            
            return [NMEShieldStubObject class];
        }
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


@implementation NSObject (Forward)

+(void)registerNSObjectUnRecogziedSelectorShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSObject_instance_forwardingTargetForSelector();
        hook_NSObject_class_forwardingTargetForSelector();
    });
}
@end
