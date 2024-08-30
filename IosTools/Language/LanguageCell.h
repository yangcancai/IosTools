//
//  LanguageCell.h
//  IosTools
//
//  Created by vv on 2024/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Language;
@interface LanguageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (nonatomic, strong) Language *language;

- (void)refreshUI;
@end


/**
 语言model
 */
@interface Language : NSObject
@property (nonatomic, strong) NSString *languageID;         /**< 语言识别ID-如：zh、en */
@property (nonatomic, strong) NSString *languageDes;        /**< 语言描述，如：zh->中文，en->english */
@property (nonatomic, assign) BOOL currentLanguage;         /**< 该语言是否为当前语言 */

+ (instancetype)LanguageID:(NSString *)languageID languageDes:(NSString *)languageDes currentLanguage:(BOOL)currentLanguage;
@end

NS_ASSUME_NONNULL_END
