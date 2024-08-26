//
//  SlideView.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import <Foundation/Foundation.h>
#import "SlidingView.h"
#import "NotTouchView.h"
#import "CustomView.h"
#define BOTTOM_VIEW_HEIGHT 74

@interface SlidingView()<UIScrollViewDelegate>
{
    NSTimer *_myLoopSlidingTimer;
    int _myAutomaticIndex;
    
    int _currentTab;
    NSInteger _myDataModelTempCount;
}

//@property (strong, nonatomic) BXPageControlView *myPageControl;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (assign) CGRect aFrame;

@property (strong, nonatomic) NSMutableArray *myDataModelTempArray;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) UIView *contentView;




@end

@implementation SlidingView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self commonInit]; // 初始化UI界面
    }
    
    return self;
}

-(void)commonInit
{
    __weak __typeof(self) weakSelf = self;
    
    CGRect frame = self.bounds;
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _myScrollView.backgroundColor = [UIColor clearColor];
    [_myScrollView setScrollEnabled: true];
    [_myScrollView setPagingEnabled: true];
    _myScrollView.delegate = self;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_myScrollView];
    
    
    NotTouchView *contentView = [NotTouchView new];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:contentView];
    _contentView = contentView;
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = Color(@"#DFDFDF");
    self.pageControl.currentPageIndicatorTintColor = Color(@"#39A341");
    [contentView addSubview:self.pageControl];
    
    UIImageView *guideIcon = [UIImageView new];
    guideIcon.image = [UIImage imageNamed:@"guideLogo"];
    [contentView addSubview:guideIcon];
    guideIcon.hidden = YES;
    
    UIImageView *guideTitle = [UIImageView new];
    guideTitle.image = [UIImage imageNamed:@"guideTitle"];
    [contentView addSubview:guideTitle];
    guideTitle.hidden = YES;
    
    UILabel *titleLab = [UILabel new];
    titleLab.backgroundColor = UIColor.redColor;
    [titleLab setText:LocalKey(@"chat_mosaicChat")];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setFont:[UIFont boldSystemFontOfSize:24]];
    [contentView addSubview:titleLab];
    titleLab.hidden = YES;
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [guideIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(Screen_Height/6);
        make.centerX.equalTo(weakSelf);
    }];
 
    [guideTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guideIcon.mas_bottom).offset(23);
        make.centerX.equalTo(weakSelf);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-110);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(170);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.bottom.equalTo(contentView.mas_bottom).offset(-90);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageScrollViewDidPress:)];
    [self.myScrollView addGestureRecognizer:tap];
 
    if (!_myLoopSlidingTimer) {
        
        NSDate* fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:4]; //4s 后 第一次 fire
        
        _myLoopSlidingTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:5 target:self selector:@selector(myLoopAutomaticSlidingView) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myLoopSlidingTimer forMode:NSDefaultRunLoopMode];
        [self stopTimer];
    }
}

- (void)refreshUI {
    
}

-(void)layoutSubviews
{
    
}

-(void)resetTimer
{
    if (_myLoopSlidingTimer) {
        [_myLoopSlidingTimer invalidate];
        _myLoopSlidingTimer = nil;
    }
}

-(void)stopTimer
{
    if (_myLoopSlidingTimer) {
        [_myLoopSlidingTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)startTimer
{
    if (_myLoopSlidingTimer) {
        NSDate *fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:5]; //5s 后 第一次 fire
        [_myLoopSlidingTimer setFireDate:fireDate];
    }
}

-(void)imageScrollViewDidPress:(id) sender;
{
    if (_delegate && [_delegate respondsToSelector:@selector(SlidingView:slidingViewDidPress:atIndex:)]) {
        [_delegate SlidingView:self slidingViewDidPress:sender atIndex:_currentTab];
    }
}


-(void)setUpQuanZiLunBoTuDataArray:(NSArray *)dataArray
{
    NSMutableArray *dataArrayTemp = [NSMutableArray arrayWithArray:dataArray];
    [dataArrayTemp insertObject:[dataArray objectAtIndex:([dataArray count]-1)] atIndex:0];
    [dataArrayTemp addObject:[dataArray objectAtIndex:0]];
    
    self.myDataModelTempArray=[NSMutableArray arrayWithArray:dataArrayTemp];
    
    self.imageArray = [NSMutableArray array];
    
    _myDataModelTempCount = dataArray.count;
    
    self.aFrame = self.frame;
    _aFrame.size.width = Screen_Width;
    
    NSUInteger pageCount=[_myDataModelTempArray count];
    
    self.myScrollView.contentSize = CGSizeMake(Screen_Width*pageCount, _aFrame.size.height);
    
    for (UIView *subView in _myScrollView.subviews) {
        
        if (subView) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < pageCount; i++) {
        
        CGFloat xOrigin = i * Screen_Width;
        
        CustomView *guideView = [[CustomView alloc] initWithFrame:CGRectMake(xOrigin, 0, Screen_Width, _myScrollView.bounds.size.height)];
        
        NSDictionary *dic = _myDataModelTempArray[i];
        NSString *title = [dic objectForKey:@"title"];
        NSString *detail = [dic objectForKey:@"detail"];
        NSString *imageName = [dic objectForKey:@"img"];
        NSString *subTitle = [dic objectForKey:@"sub_title"];
        NSString *subTitleColor = [dic objectForKey:@"sub_title_color"];
        
        [guideView setUpDataWithTitle:title detail:detail imageName:imageName subTitle:subTitle subTitleColor:subTitleColor];
        
        [_myScrollView addSubview:guideView];
        
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myScrollView.mas_top).offset(0);
            make.left.equalTo(self.myScrollView.mas_left).offset(xOrigin);
            make.width.equalTo(@(Screen_Width));
            make.height.equalTo(@(self.myScrollView.bounds.size.height));
        }];
        
        [_imageArray addObject:guideView];
        
    }
    
    [_myScrollView setContentOffset:CGPointMake(_aFrame.size.width, 0)];
    

    
}

-(void)myLoopAutomaticSlidingView
{
    _myAutomaticIndex = _currentTab+2;
    
    if (_myAutomaticIndex == _myDataModelTempArray.count-1) {
        _myAutomaticIndex = 1;
    }else if (_currentTab == 0) {
        _myAutomaticIndex = 2;
    }
    [self touchUpInsideTabIndex:_myAutomaticIndex];
}

- (void)touchUpInsideTabIndex:(NSUInteger)tabIndex {
    
    if (_imageArray.count > tabIndex) {
        
        [self.myScrollView scrollRectToVisible:((UIView*)_imageArray[tabIndex]).frame animated:YES];
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)/* + 1*/; // floor 向下去整
    
    _currentTab = page;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    self.myPageControl.currentCount = _currentTab;
    self.pageControl.currentPage = _currentTab;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    
    NSInteger page = _currentTab;
    
    if (_currentTab==-1) {
        
        [_myScrollView setContentOffset:CGPointMake(([_myDataModelTempArray count]-2)*_aFrame.size.width, 0)];
    }
    if (_currentTab==([_myDataModelTempArray count]-2)) {
        
        [_myScrollView setContentOffset:CGPointMake(_aFrame.size.width, 0)];
        
    }
    
    if (page<0) {
        page = _myDataModelTempCount-1;
    }
    
    if (page == _myDataModelTempCount) {
        page = 0;
    }
    
//    _myPageControl.currentCount = page;
    _pageControl.currentPage = page;
    
}



@end
