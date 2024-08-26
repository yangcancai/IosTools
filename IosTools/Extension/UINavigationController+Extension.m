//
//  UINavigationController+Extension.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "UINavigationController+Extension.h"
#import "RTRootNavigationController.h"
#import "UIImage+ImageEffects.h"
@implementation UINavigationController (Extension)

/**
 获取导航控制器的root VC

 */
- (UIViewController *)rootController {
    if ([self isKindOfClass:[RTContainerNavigationController class]]) {
        RTContainerNavigationController *nav = (RTContainerNavigationController *)self;
        UIViewController *con = [nav.viewControllers firstObject];
        return con;
    }else if([self isKindOfClass:[RTRootNavigationController class]]){
        RTRootNavigationController *root = (RTRootNavigationController *)self;
        return [root.rt_viewControllers firstObject];
    }else if (self.viewControllers.count){
        return [self.viewControllers firstObject];
    }
    return nil;
}


- (void)setNavigationBarStyle:(BXNavigationBarStyle)style {
    
}
-(void)setNaviBarTranslucentToBackground
{
    self.navigationBar.translucent = YES;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.backgroundColor = [UIColor blackColor];
//        self.navigationBar.backgroundColor = [UIColor whiteColor];
//        self.navigationBar.shadowImage = [UIImage imageWithColor:BXColor(232, 234, 236)];
//        self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
    self.navigationBar.tintColor = UIColor.whiteColor;
}
/**
 设置导航栏是否半透明, BXCustomNavigationController默认为YES设置半透明, NO 为全透明
 */
- (void)setNaviBarTranslucent:(BOOL)translucent {
    self.navigationBar.translucent = YES;
    if (translucent){
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.backgroundColor = [UIColor clearColor];
//        self.navigationBar.backgroundColor = [UIColor whiteColor];
//        self.navigationBar.shadowImage = [UIImage imageWithColor:BXColor(232, 234, 236)];
//        self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
        self.navigationBar.tintColor = UIColor.blackColor;
    } else {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [self.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.backgroundColor = [UIColor clearColor];
        self.navigationBar.shadowImage = UIImage.new;
        self.navigationBar.tintColor = UIColor.whiteColor;
    }
}

@end
