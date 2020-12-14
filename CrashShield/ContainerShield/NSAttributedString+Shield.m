//
//  NSAttributedString+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/19.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSAttributedString+Shield.h"
#import "NMECrashShield.h"

#pragma mark - InitAttributedString
static BOOL hook_NSConcreteAttributedString_initWithString() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(initWithString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSAttributedString* (*hookOrginFunction)(NSAttributedString* self, SEL _cmd ,NSString *str);
    
    id newImpBlock = ^NSAttributedString* (NSAttributedString *self, NSString *str) {
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

static BOOL hook_NSConcreteAttributedString_initWithAttributedString() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(initWithAttributedString:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSAttributedString* (*hookOrginFunction)(NSAttributedString* self, SEL _cmd ,NSAttributedString *str);
    
    id newImpBlock = ^NSAttributedString* (NSAttributedString *self, NSAttributedString *str) {
        if (!str) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : str is nil",
                                [self class], NSStringFromSelector(@selector(initWithAttributedString:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,str) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,str);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSConcreteAttributedString_initWithString_attributes() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"NSConcreteAttributedString");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(initWithString:attributes:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSAttributedString* (*hookOrginFunction)(NSAttributedString* self, SEL _cmd ,NSString *str, NSDictionary *attrs);
    
    id newImpBlock = ^NSAttributedString* (NSAttributedString *self, NSString *str, NSDictionary *attrs) {
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


@implementation NSAttributedString (Shield)

+(void)registerNSAttributedStringShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSConcreteAttributedString_initWithString();
        hook_NSConcreteAttributedString_initWithAttributedString();
        hook_NSConcreteAttributedString_initWithString_attributes();
    });
}
@end
