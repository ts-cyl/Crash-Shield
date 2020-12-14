//
//  NSMutableDictionary+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSMutableDictionary+Shield.h"
#import "NMERecord.h"
#import <objc/runtime.h>
#import "NMEMethodSwizzling.h"

static BOOL hook_NSDictionaryM_setObject_forKey() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSDictionaryM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(setObject:forKey:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSMutableDictionary * self, SEL _cmd ,id anObject ,id<NSCopying>aKey) = nil;
    id newImpBlock = ^void(NSMutableDictionary * self ,id anObject ,id<NSCopying>aKey) {
        if (anObject && aKey) {
            hookOrginFunction ? hookOrginFunction(self,hookSel,anObject,aKey) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,anObject,aKey);
        } else {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : key or value appear nil- key is %@, obj is %@",
                                [self class], NSStringFromSelector(@selector(setObject:forKey:)),aKey, anObject];
            
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
        }
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSDictionaryM_setObject_forKeyedSubscript() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSDictionaryM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(setObject:forKeyedSubscript:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSMutableDictionary * self, SEL _cmd ,id anObject ,id<NSCopying>aKey) = nil;
    id newImpBlock = ^void(NSMutableDictionary * self ,id anObject ,id<NSCopying>aKey) {
        if (anObject && aKey) {
            hookOrginFunction ? hookOrginFunction(self,hookSel,anObject,aKey) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,anObject,aKey);
        } else {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : key or value appear nil- key is %@, obj is %@",
                                [self class], NSStringFromSelector(@selector(setObject:forKeyedSubscript:)),aKey, anObject];
            
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
        }
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSDictionaryM_removeObjectForKey() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSDictionaryM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(removeObjectForKey:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSMutableDictionary * self, SEL _cmd ,id<NSCopying>aKey) = nil;
    id newImpBlock = ^void(NSMutableDictionary * self ,id<NSCopying>aKey) {
        if (aKey) {
            hookOrginFunction ? hookOrginFunction(self,hookSel,aKey) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,aKey);
        } else {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : key appear nil- key is %@.",
                                [self class], NSStringFromSelector(@selector(setObject:forKey:)),aKey];
            
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
        }
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation NSMutableDictionary (Shield)

+(void)registerNSMutableDictionary{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSDictionaryM_setObject_forKey();
        hook_NSDictionaryM_setObject_forKeyedSubscript();
        hook_NSDictionaryM_removeObjectForKey();
    });
}
@end
