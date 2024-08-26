//
//  UIColor+Hex.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import <UIKit/UIKit.h>
@interface UIColor (Extension)

+ (UIColor *) RGBString:(NSString *)colorString;

+ (UIColor *)getRandomColorWithIndex:(NSInteger) index;

@end

