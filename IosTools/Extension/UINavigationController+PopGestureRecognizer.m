//
//  UINavigationController+PopGestureRecognizer.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//
#import "UINavigationController+PopGestureRecognizer.h"

@implementation UINavigationController (PopGestureRecognizer)

@dynamic screenEdgePanGestureRecognizer;

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

@end
