//
//  NSMutableArray+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSMutableArray+Shield.h"
#import "NMERecord.h"
#import <objc/runtime.h>
#import "NMEMethodSwizzling.h"

static BOOL hook_NSArrayM_objectAtIndexedSubscript() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArrayM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(objectAtIndexedSubscript:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSMutableArray * self, SEL _cmd ,NSUInteger index) = nil;
    id newImpBlock = ^id(NSMutableArray * self ,NSUInteger index) { 
        if (index >= self.count) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                                [self class], NSStringFromSelector(@selector(objectAtIndex:)),@(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeContainer)];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC); hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSArrayM_addObject() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArrayM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(addObject:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSMutableArray * self, SEL _cmd ,id anObject) = nil;
    id newImpBlock = ^void(NSMutableArray * self ,id anObject) { 
        if (!anObject) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : insert nil object  ",
                                [self class], NSStringFromSelector(@selector(addObject:))];
            
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeContainer)];
            return;
        }
        hookOrginFunction ? hookOrginFunction(self,hookSel,anObject) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,anObject);
        
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSArrayM_insertObject_atIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArrayM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(insertObject:atIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSMutableArray * self, SEL _cmd ,id anObject ,NSUInteger index) = nil;
    id newImpBlock = ^void(NSMutableArray * self ,id anObject ,NSUInteger index) { 
        if (!anObject) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : insert nil object  ",
                                [self class], NSStringFromSelector(@selector(insertObject:atIndex:))];
            
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeContainer)];
            return;
        }
        
        @try {
            hookOrginFunction ? hookOrginFunction(self,hookSel,anObject, index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,anObject, index);
        }@catch (NSException *exception) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                                [self class], NSStringFromSelector(@selector(insertObject:atIndex:)) ,@(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeContainer)];
        }@finally {
            
        }
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSArrayM_removeObjectAtIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArrayM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(removeObjectAtIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSMutableArray * self, SEL _cmd ,NSUInteger index) = nil;
    id newImpBlock = ^void(NSMutableArray * self ,NSUInteger index) { 
        if (index >= self.count) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                                [self class], NSStringFromSelector(@selector(removeObjectAtIndex:)) ,@(index), @(self.count)];
            
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeContainer)];
        } else {
            hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
        }
        
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSArrayM_subarrayWithRange() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArrayM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(subarrayWithRange:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSArray* (*hookOrginFunction)(NSArray * self, SEL _cmd , NSRange range);
    id newImpBlock = ^NSArray* (NSArray * self , NSRange range) {
        
        if (self.count < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : Array out of range:%@ ",
                                [self class], NSStringFromSelector(@selector(subarrayWithRange:)), NSStringFromRange(range)];
            
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel, range) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,range);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC); hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


static BOOL hook_NSArrayM_setObject_atIndexedSubscript() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArrayM");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(setObject:atIndexedSubscript:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSMutableArray * self, SEL _cmd ,id obj ,NSUInteger idx) = nil;
    id newImpBlock = ^void(NSMutableArray * self ,id obj ,NSUInteger idx) { 
        if (obj) {
            if (idx > self.count) {
                NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of marray ",
                                    [self class], NSStringFromSelector(@selector(setObject:atIndexedSubscript:)) ,@(idx), @(self.count)];
                [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeContainer)];
            } else {
                hookOrginFunction ? hookOrginFunction(self,hookSel,obj, idx) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,obj, idx);
            }
        } else {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : object appear nil obj is %@",
                                [self class], NSStringFromSelector(@selector(setObject:atIndexedSubscript:)), obj];
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeContainer)];
        }
        
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation NSMutableArray (Shield)

+(void)registerNSMutableArrayShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSArrayM_objectAtIndexedSubscript();
        hook_NSArrayM_addObject();
        hook_NSArrayM_insertObject_atIndex();
        hook_NSArrayM_removeObjectAtIndex();
        hook_NSArrayM_subarrayWithRange();
        hook_NSArrayM_setObject_atIndexedSubscript();
    });
}
@end
