//
//  UIColor+Hex.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import "UIColor+Extension.h"

@implementation UIColor(Extension)

+ (UIColor *) RGBString:(NSString *)colorString
{
    if (!colorString) {
        
        return [UIColor whiteColor];
    }
    NSMutableString *str = [colorString mutableCopy];
    NSRange range = [colorString rangeOfString:@"#"];
    if(range.location != NSNotFound){
        [str replaceCharactersInRange:range withString:@"0x"];
    }
    
    

    // 十六进制字符串转成整形。
    long colorLong = strtoul([str cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    
    //string转color
    UIColor *wordColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    return wordColor;
}

+(UIColor *)getRandomColorWithIndex:(NSInteger) index
{
    
    UIColor *color = [UIColor RGBString:@"#a4e2c6"];
    
    NSInteger actualIndex = index%10;
    
    switch (actualIndex) {
        case 0:
            
            color = [UIColor RGBString:@"#ffb3a7"];
            
            break;
        case 1:
            
            color = [UIColor RGBString:@"#88ada6"];
            
            break;
        case 2:
            
            color = [UIColor RGBString:@"#b0a4e3"];
            
            break;
        case 3:
            
            color = [UIColor RGBString:@"#eebbcb"];
            
            break;
        case 4:
            
            color = [UIColor RGBString:@"#ffc773"];
            
            break;
            
        case 5:
            
            color = [UIColor RGBString:@"#a1afc9"];
            
            break;
        case 6:
            
            color = [UIColor RGBString:@"#a0d8ef"];
            
            break;
        case 7:
            
            color = [UIColor RGBString:@"#a4e2c6"];
            
            break;
        case 8:
            
            color = [UIColor RGBString:@"#ffb3a7"];
            
            break;
        case 9:
            
            color = [UIColor RGBString:@"#88ada6"];
            
            break;
            
        default:
            
            color = [UIColor RGBString:@"#a4e2c6"];
            
            break;
    }
    
    return color;
}
@end
