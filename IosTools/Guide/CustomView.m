//
//  CustomView.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "CustomView.h"

@interface CustomView()

@property (strong, nonatomic) UILabel *myTitleLabel;
@property (strong, nonatomic) UILabel *myDetailLabel;
@property (strong, nonatomic) UIImageView *myImageView;

@end

@implementation CustomView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self commonInitUI];
    }
    return self;
}

-(void)commonInitUI
{
    self.myTitleLabel = [[UILabel alloc] init];
    _myTitleLabel.backgroundColor = [UIColor clearColor];
    _myTitleLabel.textColor = [UIColor RGBString:@"#737373"];
    _myTitleLabel.font = [UIFont fontWithName:PING_FANG_SC_REGULAR_FONT_NAME size:26];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_myTitleLabel];
    
    self.myDetailLabel = [[UILabel alloc] init];
    _myDetailLabel.backgroundColor = [UIColor clearColor];
    _myDetailLabel.numberOfLines = 0;
    _myDetailLabel.textColor = [UIColor RGBString:@"#999999"];
    _myDetailLabel.font = [UIFont fontWithName:PING_FANG_SC_MEDIUM_FONE_NAME size:17];
    _myDetailLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_myDetailLabel];
    
    self.myImageView = [[UIImageView alloc] init];
    _myImageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_myImageView];
    
    [self loadFrame];
}

-(void)loadFrame
{
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(145/2);
        make.centerX.equalTo(self).offset(0);
    }];
    
    [self.myDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.myTitleLabel.mas_bottom).offset(30/2);
        make.centerX.equalTo(self).offset(0);
    }];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

-(void)setUpDataWithTitle:(NSString *)title detail:(NSString *)detail imageName:(NSString *)imageName
                 subTitle:(NSString*)subTitle subTitleColor:(NSString*)subTitleColor
{
    UIColor* rangeOfColor = Color(subTitleColor);
    self.myTitleLabel.attributedText = [self getCustomColorTextWithTotalText:title rangeOfString:subTitle color:rangeOfColor lineSpacing:5 LineBreakMode:NSLineBreakByTruncatingTail font:[UIFont fontWithName:PING_FANG_SC_MEDIUM_FONE_NAME size:26]];
    
    self.myDetailLabel.text = detail;
    
    self.myImageView.image = [UIImage imageNamed:imageName];
    
    [self loadFrame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark other methods

-(NSMutableAttributedString *)getCustomColorTextWithTotalText:(NSString *) totalText rangeOfString:(NSString *) rangeOfString color:(UIColor *) color lineSpacing:(CGFloat)lineSpacing LineBreakMode:(NSLineBreakMode )breakMode font:(UIFont *) font
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:totalText];
    //NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:totalText attributes:@{NSFontAttributeName:font}];
    NSRange firstRange = NSMakeRange([[noteStr string] rangeOfString:rangeOfString].location, [[noteStr string] rangeOfString:rangeOfString].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:firstRange];
    [noteStr addAttribute:NSFontAttributeName value:font range:firstRange];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:breakMode];
    [noteStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, [noteStr length])];
    
    return noteStr;
}

@end
