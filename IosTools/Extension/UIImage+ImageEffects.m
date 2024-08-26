/*
 File: UIImage+ImageEffects.m
 Abstract: This is a category of UIImage that adds methods to apply blur and tint effects to an image. This is the code you’ll want to look out to find out how to use vImage to efficiently calculate a blur.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */

#import "UIImage+ImageEffects.h"
#import "SCLMacros.h"

#if defined(__has_feature) && __has_feature(modules)
@import Accelerate;
#else
#import <Accelerate/Accelerate.h>
#endif
#import <float.h>
#import <CoreText/CoreText.h>

#import "NSString+Common.h"
#import "NSString+MD5.h"

#define DocPathS NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
@implementation UIImage (ImageEffects)


- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    NSUInteger componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                                  0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)customTitleAndColorImageWithColor:(UIColor *)color title:(NSString *) title imageViewFrame:(CGRect)frame
{
    /* 规则
     * sullen       ---- su
     * Jone Lee     ---- JL
     * su丽         ---- u丽
     * 安苏丽        ---- 苏丽
     */
    
    NSString *name = nil;
    NSString *content = title;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([NSString hasChinese:content]) {
        // 中文的时候，去最后面两位
        NSInteger count = MIN(2, content.length);
        name = [content substringFromIndex:content.length - count];
    } else {
        // 英文
        if ([content rangeOfString:@" "].location != NSNotFound) {
            // 有空格，取空格前后单词首字母
            NSArray *array = [content componentsSeparatedByString:@" "];
            if (array.count >= 2) {
                if ([array[0] length] > 0) {
                    name = [array[0] substringToIndex:1];
                }
                if ([array[1] length] > 0) {
                    name = [name stringByAppendingString:[array[1] substringToIndex:1]];
                }
            }
        } else {
            NSInteger count = MIN(2, content.length);
            name = [content substringToIndex:count];
        }
    }
    if (name.length > 0) {
        title = name;
    } else {
        if (title.length > 2) {
    
            NSString *subText = title;
    
            if (title.length >= 2) {
    
                subText = [title substringWithRange:NSMakeRange(title.length-2, 2)];
            }
    
            NSString *twoCapitalText = [self getTwoCapitalFromText:title];
    
            if (twoCapitalText.length > 1) {
    
                subText = twoCapitalText;
            }
    
            title = [NSString stringWithFormat:@"%@",subText];
        }
    }
    
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, frame);
    /*
//    CGContextSetRGBFillColor (context,  0, 0, 0, 1.0);//设置填充颜色
    UIFont  *font = [UIFont boldSystemFontOfSize:18.0];//设置
//
    NSDictionary *attributes = @{NSFontAttributeName:font};
//
//    //[title drawInRect:CGRectMake(10, 20, 80, 20) withFont:font];
//    [title drawInRect:CGRectMake(10, 20, 44, 44) withAttributes:attributes];
    
    [title drawAtPoint:CGPointMake(0, 0) withAttributes:attributes];
    */
    
