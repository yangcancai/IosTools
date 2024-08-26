//
//  UIBarButtonItem+Extension.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)buttonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

/**
 *  在导航栏左边增加控件
 */
+ (void)addBarButtonToLeft:(UIBarButtonItem *)leftItem viewController:(UIViewController *)viewController width:(CGFloat)width;

/**
 *   解决导航栏 ios7.0 加上UIBarButtonItem 会左右之间有很大的间距 所有往导航栏加 UIBarButtonItem 全部调用这个方法  itemArray 元素为 UIBarButtonItem width 为距左或右的间距 必须为负的  return UIBarButtonItem组成后的数组  调用需是viewController.navigationItem.leftBarButtonItems、viewController.navigationItem.rightBarButtonItems
 */
+ (NSArray *)barButtonItems:(NSArray *)itemArray width:(CGFloat)width;
@end
