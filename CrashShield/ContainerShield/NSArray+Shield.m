//
//  NSArray+Shield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSArray+Shield.h"
#import "NMERecord.h"
#import <objc/runtime.h>
#import "NMEMethodSwizzling.h"

#pragma mark - objectAtIndex:
static BOOL hook_NSArray_objectAtIndex() {
    static char associatedKey;
    Class hookClass = [NSArray class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(objectAtIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSArray* self, SEL _cmd ,NSUInteger index);
    
    id newImpBlock = ^id(NSArray* self ,NSUInteger index) {
        if (self.count == 0) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                                [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        if (index >= self.count) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                                [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSSingleObjectArrayI_objectAtIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSSingleObjectArrayI");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(objectAtIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) {
        return NO;
        
    }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block __attribute__((unused))
    id(*hookOrginFunction)(NSArray * self, SEL _cmd ,NSUInteger index) ;
    
    id newImpBlock = ^id(NSArray * self ,NSUInteger index) {
        
        if (self.count == 0) {
            
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                                [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        if (index >= self.count) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                                [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
    
}


static BOOL hook_NSArray0_objectAtIndex() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArray0");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(objectAtIndex:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSArray * self, SEL _cmd ,NSUInteger index);
    id newImpBlock = ^id(NSArray * self ,NSUInteger index) {
        
        
        if (self.count == 0) {
            
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                                [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        if (index >= self.count) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                                [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

#pragma mark - objectsAtIndexes:
static BOOL hook_NSArray0_objectsAtIndexes() {
    static char associatedKey;
    Class hookClass = [NSArray class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(objectsAtIndexes:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSArray * self, SEL _cmd , NSIndexSet * indexes);
    id newImpBlock = ^id(NSArray * self , NSIndexSet * indexes) {
        if ((self.count < indexes.lastIndex) && (indexes.lastIndex != LONG_MAX)) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : indexs %@ out of count %@ of array ",
                                [self class], NSStringFromSelector(@selector(objectsAtIndexes:)), @(indexes.lastIndex), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,indexes) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,indexes);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}


#pragma mark - objectAtIndexedSubscript:
static BOOL hook_NSArrayI_objectAtIndexedSubscript() {
    
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSArrayI");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(objectAtIndexedSubscript:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) {
        return NO;
    }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id(*hookOrginFunction)(NSArray *self, SEL _cmd ,NSUInteger index);
    id newImpBlock = ^id(NSArray * self ,NSUInteger index) {
        if (self.count == 0) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",[self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        if (index >= self.count) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ", [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
            return nil;
        }
        
        return hookOrginFunction ? hookOrginFunction(self,hookSel,index) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,index);
    };
    
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

#pragma mark - subarrayWithRange
static BOOL hook_NSArray_subarrayWithRange() {
    static char associatedKey;
    Class hookClass = [NSArray class];
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

static BOOL hook_NSArrayI_subarrayWithRange() {
    static char associatedKey;
    Class hookClass = object_getClass(NSClassFromString(@"__NSArrayI"));
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

static BOOL hook_NSSingleObjectArrayI_subarrayWithRange() {
    static char associatedKey;
    Class hookClass = object_getClass(NSClassFromString(@"__NSSingleObjectArrayI"));
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



#pragma mark - instance array
static BOOL hook_NSArrayI_arrayWithObjects_count() {
    static char associatedKey;
    Class hookClass = object_getClass(NSClassFromString(@"__NSArrayI"));
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(arrayWithObjects:count:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) {
        return NO;
        
    }
    if (!class_respondsToSelector(hookClass,hookSel)){ return NO; }
    __block NSArray *(*hookOrginFunction)(NSArray * self, SEL _cmd ,const id *objects ,NSUInteger cnt);
    id newImpBlock = ^NSArray *(NSArray * self ,const id *objects ,NSUInteger cnt) {
        
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            
            id objc = objects[i];
            if (objc == nil) {
                NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : Array constructor appear nil ",
                                    [self class], NSStringFromSelector(@selector(arrayWithObjects:count:))];
                
                [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
                continue;
            }
            newObjects[newObjsIndex++] = objc;
            
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,newObjects, newObjsIndex) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,newObjects, newObjsIndex);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSArray0_arrayWithObjects_count() {
    static char associatedKey;
    Class hookClass = object_getClass(NSClassFromString(@"__NSArray0"));
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(arrayWithObjects:count:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSArray *(*hookOrginFunction)(NSArray * self, SEL _cmd ,const id *objects ,NSUInteger cnt);
    id newImpBlock = ^NSArray *(NSArray * self ,const id *objects ,NSUInteger cnt) {
        
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            
            id objc = objects[i];
            if (objc == nil) {
                NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : Array constructor appear nil ",
                                    [self class], NSStringFromSelector(@selector(arrayWithObjects:count:))];
                
                [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
                continue;
            }
            newObjects[newObjsIndex++] = objc;
            
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,newObjects, newObjsIndex) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,newObjects, newObjsIndex);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC); hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSPlaceholderArray_initWithObjects_count() {
    static char associatedKey;
    Class hookClass = NSClassFromString(@"__NSPlaceholderArray");
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(initWithObjects:count:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSArray *(*hookOrginFunction)(NSArray * self, SEL _cmd ,const id *objects ,NSUInteger cnt) = NULL;
    id newImpBlock = ^NSArray *(NSArray * self ,const id *objects ,NSUInteger cnt) {
        
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            
            id objc = objects[i];
            if (objc == nil) {
                NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : Array constructor appear nil ",
                                    [self class], NSStringFromSelector(@selector(arrayWithObjects:count:))];
                
                [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
                continue;
            }
            newObjects[newObjsIndex++] = objc;
            
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,newObjects, newObjsIndex) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,newObjects, newObjsIndex);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSSingleObjectArrayI_arrayWithObjects_count() {
    static char associatedKey;
    Class hookClass = object_getClass(NSClassFromString(@"__NSSingleObjectArrayI"));
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(arrayWithObjects:count:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block NSArray *(*hookOrginFunction)(NSArray * self, SEL _cmd ,const id *objects ,NSUInteger cnt);
    id newImpBlock = ^NSArray *(NSArray * self ,const id *objects ,NSUInteger cnt) {
        
        
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            
            id objc = objects[i];
            if (objc == nil) {
                NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : Array constructor appear nil ",
                                    [self class], NSStringFromSelector(@selector(arrayWithObjects:count:))];
                
                [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeContainer];
                continue;
            }
            newObjects[newObjsIndex++] = objc;
            
        }
        return hookOrginFunction ? hookOrginFunction(self,hookSel,newObjects, newObjsIndex) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,newObjects, newObjsIndex);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation NSArray (Shield)
+ (void)registerNSArrayShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSArray_objectAtIndex();
        hook_NSSingleObjectArrayI_objectAtIndex();
        hook_NSArray0_objectAtIndex();
        hook_NSArray0_objectsAtIndexes();
        hook_NSArrayI_objectAtIndexedSubscript();
        hook_NSArray_subarrayWithRange();
        hook_NSArrayI_subarrayWithRange();
        hook_NSSingleObjectArrayI_subarrayWithRange();
        hook_NSSingleObjectArrayI_arrayWithObjects_count();
        hook_NSArrayI_arrayWithObjects_count();
        hook_NSArray0_arrayWithObjects_count();
        hook_NSPlaceholderArray_initWithObjects_count();
    });
}
@end
