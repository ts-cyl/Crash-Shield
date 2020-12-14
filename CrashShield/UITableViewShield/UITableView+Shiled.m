//
//  UITableView+Shiled.m
//  NMECrashShield
//
//  Created by cyl on 2018/5/22.
//  Copyright © 2018 QFPay. All rights reserved.
//

#import "UITableView+Shiled.h"
#import "NMECrashShield.h"

static BOOL hook_DataSource_CellForRow(id<UITableViewDataSource> dataSource) {
    static char associatedKey;
    Class hookClass = [dataSource class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(tableView:cellForRowAtIndexPath:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block id (*hookOrginFunction)(id<UITableViewDataSource> self, SEL _cmd , UITableView *tableView, NSIndexPath *indexPath);
    
    id newImpBlock = ^id (id<UITableViewDataSource> self, UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = hookOrginFunction ? hookOrginFunction(self,hookSel,tableView,indexPath) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,tableView,indexPath);
        
        if (!cell) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : UITableView dataSource must return a cell from tableView:cellForRowAtIndexPath:",
                                [self class], NSStringFromSelector(@selector(tableView:cellForRowAtIndexPath:))];
            [NMERecord recordFatalWithReason:reason errorType:NMEShieldTypeUITableView];
            return [UITableViewCell new];
        }
        return cell;

    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

static BOOL hook_UITableView_setDataSource() {
    static char associatedKey;
    Class hookClass = [UITableView class];
    Class hookSuperClass = class_getSuperclass(hookClass);
    SEL hookSel = @selector(setDataSource:);
    if (!hookClass || objc_getAssociatedObject(hookClass, &associatedKey)) { return NO; }
    if (!class_respondsToSelector(hookClass,hookSel)) { return NO; }
    __block void (*hookOrginFunction)(UITableView* self, SEL _cmd , id<UITableViewDataSource> dataSource);
    
    id newImpBlock = ^void (UITableView* self, id<UITableViewDataSource> dataSource) {
        hook_DataSource_CellForRow(dataSource);
        return hookOrginFunction ? hookOrginFunction(self,hookSel,dataSource) : ((typeof(hookOrginFunction))(class_getMethodImplementation(hookSuperClass,hookSel)))(self,hookSel,dataSource);
    };
    objc_setAssociatedObject(hookClass, &associatedKey, [newImpBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    hookOrginFunction = shield_hook_imp_function(hookClass, hookSel, imp_implementationWithBlock(newImpBlock));
    return YES;
}

@implementation UITableView (Shiled)

+(void)registerUITableViewShield{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook_UITableView_setDataSource();
    });
}
@end
