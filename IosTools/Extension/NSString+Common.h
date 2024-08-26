//
//  NSString+Common.h
//  IosTools
//
//  Created by vv on 2024/8/26.
//

@interface NSString (Common)

+ (BOOL)hasChinese:(NSString *)str;


/**
 *  判断是不是http字符串（在传图片时，判断是本地图片或者是网络图片）
 */
- (BOOL)isHttpString ;

/**
 *  判断查找字符串中是否包含字符串
 *  - 解决 被查找字符串是nil的情况,range.location 会是0(NSNotFound不是0),
 *  @param searchString 查找的字符串
 *  @return NSRange
 */
- (NSRange)CC_RangeOfString:(NSString *)searchString;

#pragma mark -
#pragma mark ----- 判断表情
/**
 *  替换掉表情
 *
 *  @param inputStr 输入的文字
 *
 *  @return 替换掉后的文字
 */
+(NSString *)disable_emoji:(NSString *)inputStr;
/**
 *  判断是否是表情
 *
 *  @param inputStr 输入的文字
 *
 *  @return 是否是表情
 */
+(BOOL)disable_emoji1:(NSString *)inputStr;

/**
 *  判断是否是有效的电话号码，不做提示和长处的判断。只是判断是否正确
 *  @return 是否是电话号码
 */
- (BOOL)isValidatePhoneNumber;

/**
 *  是否是数字格式的日期,如2016-02-03
 */
- (BOOL)isNumDate;


/**
 *  判断是否是有效的验证码
 *  @return 是否是验证码
 */
- (BOOL)isValidateCode;

#pragma mark -
#pragma mark ----- 计算字的大小
/**
 计算高度或宽度   返回 大小
 @parm font  字体
 @parm size  限制的宽度或高度
 */
- (CGSize )calculateheight:(UIFont *)font andcontSize:(CGSize )size;
/**
 *  根据字体大小 计算
 */
- (CGSize)calculateheight:(UIFont *)font;

/**
 *  根据传进来的字符串 设置为特定的颜色和字体
 *
 *  @param color          特定的颜色
 *  @param font           特定的字体
 *  @param defaulColor    默认颜色
 *  @param defaultFont    默认字体
 *  @param equalString    匹配的文字
 *  @param attributedText 当前字符的attributedString
 *  @param isright        是否靠右
 *
 *  @return  NSAttributedString
 */
- (NSAttributedString *)setVariedWidthColor:(UIColor *)color font:(UIFont *)font defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont equalString:(NSString *)equalString attributedText:(NSAttributedString *)attributedText isalignmentRight:(BOOL )isright;

/**
 *  从equalString 这个字符串开始 往后设置特定的颜色、字体
 *
 *  @param color          特定的颜色
 *  @param font           特定的字体
 *  @param defaulColor    默认颜色
 *  @param defaultFont    默认字体
 *  @param equalString    匹配的文字
 *  @param attributedText 当前字符的attributedString
 *  @param isright        是否靠右
 */
- (NSAttributedString *)setVariedColor:(UIColor *)color font:(UIFont *)font defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont equalString:(NSString *)equalString attributedText:(NSAttributedString *)attributedText isalignmentRight:(BOOL )isright;

/**
 *  设置相同的字或多个字符串设定特定的颜色和字体  isAll 是 stringArray 查找到对应的字会替换成一样的字体大小和字体颜色  否 不会把所有相同的字替换成相同的颜色和字体大小
 *
 *  @param colorArray     颜色数组
 *  @param fontArray      字体数组
 *  @param stringArray    字数组
 *  @param defaulColor    默认颜色
 *  @param defaultFont    默认字体
 *  @param attributedText 当前字符的attributedString
 *  @param isAll          相同的字是否全部设置为一样的颜色和字体
 *
 *  @return NSAttributedString
 */
- (NSAttributedString *)setVariedColorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray string:(NSArray *)stringArray defaultColor:(UIColor *)defaulColor defaultFont:(UIFont *)defaultFont attributedText:(NSAttributedString *)attributedText isAll:(BOOL)isAll ;

/**
 *  判断是否为邮箱
 */
+ (BOOL)isValidateEmail:(NSString *)Email;
/**
 *  判断密码
 *  @return BOOL
 */
+ (BOOL)isvalidatePassword:(NSString *)passWord ;
/*!
 *  判断是否为字母
 *  @return BOOL
 */
- (BOOL)isValidLetter;

// 是否是大写字母
- (BOOL)isUppercaseLetter;

