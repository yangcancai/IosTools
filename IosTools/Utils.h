//
//  Utils.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#ifndef Utils_h
#define Utils_h
#define SystemLanguage  NSLocale.preferredLanguages.firstObject
#define CURR_LANG    ([[NSLocale preferredLanguages] objectAtIndex:0])
#define LocalKey(string) [Utils localKey:string]
#define Color(colorString) ([UIColor RGBString:colorString])


/**  屏幕宽度  */
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define MyDefaults [NSUserDefaults standardUserDefaults]

/**  屏幕高度  */
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**  屏幕frame  */
#define Screen_Bound [UIScreen mainScreen].bounds

#define ScreenLineHeight 1/[UIScreen mainScreen].scale


#define PING_FANG_SC_REGULAR_FONT_NAME @"PingFang-SC-Regular"
#define PING_FANG_SC_MEDIUM_FONE_NAME @"PingFang-SC-Medium"
#define PING_FANG_SC_LIGHT_FONE_NAME @"PingFangSC-Light"
#define PING_FANG_SC_UITRALIGHT_FONE_NAME @"PingFangTC-Ultralight"
#define PING_FANG_HK_LIGHT_FONE_NAME @"PingFangHK-Light"
#define PING_FANG_SC_HEAVY_FONT_NAME @"PingFang-SC-Semibold"


#define UIFont_Regular(fontSize) [UIFont fontWithName:PING_FANG_SC_REGULAR_FONT_NAME size:fontSize]
#define UIFont_Medium(fontSize) [UIFont fontWithName:PING_FANG_SC_MEDIUM_FONE_NAME size:fontSize]
#define UIFont_Light(fontSize) [UIFont fontWithName:PING_FANG_SC_LIGHT_FONE_NAME size:fontSize]
#define UIFont_Ultralight(fontSize) [UIFont fontWithName:PING_FANG_SC_UITRALIGHT_FONE_NAME size:fontSize]
#define UIFont_HK_Light(fontSize) [UIFont fontWithName:PING_FANG_HK_LIGHT_FONE_NAME size:fontSize]
#define UIFont_Heavy(fontSize) [UIFont fontWithName:PING_FANG_SC_HEAVY_FONT_NAME size:fontSize]

#define ColorClear ([UIColor clearColor])
#define ColorWhite ([UIColor whiteColor])
#define ColorBlack ([UIColor blackColor])
#define Green Color(@"#44AF52")
#define ColorMain  Green
#define NavGray    Color(@"#F6F6F6")
#define LargeNavColor [UIColor whiteColor]
#define EncryptFileURLKey @"encryptKey="
#import <Foundation/Foundation.h>
@interface Utils: NSObject
/**
 *  根据key 获取不同语言对应的词语，若在本地化都没有设置则返回默认的key.
 *  注: 发现当前语言并非项目支持的语言时，统一访问指定的英语本地化文件.
 */
+ (NSString *)localKey:(NSString *)key;

/**
 用户设置的语言的描述
 */
+ (NSString *)currentLanguageDes;


/**
 当前app语言ID(若没设置则返回系统当前的语言id)
 */
+ (NSString *)currentLanguageID;

/// 是否中文语言设置
+ (BOOL)isChinese;


/**
 lang语言说明
 */
+ (NSString *)languageDes:(NSString *)lang;


/**
 获取app用户所设置的语言

 @param setting langID-语言id， followedSys直接按照系统设置语言
 */
+ (void)getLanguageSetting:(void (^)(NSString *langID, BOOL followedSys))setting;


/**
 设置app所采用的语言

 @param langID 语言id
 @param followedSys 是否跟随系统语言设置
 */
+ (void)setLanguageSetting:(NSString *)langID followedSys:(BOOL)followedSys;

@end

#endif /* Utils_h */
