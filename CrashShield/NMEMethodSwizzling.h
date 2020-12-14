//
//  NMEMethodSwizzling.h
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//
#import <objc/runtime.h>
static inline void* shield_hook_imp_function(Class clazz,
                               SEL   sel,
                               void  *newFunction) {
    Method oldMethod = class_getInstanceMethod(clazz, sel);
    BOOL succeed = class_addMethod(clazz,
                                   sel,
                                   (IMP)newFunction,
                                   method_getTypeEncoding(oldMethod));
    if (succeed) {//本类无该方法的实现（eg：继承至父类）
        return nil;
    } else {//本类有方法的实现，直接替换
        return method_setImplementation(oldMethod, (IMP)newFunction);
    }
}
