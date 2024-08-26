//
//  SlidingViewController.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#ifndef SlidingViewController_h
#define SlidingViewController_h

#import <UIKit/UIKit.h>

@protocol SlidingViewDelagate;

@interface SlidingView: UIView

@property (strong, nonatomic) UIScrollView *myScrollView;


@property (weak) id delegate;

-(void)setUpQuanZiLunBoTuDataArray:(NSArray *) dataArray;

-(void)stopTimer;

-(void)startTimer;

-(void)resetTimer; // 重置 Timer

- (void)refreshUI; // 刷新UI

@end

@protocol SlidingViewDelagate

-(void)SlidingView:(SlidingView *) SlidingView slidingViewDidPress:(id) sender atIndex:(int) aIndex;

@end
#endif /* SlidingViewController_h */
