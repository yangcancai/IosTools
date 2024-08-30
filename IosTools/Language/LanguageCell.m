//
//  LanguageCell.m
//  IosTools
//
//  Created by vv on 2024/8/30.
//

#import "LanguageCell.h"

@implementation LanguageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)refreshUI {
    self.accessoryType = self.language.currentLanguage ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)setLanguage:(Language *)language {
    _language = language;
    self.nameLab.text = _language.languageDes;
    [self refreshUI];
}

@end

@implementation Language

+ (instancetype)LanguageID:(NSString *)languageID languageDes:(NSString *)languageDes currentLanguage:(BOOL)currentLanguage {
    Language *lang = [[Language alloc] init];
    lang.languageID = languageID;
    lang.languageDes = languageDes;
    lang.currentLanguage = currentLanguage;
    return lang;
}


- (NSString *)description {
    NSString *des = [NSString stringWithFormat:@"LanguageName:%@\nCurrentLanguage:%i", self.languageDes, self.currentLanguage];
    return des;
}
@end
