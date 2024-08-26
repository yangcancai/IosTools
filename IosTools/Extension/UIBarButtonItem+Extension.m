//
//  UIBarButtonItem+Extension.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "UIBarButtonItem+Extension.h"
#import "UIViewController+Extension.h"

@implementation UIBarButtonItem (BXExtension)

+ (instancetype)buttonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, CGSizeMake(30, 30)};// 图片
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0,0)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}


/**
 *  在导航栏左边增加控件
 */
+ (void)addBarButtonToLeft:(UIBarButtonItem *)leftItem viewController:(UIViewController *)viewController width:(CGFloat)width {
    
    viewController = [UIViewController obtainViewController:viewController];
    if (leftItem) {
        viewController.navigationItem.leftBarButtonItems = nil;
        viewController.navigationItem.leftBarButtonItems = [self barButtonItems:@[leftItem] width:width];
    }else{
        viewController.navigationItem.leftBarButtonItems = nil;
    }

}

/**
 *   解决导航栏 ios7.0 加上UIBarButtonItem 会左右之间有很大的间距 所有往导航栏加 UIBarButtonItem 全部调用这个方法  itemArray 元素为 UIBarButtonItem width 为距左或右的间距 必须为负的  return UIBarButtonItem组成后的数组  调用需是viewController.navigationItem.leftBarButtonItems、viewController.navigationItem.rightBarButtonItems
 */
+ (NSArray *)barButtonItems:(NSArray *)itemArray width:(CGFloat)width{
    NSMutableArray *tempItemArray = [[NSMutableArray alloc] init];
    [tempItemArray addObjectsFromArray:itemArray];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = width;
    [tempItemArray insertObject:spaceItem atIndex:0];
    return [tempItemArray copy];
}



@end