// 是否是小写字母
- (BOOL)isLowercaseLetter;

/*!
 *  判断是否为支付密码
 */
+ (BOOL)isValidatePayPassword:(NSString *)payPassWord;

/**
 *  保留数字和字母
 */
+ (NSString *)retentionIntAndLetter:(NSString *)str;
/**
 *  保留数字
 */
+ (NSString *)retentionInt:(NSString *)str;

/**
 *  是汉语
 *  @return BOOL
 */
+ (BOOL)isChinese:(NSString *)str;
/**
 *  去掉中文
 */
+ (NSString *)deleteChinese:(NSString *)str;

/**
 *  链接编码 不对＃进行编码
 */
+ (NSString *)concatenatedCoding:(NSString *)urlPath;
/**
 *  对特殊编码的编码
 */
+ (NSString *)concatenatedKey:(NSString *)key;

/**
 *  过滤空格 和换行符
 */
+ (NSString *)removeairAndWrap:(NSString *)string;

/// 去除首尾空格
- (NSString *)removeHeadTailWrap;

/**
 *  判断是否身份证号码
 *
 */
+ (BOOL)isvalidateIdentityCard: (NSString *)identityCard ;
/**
 *  判断是否为姓名   真实姓名可以是汉字，也可以是字母，但是不能两者都有，也不能包含任何符号和数字
 */
+ (BOOL)isValidateName:(NSString *)name ;
/**
 *  判断是否是中文和英文
 */
+ (BOOL)isValidateEnAndZHName:(NSString *)name;
/**
 *
 *
 *  金额  只能输入数字和.
 *
 *  @param oldString         原来的值
 *  @param replacementString 替换的值
 *  @param rang              替换的位置
 *  @param isTwo             是否小数后两位
 *  @param isInt             是否整型
 *
 *  @return NSString
 */
+ (NSString *)isValidatePrice:(NSString *)oldString replacementString:(NSString *)replacementString rang:(NSRange )rang  isTwo:(BOOL)isTwo isInt:(BOOL)isInt ;
/**
 *  判断价格是否超过最大的限制  price 判断价格  maxInteger 最大的整形（111111） maxDecimal 最大的小数（99）
 *  maxInteger 若有输入小数 只会取小数钱的 小数后不取   maxDecimal 只会取前两位 有小数也不会取小数 不够两位在后面补0
 */
+ (BOOL)exceedsTheMaximum:(NSString *)price maxInteger:(NSString *)maxInteger maxDecimal:(NSString *)maxDecimal;
/**
 *  随机产生 32 位
 */
+(NSString *)ret32bitString;
/**
 *  得到百倍于当前数字值的字符串
 */
+ (NSString *)getNoPointStr:(NSString *)str;
/**
 *  将价格变成小数后两位的价格字符串  只适用 加 减的
 */
+ (NSString *)obtainTotalPrice:(NSInteger)totalPrice;


/**
 *  根据单价和数量的字符串获取总价的字符串
 */
+ (NSString *)getTotalPriceStringWithPrice:(NSString *)price withNum:(NSString *)numStr;

/**
 *  图文混排 设置图片的大小 imageArray 对象为UIimage 属性
 */
+ (NSAttributedString *)obtainImageAndTextAtImageSize:(CGSize )imageSize imageArray:(NSArray *)imageArray textArray:(NSArray *)textArray;
/**
 *  转换后的手机号码  convertedString  替换成数据  例如 (****)
 */
+ (NSString *)convertedPhone:(NSString *)convertedString phone:(NSString *)phone;

/// 隐藏手机号中间信息
/// phohe 手机号
/// tmp 替换占位符
/// digits 需要显示的首位个数
+ (NSString *)hiddenPhoneNumInfo:(NSString *)phone tmp:(NSString *)tmp displayDigits:(NSUInteger)digits;

/**
 *  将秒装换成时分秒
 */
+(NSDictionary *)timeformatFromSeconds:(NSInteger)seconds;
/**
 *  判断价格price是否小于等于 当前的价格
 */
- (BOOL)comparePrice:(NSString *)price;
/**
 *  保留数字  剔除所有非数字的字符串
 */
- (NSString *)retentionIntString;

// 将字符串转成二进制流形式的字符串显示
- (NSString *)binaryString;

// 是否是数字
- (BOOL)isValidNumber;

- (NSString *)cutEncryptKeyForUrl;

// 是否是符号
- (BOOL)isValidSymbol;

- (NSDictionary *)dictionaryWithJsonString;

@end
