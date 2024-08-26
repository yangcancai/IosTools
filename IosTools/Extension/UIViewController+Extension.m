//
//  UIViewController+BXExtension.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//
#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

#pragma mark - Public Method
/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)topController {
    UIViewController *vc = [self activityViewController];
    UIViewController *topVC = [self getCurrentViewController:vc];
    
    return topVC;
}


/**
 *  获取 当前的控制器 或addChildViewController 的parentViewController 主要处理viewController的navigationItem
 */
+ (UIViewController *)obtainViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [self equalIsNarBarVC:viewController];
    }else{
        UIViewController *parentViewController = viewController.parentViewController;
        if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {
            viewController = [self equalIsNarBarVC:parentViewController];
        }else if (parentViewController){
            parentViewController = parentViewController.parentViewController;
            if (parentViewController && [parentViewController isKindOfClass:[UINavigationController class]]) {
                viewController = [self equalIsNarBarVC:parentViewController];
            }else{
                viewController = parentViewController;
            }
            
        }
    }
    return viewController;
}

/**
 跳转到ChatRoomViewController
 */
- (void)jumpToChatRoomVC {
    BOOL flag = NO;
    for (int index = 0; index < self.navigationController.viewControllers.count; index++){
        UIViewController *vc = self.navigationController.viewControllers[index];
        if ([vc isKindOfClass:NSClassFromString(@"ChatViewController")]){
            [self.navigationController popToViewController:vc animated:YES];
            flag = YES;
            break;
        }
    }
    if (flag == NO) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - Private Method

/**
 *  获取当前处于activity状态的view controller
 */
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *viewsArray = [window subviews];
    
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    return activityViewController;
}

+ (UIViewController *)getCurrentViewController:(UIViewController *)viewController
{
    UIViewController *lastViewController  = nil;
    if ([viewController isKindOfClass:[UITabBarController class]]) {

        UITabBarController *tabBarController = (UITabBarController *)viewController ;
        NSInteger selectIndex = tabBarController.selectedIndex ;
        if (selectIndex < tabBarController.viewControllers.count) {
            UIViewController *tabViewController = tabBarController.viewControllers[selectIndex];
            if ([tabViewController isKindOfClass:[UINavigationController class]]) {
                lastViewController = [[(UINavigationController *)tabViewController viewControllers] lastObject];
                lastViewController = [self getPresentedViewController :lastViewController];
            }else{
                lastViewController = [self getPresentedViewController:tabViewController];
            }
        }
    }else if ([viewController isKindOfClass:[UINavigationController class]]){
        
        lastViewController = [[(UINavigationController *)viewController viewControllers] lastObject];
        lastViewController = [self getPresentedViewController:lastViewController];
    }else{
        
        lastViewController = [self getPresentedViewController:viewController];
    }
    
    return lastViewController;
}

+ (UIViewController *)getPresentedViewController:(UIViewController *)viewController
{
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;                            // 1. ViewController 下
        
        if ([viewController isKindOfClass:[UINavigationController class]]) {                // 2. NavigationController 下
            viewController =  [self getCurrentViewController:viewController];
        }
        
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = [self getCurrentViewController:viewController];     // 3. UITabBarController 下
        }
        if ([viewController isKindOfClass:UISearchController.class]){
          UIViewController *rootPresentedVC = [[UIApplication sharedApplication].keyWindow.rootViewController  presentedViewController];
            if (rootPresentedVC){
                viewController = [self getCurrentViewController:rootPresentedVC];
            }else {
                viewController = ((UISearchController *)viewController).searchResultsController;
            }
        }
    }
    return viewController;
}

/**
 *  判断是否 UINavigationController
 */
+ (UIViewController *)equalIsNarBarVC:(UIViewController *)viewController{
    UIViewController *viewController1 = [(UINavigationController *)viewController topViewController];
    viewController = viewController1 ? viewController1 : viewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [self obtainViewController:viewController];
    }
    return viewController;
}

/**
 退出所有present出来的controller
 */
+ (void)dismissControllersAnimated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *vc = [self topController];
    if (vc.presentingViewController){
        [vc dismissViewControllerAnimated:flag completion:^{
            [self dismissControllersAnimated:flag completion:completion];
        }];
    } else {
        !completion?:completion();
    }
}


/**
 将本控制器退出，pop或dismiss出来
 */
- (void)backControllersAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.navigationController){
        if ([self isEqual:self.navigationController.viewControllers.firstObject]){
            [self dismissViewControllerAnimated:flag completion:completion];
        }else {
            [self.navigationController popViewControllerAnimated:flag];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                !completion?:completion();
            });
        }
    }else {
        [self dismissViewControllerAnimated:flag completion:completion];
    }
}
@end
