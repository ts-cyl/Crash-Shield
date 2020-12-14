//
//  NSMutableAttributedString+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/19.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSMutableAttributedString+Shield.h"
#import "NMECrashShield.h"

#pragma mark -ModifyNSMutableAttributedString

static BOOL hook_NSConcreteMutableAttributedString_addAttribute_value_range() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(addAttribute:value:range:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd , NSAttributedStringKey name, id value, NSRange range);
    
    id newImpBlock = ^void(NSMutableAttributedString* self , NSAttributedStringKey name, id value, NSRange range) {
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : range %@ out of range %@ of NSString Length",
                                [self class], NSStringFromSelector(@selector(addAttribute:value:range:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,name,value,range) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,name,value,range);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSConcreteMutableAttributedString_addAttributes_range() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(addAttributes:range:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd ,NSDictionary *attrs, NSRange range);
    
    id newImpBlock = ^void(NSMutableAttributedString* self ,NSDictionary *attrs,NSRange range) {
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : range %@ out of range %@ of NSString Length",
                                [self class], NSStringFromSelector(@selector(addAttributes:range:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,attrs,range) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,attrs,range);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSConcreteMutableAttributedString_removeAttribute_range() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(removeAttribute:range:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd ,NSAttributedStringKey name, NSRange range);
    id newImpBlock = ^void(NSMutableAttributedString* self ,NSAttributedStringKey name,NSRange range) {
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : range %@ out of range %@ of NSString Length",
                                [self class], NSStringFromSelector(@selector(removeAttribute:range:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,name,range) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,name,range);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


static BOOL hook_NSConcreteMutableAttributedString_setAttributes_range() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(setAttributes:range:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd ,NSDictionary *attrs, NSRange range);
    
    id newImpBlock = ^void(NSMutableAttributedString* self ,NSDictionary *attrs,NSRange range) {
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : range %@ out of range %@ of NSString Length",
                                [self class], NSStringFromSelector(@selector(setAttributes:range:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,attrs,range) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,attrs,range);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSConcreteMutableAttributedString_replaceCharactersInRange_withAttributedString() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(replaceCharactersInRange:withString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd , NSRange range, NSAttributedString *attrString);
    
    id newImpBlock = ^void(NSMutableAttributedString* self ,NSRange range, NSAttributedString *attrString) {
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : range %@ out of range %@ of NSString Length",
                                [self class], NSStringFromSelector(@selector(replaceCharactersInRange:withString:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,range,attrString) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,range,attrString);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSConcreteMutableAttributedString_insertAttributedString_atIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(insertAttributedString:atIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd , NSAttributedString *attrString, NSUInteger loc);
    
    id newImpBlock = ^void(NSMutableAttributedString* self, NSAttributedString *attrString, NSUInteger loc) {
        if (self.length < loc) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : loc:%@ out of length:%@",
                                [self class], NSStringFromSelector(@selector(insertAttributedString:atIndex:)), @(loc), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,attrString,loc) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,attrString,loc);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

#pragma mark - InitAttributedString
static BOOL hook_NSConcreteMutableAttributedString_initWithString() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(initWithString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSMutableAttributedString* (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd ,NSString *str);
    
    id newImpBlock = ^NSMutableAttributedString* (NSMutableAttributedString *self, NSString *str) {
        if (!str) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : str is nil",
                                [self class], NSStringFromSelector(@selector(initWithString:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,str) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,str);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


static BOOL hook_NSConcreteMutableAttributedString_initWithString_attributes() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteMutableAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(initWithString:attributes:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSMutableAttributedString* (*hookOrginFunction)(NSMutableAttributedString* self, SEL _cmd ,NSString *str, NSDictionary *attrs);
    
    id newImpBlock = ^NSMutableAttributedString* (NSMutableAttributedString *self, NSString *str, NSDictionary *attrs) {
        if (!str) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : str is nil",
                                [self class], NSStringFromSelector(@selector(initWithString:attributes:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,str,attrs) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,str,attrs);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation NSMutableAttributedString (Shield)

+(void)registerNSMutableAttributedStringShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSConcreteMutableAttributedString_addAttribute_value_range();
        hook_NSConcreteMutableAttributedString_addAttributes_range();
        hook_NSConcreteMutableAttributedString_removeAttribute_range();
        hook_NSConcreteMutableAttributedString_setAttributes_range();
        hook_NSConcreteMutableAttributedString_replaceCharactersInRange_withAttributedString();
        hook_NSConcreteMutableAttributedString_insertAttributedString_atIndex();
        hook_NSConcreteMutableAttributedString_initWithString();
        hook_NSConcreteMutableAttributedString_initWithString_attributes();
    });
}
@end
