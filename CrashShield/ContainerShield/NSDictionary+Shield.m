//
//  NSDictionary+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSDictionary+Shield.h"
#import "NMERecord.h"
#import <objc/runtime.h>
#import "NMEMethodSwizzling.h"

static BOOL hook_NSDictionary_dictionaryWithObjects() {
    static char associatedKey;
    Class hookClass = object_getClass([NSDictionary class]);
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(dictionaryWithObjects:forKeys:count:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSDictionary *(*hookOrginFunction)(Class self, SEL _cmd ,const id * objects ,const id<NSCopying> * keys ,NSUInteger cnt) = nil;
    id newImpBlock = ^NSDictionary *(Class self ,const id * objects ,const id<NSCopying> * keys ,NSUInteger cnt) {
    
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : NSDictionary constructor appear nil",
                                [self class], NSStringFromSelector(@selector(dictionaryWithObjects:forKeys:count:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            continue;
        }
        newObjects[index] = objects[i];
        newkeys[index] = keys[i];
        index++;
    }

    return hookOrginFunction ? hookOrginFunction(self,hookSel,newObjects, newkeys,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,newObjects, newkeys,index);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


@implementation NSDictionary (Shield)
+(void)registerNSDictionaryShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSDictionary_dictionaryWithObjects();
    });
}
@end
