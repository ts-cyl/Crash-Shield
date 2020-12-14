//
//  NMEShieldStubObject.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NMEShieldStubObject.h"

#import <objc/runtime.h>

/**
 default Implement
 
 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunction(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunction, funcTypeEncoding);
}

@implementation NMEShieldStubObject
+ (NMEShieldStubObject *)shareInstance {
    static NMEShieldStubObject *singleton;
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [NMEShieldStubObject new];
        });
    }
    return singleton;
}

- (BOOL)addFunc:(SEL)sel {
    return __addMethod([NMEShieldStubObject class], sel);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([NMEShieldStubObject class]));
    return __addMethod(metaClass, sel);
}

@end