//    NSString *backColorString = [self hexStringFromColor:color];
//    NSString *backMd5 = [[NSString stringWithFormat:@"%@_%@_%f_%f", backColorString, title, frame.size.width, frame.size.height] MD5Hash];
//    if ([self getDefineHeadWithFileName:backMd5]) {
//        return [self getDefineHeadWithFileName:backMd5];
//    }
    
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    //绘制图片
    [[UIImage imageWithColor:color] drawInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //添加文字
    UIFont  *font = [UIFont boldSystemFontOfSize:14.0];//设置
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //获得size
    CGSize strSize = [title sizeWithAttributes:attributes];
    
    CGFloat marginTop = (frame.size.width - strSize.width)/2;
    
    CGPoint point = CGPointMake(/*(frame.size.width - font.lineHeight)/4*/marginTop, (frame.size.height - font.lineHeight)/2);
    
    [title drawAtPoint:point withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
//    [self saveImage:UIImagePNGRepresentation(image) fileName:backMd5];
    return image;
}

+ (UIImage *)customTitleAndColorImageWithColor:(UIColor *)color title:(NSString *) title titleColor:(UIColor *) titleColor imageViewFrame:(CGRect)frame
{
    /* 规则
     * sullen       ---- su
     * Jone Lee     ---- JL
     * su丽         ---- u丽
     * 安苏丽        ---- 苏丽
     */
    
    NSString *name = @"";
    NSString *content = title;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([NSString hasChinese:content]) {
        // 中文的时候，去最后面两位
        NSInteger count = MIN(2, content.length);
        name = [content substringFromIndex:content.length - count];
    } else {
        // 英文
        if ([content rangeOfString:@" "].location != NSNotFound) {
            // 有空格，取空格前后单词首字母
            NSArray *array = [content componentsSeparatedByString:@" "];
            if (array.count >= 2) {
                if ([array[0] length] > 0) {
                    name = [array[0] substringToIndex:1];
                }
                if ([array[1] length] > 0) {
                    name = [name stringByAppendingString:[array[1] substringToIndex:1]];
                }
            }
        } else {
            NSInteger count = MIN(2, content.length);
            name = [content substringToIndex:count];
        }
    }
    if (name.length > 0) {
        title = name;
    } else {
        // 旧的处理方案，怕我处理的有问题，测试过后可以删除
        NSMutableString *subString = [NSMutableString string];
        NSRange range;
        for(int i = 0, count = 0; i < title.length && count < 2; i+= range.length)
        {
            range = [title rangeOfComposedCharacterSequenceAtIndex:i];
            if (range.location != NSNotFound) {
                [subString appendString:[title substringWithRange:range]];
            }
            count ++;
        }

        title = subString;
    }
//    NSString *backColorString = [self hexStringFromColor:color];
//    NSString *titColorString = [self hexStringFromColor:titleColor];
//    NSString *backMd5 = [[NSString stringWithFormat:@"%@_%@_%@_%f_%f", backColorString, title.description, titColorString, frame.size.width, frame.size.height] MD5Hash];
//    if ([self getDefineHeadWithFileName:backMd5]) {
//        return [self getDefineHeadWithFileName:backMd5];
//    }
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    //绘制图片
    [[UIImage imageWithColor:color] drawInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //添加文字
    UIFont  *font = [UIFont boldSystemFontOfSize:14.0];//设置
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:titleColor};
    
    //获得size
    CGSize strSize = [title sizeWithAttributes:attributes];
    
    CGFloat marginTop = (frame.size.width - strSize.width)/2;
    
    CGPoint point = CGPointMake(/*(frame.size.width - font.lineHeight)/4*/marginTop, (frame.size.height - font.lineHeight)/2);
    
    [title drawAtPoint:point withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
//    [self saveImage:UIImagePNGRepresentation(image) fileName:backMd5];
    return image;
}
+ (UIImage *)getDefineHeadWithFileName:(NSString *)fileName
{
    NSString *TypePath = [DocPathS stringByAppendingPathComponent:@"DefineHead"];;
    
    NSString *coPath =[[TypePath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"bxrsous"];
    
    NSData *distnyData = [NSData dataWithContentsOfFile:coPath];
    if (distnyData) {
        return [UIImage imageWithData:distnyData];
    }
    return nil;
}
/**   存储图片和语音   */
+ (void)saveImage:(NSData *)obj fileName:(NSString*)fileName
{
    NSString *TypePath = [DocPathS stringByAppendingPathComponent:@"DefineHead"];;
    
    NSString *coPath =[[TypePath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"bxrsous"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:TypePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:TypePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:coPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:coPath error:nil];
    }
    if ([obj writeToFile:coPath atomically:YES]) {
        NSLog(@"写入成功");
    }
}
//颜色转换16进制字符
+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}
+ (UIImage *)waterAtImage:(UIImage *)image
                     text:(NSString *)text
                    point:(CGPoint)point
               attributes:(NSDictionary *)attributes {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加文字
    [text drawAtPoint:point withAttributes:attributes];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)convertViewToImage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedScreen;
}

+ (UIImage *)convertViewToImage:(UIView *)view
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *capturedScreen;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        //Optimized/fast method for rendering a UIView as image on iOS 7 and later versions.
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, scale);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
        capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        //For devices running on earlier iOS versions.
        UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES, scale);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return capturedScreen;
}

+ (UIImage *)imageWithName:(NSString *)name
{
    if (([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        
        // 利用新的文件名加载图片
        UIImage *image = [self imageNamed:newName];
        // 不存在这张图片
        if (image == nil) {
            image = [self imageNamed:name];
        }
        return image;
    } else {
        return [self imageNamed:name];
    }
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name leftScale:0.5 topScale:0.85];
}

+ (UIImage *)resizeImage:(NSString *)name
{
    return [self resizedImage:name leftScale:0.5 topScale:0.5];
}

+ (UIImage *)resizeImageForChat:(NSString *)name
{
    return [self resizedImage:name leftScale:0.5 topScale:0.3];
}

+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale
{
    UIImage *image = [self imageWithName:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftScale topCapHeight:image.size.height * topScale];
    //    return [image stretchableImageWithLeftCapWidth:leftScale topCapHeight:topScale];
}

+(UIImage *)resizedImage:(NSString *)name capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
    UIImage *image = [self imageWithName:name];
    
    //    return [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    return [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(NSString *)getTwoCapitalFromText:(NSString *) text
{
    NSString *testString = text;
    NSInteger alength = [testString length];
    
    NSMutableString *subString = [NSMutableString string];
    
    for (int i = 0; i<alength; i++) {
        char commitChar = [testString characterAtIndex:i];
        NSString *temp = [testString substringWithRange:NSMakeRange(i,1)];
        
        if (temp.length>0) {
            
            const char *u8Temp = [temp UTF8String];
            
            if (u8Temp) {
                
                if (3==strlen(u8Temp)){
                    
                    //            NSLog(@"字符串中含有中文");
                }else if((commitChar>64)&&(commitChar<91)){
                    
                    //            NSLog(@"字符串中含有大写英文字母");
                    
                    [subString appendString:temp];
                    
                }else if((commitChar>96)&&(commitChar<123)){
                    
                    //            NSLog(@"字符串中含有小写英文字母");
                }else if((commitChar>47)&&(commitChar<58)){
                    
                    //            NSLog(@"字符串中含有数字");
                }else{
                    
                    //            NSLog(@"字符串中含有非法字符");
                }
            }
            
        }
        
    }
    
    if (subString.length > 2) {
        
        subString = [NSMutableString stringWithString:[subString substringWithRange:NSMakeRange(subString.length - 2,2)]];
    }
    
    return subString;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO,[UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0.0, 0.0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
