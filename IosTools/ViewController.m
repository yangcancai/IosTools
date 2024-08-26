//
//  ViewController.m
//  Login1
//
//  Created by vv on 2024/8/23.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建用户名输入框
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 300, 40)];
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.placeholder = @"Username";
    [self.view addSubview:self.usernameField];
    
    // 创建密码输入框
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, 300, 40)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    // 创建登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.frame = CGRectMake(50, 200, 300, 40);
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    // 创建错误标签
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, 300, 40)];
    self.errorLabel.textColor = [UIColor redColor];
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.hidden = YES;
    [self.view addSubview:self.errorLabel];
    
    // 创建活动指示器
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    [self.view addSubview:self.activityIndicator];
}

- (void)loginButtonTapped {
    [self.view endEditing:YES];
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (username.length == 0 || password.length == 0) {
        self.errorLabel.text = @"Please enter both username and password.";
        self.errorLabel.hidden = NO;
        return;
    }
    
    [self.errorLabel setHidden:YES];
    [self.activityIndicator startAnimating];
    
    // 模拟网络登录操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        
        if ([username isEqualToString:@"user"] && [password isEqualToString:@"pass"]) {
            // 登录成功，跳转到主界面
            NSLog(@"Login successful");
        } else {
            // 登录失败，显示错误信息
            self.errorLabel.text = @"Invalid username or password.";
            self.errorLabel.hidden = NO;
        }
    });
}

@end

