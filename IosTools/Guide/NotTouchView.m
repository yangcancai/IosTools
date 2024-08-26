//
//  NotTouchView.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "NotTouchView.h"

@implementation NotTouchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView ==self) {
        return nil;
    }
    return hitView;
}
@end
