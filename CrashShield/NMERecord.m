//
//  NMERecord.m
//  NMECrashShield
//
//  Created by cyl on 2018/4/3.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "NMERecord.h"

@implementation NMERecord

static id<NMERecordProtocol> __record;

+ (void)registerRecordHandler:(id<NMERecordProtocol>)record {
    __record = record;
}

+ (void)recordFatalWithReason:(nullable NSString *)reason
                    errorType:(NMEShieldType)type {
    //堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    NSString *crashPosition = [callStackSymbolsArr componentsJoinedByString:@"/n"];
    
    NSDictionary<NSString *, id> *errorInfo = @{ NSLocalizedDescriptionKey : (reason.length ? reason : @"未标识原因" ), NSLocalizedRecoverySuggestionErrorKey: (crashPosition ? crashPosition : @"未找到崩溃位置")};
    
    NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"com.NMECrashShield.%@",
                                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]]
                                         code:-type
                                     userInfo:errorInfo];
    [__record recordWithReason:error];
}

/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbols 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */

+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                    
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}
@end
