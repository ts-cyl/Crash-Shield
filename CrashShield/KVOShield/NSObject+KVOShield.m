//
//  NSObject+KVOShield.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NSObject+KVOShield.h"
#import "NMERecord.h"
#import <pthread.h>
#import <objc/runtime.h>
#import "NMEMethodSwizzling.h"

static void(*hookOrginFunction_removeObserver)(NSObject* self, SEL _cmd ,NSObject *observer ,NSString *keyPath) = nil;
@interface NMEKVOProxy : NSObject {
    __unsafe_unretained NSObject *_observed;
    pthread_mutex_t _lock;
}

/**
 {keypath : [ob1,ob2](NSHashTable)}
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *kvoInfoMap;

@end

@implementation NMEKVOProxy

- (instancetype)initWithObserverd:(NSObject *)observed {
    if (self = [super init]) {
        _observed = observed;
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);  // 定义锁的属性
        pthread_mutex_init(&self->_lock, &attr); // 创建锁
    }
    return self;
}

- (void)dealloc {
    @autoreleasepool {
        pthread_mutex_lock(&self->_lock);
        NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  self.kvoInfoMap.copy;
        for (NSString *keyPath in kvoinfos) {
            // call original  IMP
            for (int i = 0; i < kvoinfos[keyPath].count; i++) {
                hookOrginFunction_removeObserver(_observed,@selector(removeObserver:forKeyPath:),self, keyPath);
            }
        }
        pthread_mutex_unlock(&self->_lock);
    }
}

- (NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *)kvoInfoMap {
    if (!_kvoInfoMap) {
        _kvoInfoMap = @{}.mutableCopy;
    }
    return  _kvoInfoMap;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // dispatch to origina observers
    pthread_mutex_lock(&self->_lock);
    NSHashTable<NSObject *> *os = self.kvoInfoMap[keyPath];
    for (NSObject  *observer in os) {
        if ([observer isKindOfClass:NSClassFromString(@"NSKeyValueObservance")]) {
            continue;
        }
        @try {
            [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
            NSString *reason = [NSString stringWithFormat:@"non fatal Error%@",[exception description]];
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeKVO)];
        }
    }
    pthread_mutex_unlock(&self->_lock);
}

-(void)removeObservesWithKeyPath:(NSString *)keyPath{
    pthread_mutex_lock(&self->_lock);
    [_kvoInfoMap removeObjectForKey:keyPath];
    pthread_mutex_unlock(&self->_lock);
}

-(void)observes:(NSHashTable<NSObject *> *) hashTable keyPath:(NSString *)keyPath{
    pthread_mutex_lock(&self->_lock);
    _kvoInfoMap[keyPath] = hashTable;
    pthread_mutex_unlock(&self->_lock);
}

-(void)addObserve:(NSObject *)object keyPath:(NSString *)keyPath{
    pthread_mutex_lock(&self->_lock);
    [_kvoInfoMap[keyPath] addObject:object];
    pthread_mutex_unlock(&self->_lock);
}


-(void)removeObserve:(NSObject *)object keyPath:(NSString *)keyPath{
    pthread_mutex_lock(&self->_lock);
    [_kvoInfoMap[keyPath] removeObject:object];
    pthread_mutex_unlock(&self->_lock);
}

@end

#pragma mark - KVOStabilityProperty

@interface NSObject (KVOShieldProperty)

@property (nonatomic, strong) NMEKVOProxy *kvoProxy;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@end

#pragma mark - KVO Hook

static BOOL hook_NSObject_addObserver_forKeyPath_options_context() {
    static char associatedKey;
    Class hookClass = [NSObject class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(addObserver:forKeyPath:options:context:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSObject* self, SEL _cmd ,NSObject *observer ,NSString *keyPath ,NSKeyValueObservingOptions options ,void *context) = nil;
    id newImpBlock = ^void(NSObject* self ,NSObject *observer ,NSString *keyPath ,NSKeyValueObservingOptions options ,void *context) {
        
        if (object_getClass(observer) == objc_getClass("RACKVOProxy") ) {
            hookOrginFunction ? hookOrginFunction(self,hookSel,observer, keyPath, options, context) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,observer, keyPath, options, context);
            return;
        }
        
        if (!self.kvoProxy) {
            @autoreleasepool {
                self.kvoProxy = [[NMEKVOProxy alloc] initWithObserverd:self];
            }
        }
        
        if (!self.lock) {
            @autoreleasepool {
                self.lock = dispatch_semaphore_create(1);
            }
        }
        
        dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
        NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
        if (os.count == 0) {
            os = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory) capacity:0];
            [os addObject:observer];
            
            hookOrginFunction ? hookOrginFunction(self,hookSel,self.kvoProxy, keyPath, options, context) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,self.kvoProxy, keyPath, options, context);
            [self.kvoProxy observes:os keyPath:keyPath];
            dispatch_semaphore_signal(self.lock);
            return ;
        }
        
        if ([os containsObject:observer]) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO add Observer to many timers.",
                                [self class], NSStringFromSelector(@selector(addObserver:forKeyPath:options:context:))];
            
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeKVO)];
        } else {
            [self.kvoProxy addObserve:observer keyPath:keyPath];
        }
        dispatch_semaphore_signal(self.lock);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_NSObject_removeObserver_forKeyPath() {
    static char associatedKey;
    Class hookClass = [NSObject class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(removeObserver:forKeyPath:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void(*hookOrginFunction)(NSObject* self, SEL _cmd ,NSObject *observer ,NSString *keyPath) = nil;
    id newImpBlock = ^void(NSObject* self ,NSObject *observer ,NSString *keyPath) {
        
        if (object_getClass(observer) == objc_getClass("RACKVOProxy") ) {
            hookOrginFunction ? hookOrginFunction(self,hookSel,observer, keyPath) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,observer, keyPath);
            return;
        }
        
        dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
        NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
        
        if (os.count == 0) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO remove Observer to many times.",
                                [self class], NSStringFromSelector(@selector(removeObserver:forKeyPath:))];
            [NMERecord recordFatalWithReason:reason errorType:(NMEShieldTypeKVO)];
            dispatch_semaphore_signal(self.lock);
            return;
        }
        
        [self.kvoProxy removeObserve:observer keyPath:keyPath];
        if (os.count == 0) {
            hookOrginFunction ? hookOrginFunction(self,hookSel,self.kvoProxy, keyPath) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,self.kvoProxy, keyPath);
            [self.kvoProxy removeObservesWithKeyPath:keyPath];
        }
        dispatch_semaphore_signal(self.lock);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC); hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    hookOrginFunction_removeObserver = hookOrginFunction;
    return YES;
}

#pragma mark - NSObject (KVOShield)
@implementation NSObject (KVOShield)
- (void)setKvoProxy:(NMEKVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, @selector(kvoProxy), kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NMEKVOProxy *)kvoProxy {
    return objc_getAssociatedObject(self, @selector(kvoProxy));
}

-(void)setLock:(dispatch_semaphore_t)lock{
    objc_setAssociatedObject(self, @selector(lock), lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(dispatch_semaphore_t)lock{
    return objc_getAssociatedObject(self, @selector(lock));
}

+(void)registerNSObjectKVOShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_NSObject_addObserver_forKeyPath_options_context();
        hook_NSObject_removeObserver_forKeyPath();
    });
}
@end
