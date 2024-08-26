//
//  UINavigationController+Extension.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BXNavigationBarStyle) {
    NavigationBarStyleTranslucent,            // 半透明
    NavigationBarStyleOpaque,                 // 不透明
    NavigationBarStyleTransparent             // 全透明
};

@interface UINavigationController (Extension)

/**
 获取导航控制器的root VC
 
 */
- (UIViewController *)rootController;

/**
 设置导航栏是否半透明, BXCustomNavigationController默认为YES设置半透明, NO 为全透明
 */

- (void)setNavigationBarStyle:(BXNavigationBarStyle)style;

- (void)setNaviBarTranslucent:(BOOL)translucent;


-(void)setNaviBarTranslucentToBackground;
@end
