//
//  GuideBottomView.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import <UIKit/UIKit.h>

 
@interface GuideBottomView : UIView

@property (weak) id delegate;

@property (nonatomic, strong) UIButton *myLoginButton;

@property (nonatomic, strong) UIButton *myRegisterButton;

@end
