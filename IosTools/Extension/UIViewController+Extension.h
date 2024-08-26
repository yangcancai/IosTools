//
//  UIViewController+Extension.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

/**
 *  获取最顶层的控制器
 */
+ (UIViewController *)topController;

/**
 *  获取当前处于activity状态的view controller
 */
+ (UIViewController *)activityViewController;

/**
 *  获取 当前的控制器 或addChildViewController 的parentViewController 主要处理viewController的navigationItem
 */
+ (UIViewController *)obtainViewController:(UIViewController *)viewController;


/**
 跳转到ChatRoomViewController
 */
- (void)jumpToChatRoomVC;


/**
 退出所有present出来的controller
 */
+ (void)dismissControllersAnimated:(BOOL)flag completion:(void (^)(void))completion;


/**
 将本控制器退出，pop或dismiss出来
 */
- (void)backControllersAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
