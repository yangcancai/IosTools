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
