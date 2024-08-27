
#import "BaseViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIImage+ImageEffects.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BaseViewController
-(instancetype)init
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
-(void)resetNavImage
{
    [self _setNavigationBackgroundColor:MCNavColorStyleAllWhite];
}

-(void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    self.titleLabel.text = _navTitle;
}
-(void)setNavAttTitle:(NSAttributedString *)navAttTitle
{
    _navAttTitle = navAttTitle;
    self.titleLabel.attributedText = navAttTitle;
}
//热更新专用
-(void)flexBlockDefineMethor:(NSArray *)array
{
    
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = Color(@"#333333");
        titleLab.font = UIFont_Medium(24);
        titleLab.textAlignment = NSTextAlignmentCenter;
       // titleLab.size = CGSizeMake(Screen_Width - 120, 44);
        _titleLabel = titleLab;
        self.navigationItem.titleView = _titleLabel;
    }
    return _titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
     self.definesPresentationContext = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpNavigation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self defineNav];
}

- (void)largNav {
    [self _setNavigationBackgroundColor:MCNavColorStyleDefault];
}

- (void)defineNav {
    [self _setNavigationBackgroundColor:MCNavColorStyleAllGary];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   // [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@">>>>>>>>>>>>>>>>>neic内存警告");
   // [SDImageCache.sharedImageCache clearMemory];
}

-(void)setUpNavigation
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont fontWithName:PING_FANG_SC_MEDIUM_FONE_NAME size:17]};

    UIButton *leftNavButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    if (nil == leftNavButton) {
        leftNavButton = [self leftNavButton];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavButton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([NSThread isMainThread]) {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
        
        if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]){
            UINavigationController *navi = (UINavigationController *)viewControllerToPresent;
            [self addBackBtnWithController:navi.rootController];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super presentViewController:viewControllerToPresent animated:flag completion:completion];
            
            if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]){
                UINavigationController *navi = (UINavigationController *)viewControllerToPresent;
                [self addBackBtnWithController:navi.rootController];
            }
        });
    }
}

/**
 对于present出来的导航控制器下的controller，设置返回btn(防止present出来的导航无返回,且要返回到之前present的vc)

 */
- (void)addBackBtnWithController:(UIViewController *)controller {
    
    if ([controller respondsToSelector:NSSelectorFromString(@"backBtnClick:")]) {
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:controller action:NSSelectorFromString(@"backBtnClick:")];
        controller.navigationItem.leftBarButtonItem = backitem;
    }
}

/**
 点击返回的方法，子类继承，在子类中写需要添加的内容
 */
-(void)backBtnClick:(id)sender {
    if (self.navigationController){
        if ([self isEqual:self.navigationController.rootController]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIButton *)leftNavButton
{
    UIImage *menuBtnImg = [UIImage imageNamed:@"left_arrow"];
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:menuBtnImg forState:UIControlStateNormal];
    [leftBarButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBarButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = {CGPointZero, CGSizeMake(44, 44)};
    leftBarButton.frame = frame;
    
    return leftBarButton;
}
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (@available(iOS 11.0, *)) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return NO;
    } else {
        return YES;
    }
}


// MARK: - Private Methods
- (void)_setNavigationBackgroundColor:(MCNavColorStyle)style {
    switch (style) {
        case MCNavColorStyleDefault : {
            [self _defaultNav];
        } break;
            
        case MCNavColorStyleAllWhite : {
            [self _allWhiteNav];
        } break;
            
        case MCNavColorStyleAllGary : {
            [self _allGrayNav];
        } break;
            
        default:
            break;
    }
}

- (void)_defaultNav {
    if (@available(iOS 15.0, *)) {
        self.navigationController.navigationBar.standardAppearance = ({
            UINavigationBarAppearance *app = [UINavigationBarAppearance new];
            [app configureWithDefaultBackground];
            app.backgroundColor = NavGray;
            app.shadowColor = [UIColor whiteColor];
            app.shadowImage = [UIImage imageWithColor:app.backgroundColor];
            app;
        });
        
        self.navigationController.navigationBar.scrollEdgeAppearance = ({
            UINavigationBarAppearance *app = [UINavigationBarAppearance new];
            [app configureWithDefaultBackground];
            app.backgroundColor = LargeNavColor;
            app.shadowColor = [UIColor whiteColor];
            app.shadowImage = [UIImage imageWithColor:app.backgroundColor];
            app;
        });
    } else {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:NavGray]];  //导航栏分割线
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NavGray] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)_allWhiteNav {
    UIColor *color = LargeNavColor;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *app = [UINavigationBarAppearance new];
        [app configureWithDefaultBackground];
        app.backgroundColor = color;
        app.shadowColor = [UIColor whiteColor];
        app.shadowImage = [UIImage imageWithColor:app.backgroundColor];
        
        self.navigationController.navigationBar.standardAppearance = app;
        self.navigationController.navigationBar.scrollEdgeAppearance = app;
    } else {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:color]];  //导航栏分割线
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)_allGrayNav {
    UIColor *color = NavGray;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *app = [UINavigationBarAppearance new];
        [app configureWithDefaultBackground];
        app.backgroundColor = color;
        app.shadowColor = [UIColor whiteColor];
        app.shadowImage = [UIImage imageWithColor:app.backgroundColor];
        
        self.navigationController.navigationBar.standardAppearance = app;
        self.navigationController.navigationBar.scrollEdgeAppearance = app;
    } else {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:color]];  //导航栏分割线
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
}
@end
