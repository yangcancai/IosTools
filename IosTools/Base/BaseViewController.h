

/// 导航栏风格
typedef NS_ENUM(NSUInteger, MCNavColorStyle) {
    MCNavColorStyleDefault = 0, //!< 默认 默认白色 滚动之后灰色
    MCNavColorStyleAllWhite,    //!< 全部白色
    MCNavColorStyleAllGary,     //!< 全部灰色
};

#import <UIKit/UIKit.h>
#import "UINavigationController+Extension.h"
#import "UINavigationController+PopGestureRecognizer.h"

@interface BaseViewController : UIViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSAttributedString *navAttTitle;


/**
 点击返回的方法，子类继承，在子类中写需要添加的内容
 */
-(void)backBtnClick:(id)sender;
- (UIButton *)leftNavButton;

-(void)resetNavImage;

- (void)largNav;

- (void)_setNavigationBackgroundColor:(MCNavColorStyle)style;

//热更新专用
-(void)flexBlockDefineMethor:(NSArray *)array;

@end
