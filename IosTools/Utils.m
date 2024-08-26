//
//  Utils.m
//  IosTools
//
//  Created by vv on 2024/8/26.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@implementation Utils

+(NSString *)localKey:(NSString *)key {
    /*
     iOS9 变成了en-US 和 zh-Hans-US, 香港 zh-HK
     iOS8 及以下 还是en 和 zh-Hans
     */
    __block NSString *returnedStr = @"";
    [self getLanguageSetting:^(NSString *langID, BOOL followedSys) {
        NSString * path = @"";
        // 1. 按系统设置语言
        if (followedSys || (followedSys == NO && langID.length == 0)){
            if([SystemLanguage hasPrefix:@"zh"]){
                NSString * path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
                NSBundle * languageBundle = [NSBundle bundleWithPath:path];
                returnedStr = [languageBundle localizedStringForKey:key value:nil table:nil];
            }else {
                NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
                NSBundle * languageBundle = [NSBundle bundleWithPath:path];
                returnedStr = [languageBundle localizedStringForKey:key value:nil table:nil];
            }
        } else if (langID.length){
            // 2. app内设定语言
            if ([langID hasPrefix:@"en"]){
                path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            } else if ([langID hasPrefix:@"zh"]){
                path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
            }
            
            if (path.length){ // 3. 获取app内设的语言翻译
                NSBundle * languageBundle = [NSBundle bundleWithPath:path];
                returnedStr = [languageBundle localizedStringForKey:key value:nil table:nil];
            }
        }
        
        if (!returnedStr.length){ // 4.找不到则以英语翻译
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            NSBundle * languageBundle = [NSBundle bundleWithPath:path];
            returnedStr = [languageBundle localizedStringForKey:key value:nil table:nil];
            returnedStr = returnedStr.length ? returnedStr : key;   // 5. 直接返回
        }
    }];
    
    
    return returnedStr;
}
/**
 获取app用户所设置的语言
 
 @param setting langID-语言id， followedSys直接按照系统设置语言
 */
+ (void)getLanguageSetting:(void (^)(NSString *langID, BOOL followedSys))setting {
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    BOOL followedSys = [[NSUserDefaults standardUserDefaults] boolForKey:@"followedSys"];
    !setting?:setting(lang, followedSys);
}
/**
 设置app所采用的语言
 
 @param langID 语言id
 @param followedSys 是否跟随系统语言设置
 */
+ (void)setLanguageSetting:(NSString *)langID followedSys:(BOOL)followedSys {
    [[NSUserDefaults standardUserDefaults] setObject:langID forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] setBool:followedSys forKey:@"followedSys"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 用户设置的语言的描述
 */
+ (NSString *)currentLanguageDes {
    __block NSString *des = @"";
    [self getLanguageSetting:^(NSString *langID, BOOL followedSys) {
        NSString *lang = langID;
        // 跟随系统或首次多语言为设置默认以系统的语言为当前语言
        if (followedSys || (followedSys == NO && langID.length == 0)){
            lang = CURR_LANG;
        }
        des = [self languageDes:lang];
    }];

    return des;
}

/**
 当前app语言ID(若没设置则返回系统当前的语言id)
 */
+ (NSString *)currentLanguageID {
    __block NSString *lang = @"";
    [self getLanguageSetting:^(NSString *langID, BOOL followedSys) {
        lang = langID;
        // 跟随系统或首次多语言为设置默认以系统的语言为当前语言
        if (followedSys || (followedSys == NO && langID.length == 0)){
            lang = CURR_LANG;
        }
    }];
    
    return lang;
}

/// 是否中文语言设置
+ (BOOL)isChinese {
    return [Utils.currentLanguageID hasPrefix:@"zh"];
}

/**
 lang语言说明
 */
+ (NSString *)languageDes:(NSString *)lang {
    NSString *des = @"";
    if ([lang hasPrefix:@"zh"]){
        if ([lang hasPrefix:@"zh-Hans"]){
            des = LocalKey(@"language_zh-Hans");
        } else if ([lang hasPrefix:@"zh-Hant"]){
            des = LocalKey(@"language_zh-Hant");
        } else {
            des = LocalKey(@"language_zh-Hans");
        }
    } else {
        des = LocalKey(@"language_english");
    }
    return des;
}
@end
