//
//  NSMutableString+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSMutableString+Shield.h"
#import "NMECrashShield.h"

static BOOL hook_NSCFString_StringWithString() {
    static char associatedKey;
    Class hookClass = object_getClass([NSMutableString class]);
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(stringWithString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id (*hookOrginFunction)(Class self, SEL _cmd, NSString *string);
    
    id newImpBlock = ^id (Class self, NSString *string) {
        if (!string) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : init with nil string",
                                NSStringFromClass(self), NSStringFromSelector(@selector(stringWithString:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,string) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,string);
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


static BOOL hook_NSCFString_replaceCharactersInRange_withString() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(replaceCharactersInRange:withString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSString* self, SEL _cmd ,NSRange range, NSString *aString);
    
    id newImpBlock = ^void (NSString* self, NSRange range, NSString *aString) {
        if (!aString) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : aString is nil",
                                [self class], NSStringFromSelector(@selector(replaceCharactersInRange:withString:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : searchRange:%@ out of NSString Length%@",
                                [self class], NSStringFromSelector(@selector(replaceCharactersInRange:withString:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,range,aString) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,range,aString);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


static BOOL hook_NSCFString_insertString_atIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(insertString:atIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSString* self, SEL _cmd ,NSString *aString,NSUInteger loc);
    
    id newImpBlock = ^void (NSString* self, NSString *aString, NSUInteger loc) {
        if (!aString) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : aString is nil",
                                [self class], NSStringFromSelector(@selector(insertString:atIndex:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        
        if (self.length < loc) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : loc:%@ is out of NSString length:%@",
                                [self class], NSStringFromSelector(@selector(insertString:atIndex:)), @(loc), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,aString,loc) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,aString,loc);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSCFString_deleteCharactersInRange() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(deleteCharactersInRange:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSString* self, SEL _cmd ,NSRange range);
    
    id newImpBlock = ^void (NSString* self, NSRange range) {
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : searchRange:%@ out of NSString Length%@",
                                [self class], NSStringFromSelector(@selector(deleteCharactersInRange:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,range) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,range);
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation NSMutableString (Shield)
+(void)registerNSMutableStringShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSCFString_replaceCharactersInRange_withString();
        hook_NSCFString_insertString_atIndex();
        hook_NSCFString_deleteCharactersInRange();
        hook_NSCFString_StringWithString();
    });
}
@end
