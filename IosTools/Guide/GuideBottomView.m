//
//  GuideBottomView.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "GuideBottomView.h"
@interface GuideBottomView()

@property (nonatomic, strong) UIView *myContentView;


@end

@implementation GuideBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    /**   create Items   */
    _myContentView = [[UIView alloc] initWithFrame:self.bounds];
    _myContentView.backgroundColor = [UIColor clearColor];
    _myContentView.userInteractionEnabled = YES;
    [self addSubview:_myContentView];

    
    _myRegisterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];

    [_myRegisterButton setBackgroundColor:Color(@"#44af52")];
    [_myRegisterButton setTitle:LocalKey(@"Register") forState:(UIControlStateNormal)];
    [_myRegisterButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _myRegisterButton.titleLabel.font = [UIFont fontWithName:PING_FANG_SC_MEDIUM_FONE_NAME size:17];
    _myRegisterButton.layer.cornerRadius = 4;
    _myRegisterButton.layer.masksToBounds = YES;
    
    [_myContentView addSubview:_myRegisterButton];
    

    _myLoginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];

    [_myLoginButton setBackgroundColor:Color(@"#e4f2f1")];
    [_myLoginButton setTitle:LocalKey(@"Login") forState:(UIControlStateNormal)];
    [_myLoginButton setTitleColor:Color(@"#20a59a") forState:(UIControlStateNormal)];
    _myLoginButton.titleLabel.font = [UIFont fontWithName:PING_FANG_SC_MEDIUM_FONE_NAME size:17];
    _myLoginButton.layer.cornerRadius = 4;
    _myLoginButton.layer.masksToBounds = YES;
    [_myContentView addSubview:_myLoginButton];
    
    /**   Layout Itmes   */
    
    //CGFloat butonWidth   = (BXScreen_Width - 7*2 - 45) / 2;
    CGFloat butonWidth   = 274 / 2;
    CGFloat buttonHeight = 40;
    
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.myRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-butonWidth/2 -14);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.equalTo(@(butonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [self.myLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(butonWidth/2 + 14);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.equalTo(@(butonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
}

 

@end
