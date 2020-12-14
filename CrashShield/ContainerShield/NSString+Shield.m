//
//  NSString+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSString+Shield.h"
#import "NMECrashShield.h"

#pragma mark - characterAtIndex
static BOOL hook_NSCFConstantString_characterAtIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFConstantString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(characterAtIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block unichar (*hookOrginFunction)(NSString* self, SEL _cmd ,NSUInteger index);
    
    id newImpBlock = ^unichar (NSString* self,NSUInteger index) {
        
        if (self.length <= index) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of NSString Length ",
                                [self class], NSStringFromSelector(@selector(characterAtIndex:)), @(index), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return 0;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

#pragma mark - SubString
static BOOL hook_NSCFConstantString_substringFromIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFConstantString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(substringFromIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSString *(*hookOrginFunction)(NSString* self, SEL _cmd ,NSUInteger index);
    
    id newImpBlock = ^NSString *(NSString* self ,NSUInteger index) {
        if (self.length < index) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of NSString Length ",
                                [self class], NSStringFromSelector(@selector(substringFromIndex:)), @(index), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSCFConstantString_substringToIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFConstantString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(substringToIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSString *(*hookOrginFunction)(NSString* self, SEL _cmd ,NSUInteger index);
    
    id newImpBlock = ^NSString *(NSString* self ,NSUInteger index) {
        if (self.length < index) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of NSString Length ",
                                [self class], NSStringFromSelector(@selector(substringFromIndex:)), @(index), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


static BOOL hook_NSCFConstantString_substringWithRange() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFConstantString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(substringWithRange:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSString *(*hookOrginFunction)(NSString* self, SEL _cmd ,NSRange range);
    
    id newImpBlock = ^NSString *(NSString* self ,NSRange range) {
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : range %@ out of range %@ of NSString Length",
                                [self class], NSStringFromSelector(@selector(substringWithRange:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,range) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,range);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

#pragma mark - ReplaceString
static BOOL hook_NSCFConstantString_stringByReplacingOccurrencesOfString_withString() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFConstantString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(stringByReplacingOccurrencesOfString:withString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSString *(*hookOrginFunction)(NSString* self, SEL _cmd ,NSString *target, NSString *replacement);
    
    id newImpBlock = ^NSString *(NSString* self, NSString *target, NSString *replacement) {
        if (!target) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : target is nil",
                                [self class], NSStringFromSelector(@selector(stringByReplacingOccurrencesOfString:withString:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        if (!replacement) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : replacement is nil",
                                [self class], NSStringFromSelector(@selector(stringByReplacingOccurrencesOfString:withString:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,target,replacement) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,target,replacement);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


static BOOL hook_NSCFConstantString_stringByReplacingOccurrencesOfString_withString_options_range() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFConstantString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(stringByReplacingOccurrencesOfString:withString:options:range:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSString *(*hookOrginFunction)(NSString* self, SEL _cmd ,NSString *target, NSString *replacement,NSStringCompareOptions options, NSRange searchRange);
    
    id newImpBlock = ^NSString *(NSString* self, NSString *target, NSString *replacement,NSStringCompareOptions options, NSRange searchRange) {
        if (!target) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : target is nil",
                                [self class], NSStringFromSelector(@selector(stringByReplacingOccurrencesOfString:withString:options:range:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        if (!replacement) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : replacement is nil",
                                [self class], NSStringFromSelector(@selector(stringByReplacingOccurrencesOfString:withString:options:range:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        
        if (self.length < NSMaxRange(searchRange)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : searchRange:%@ out of NSString Length%@",
                                [self class], NSStringFromSelector(@selector(stringByReplacingOccurrencesOfString:withString:options:range:)), NSStringFromRange(searchRange), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,target,replacement,options,searchRange) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,target,replacement,options,searchRange);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSCFConstantString_stringByReplacingCharactersInRange_withString() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSCFConstantString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(stringByReplacingCharactersInRange:withString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSString *(*hookOrginFunction)(NSString* self, SEL _cmd ,NSRange range, NSString *replacement);
    
    id newImpBlock = ^NSString *(NSString* self, NSRange range, NSString *replacement) {
        if (!replacement) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : replacement is nil",
                                [self class], NSStringFromSelector(@selector(stringByReplacingOccurrencesOfString:withString:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        
        if (self.length < NSMaxRange(range)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : searchRange:%@ out of NSString Length%@",
                                [self class], NSStringFromSelector(@selector(stringByReplacingOccurrencesOfString:withString:options:range:)), NSStringFromRange(range), @(self.length)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,range,replacement) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,range,replacement);
    };

    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation NSString (Shield)
+(void)registerNSStringShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSCFConstantString_characterAtIndex();
        hook_NSCFConstantString_substringToIndex();
        hook_NSCFConstantString_substringFromIndex();
        hook_NSCFConstantString_substringWithRange();
        hook_NSCFConstantString_stringByReplacingCharactersInRange_withString();
        hook_NSCFConstantString_stringByReplacingOccurrencesOfString_withString();
        hook_NSCFConstantString_stringByReplacingOccurrencesOfString_withString_options_range();
    });
}
@end
