//
//  GuideViewController.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "GuideViewController.h"
#import "SlidingView.h"
#import "GuideBottomView.h"
@interface GuideViewController ()

@property (strong, nonatomic) GuideBottomView *myGuideBottomView; // 底部登录与注册视图
@property (strong, nonatomic) SlidingView *mySlidingView;
@property (nonatomic, strong) UIButton *languageBtn;

@end

@implementation GuideViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if (_mySlidingView) {
        [self refreshUIForLanguageSetting];
        [_mySlidingView startTimer];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_mySlidingView) {
        [_mySlidingView stopTimer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self commonInitUI];
}

-(void)commonInitUI
{

    CGFloat bottomHeight = 100;

    UIView *offsetView = [[UIView alloc] init];
    offsetView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:offsetView];
 
    SlidingView *mySlidingView = [[SlidingView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:mySlidingView];
    _mySlidingView = mySlidingView;
    [self setDataArray];
     /**  底部按钮  */
    GuideBottomView *myGuideBottomView = [[GuideBottomView alloc] init];
    myGuideBottomView.delegate = self;
    [self.view addSubview:myGuideBottomView];
    _myGuideBottomView = myGuideBottomView;
    
    
    self.languageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.languageBtn setTitle:Utils.currentLanguageDes forState:UIControlStateNormal];
    [self.languageBtn setTitleColor:Color(@"#20a59a") forState:UIControlStateNormal];
    self.languageBtn.titleLabel.font = UIFont_Regular(14);
    self.languageBtn.backgroundColor = Color(@"#e4f2f1");
    self.languageBtn.layer.cornerRadius = 4;
    self.languageBtn.layer.masksToBounds = YES;
    [self.languageBtn addTarget:self action:@selector(languageSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.languageBtn];
    
    [offsetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left) ;
        make.right.equalTo(self.view.mas_right) ;
        make.bottom.equalTo(self.view.mas_bottom) ;
        make.height.equalTo(@(20));
    }];
    
    [mySlidingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(offsetView.mas_bottom).offset(0);
    }];
    
    [myGuideBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-bottomHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.languageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(30));
        make.width.equalTo(@(80));
    }];
    
    [self setupBottomBtn];
}

// 刷新UI--更新多语言
- (void)refreshUIForLanguageSetting {
    [self.languageBtn setTitle:Utils.currentLanguageDes forState:UIControlStateNormal];
    [self.myGuideBottomView.myRegisterButton setTitle:LocalKey(@"Register") forState:UIControlStateNormal];
    [self.myGuideBottomView.myLoginButton setTitle:LocalKey(@"Login") forState:UIControlStateNormal];
    [self setDataArray];
    
}
-(void) setDataArray{
    [self.mySlidingView setUpQuanZiLunBoTuDataArray:@[@{@"sub_title_color":@"#20a59a",@"sub_title":@"O",@"title":LocalKey(@"One"),@"detail":LocalKey(@"One_desc"),@"img":@"Guide1"},@{@"sub_title_color":@"#20a59a",@"sub_title":@"T",@"title":LocalKey(@"Two"),@"detail":LocalKey(@"Two_desc"),@"img":@"Guide2"},@{@"sub_title_color":@"#20a59a",@"sub_title":@"T",@"title":LocalKey(@"Three"),@"detail":LocalKey(@"Three_desc"),@"img":@"Guide3"}]];
}

// 跳转到语言设置
- (void)languageSetting:(UIButton *)btn {
    //LanguageController *langVC = [[LanguageController alloc] init];
   // [self.navigationController pushViewController:langVC animated:YES];
}

- (void)setupBottomBtn
{
//    @weakify(self)
//    [[self.myGuideBottomView.myLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
//        @strongify(self)
//        // 登录
//        UINavigationController *loginNavi = UIStoryboard_initVC(SB_UserLogin);
//        [self presentViewController:loginNavi animated:YES completion:nil];
//    }];
//    
//    [[self.myGuideBottomView.myRegisterButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
//        /** 注册跳转 */
//        @strongify(self)
//        
//        UINavigationController *registerNavi = UIStoryboard_initVC(SB_UserRegister);
//        [self presentViewController:registerNavi animated:YES completion:nil];
//    }];
}

- (void)dealloc {
    
}

@end
