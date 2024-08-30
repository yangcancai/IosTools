//
//  aa.m
//  IosTools
//
//  Created by vv on 2024/8/27.
//

#import "LanguageController.h"
#import "LanguageCell.h"
#define LanguageCellID @"LanguageCell"
@interface LanguageController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *languagesTable;    /**< app支持的多语言table */
@property (strong, nonatomic) NSMutableArray *languages;             /**< 多语言table的数据源 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;         /**< 当前用户采用的语言index */

@end

@implementation LanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self onView];
    self.languagesTable.dataSource = self;
    self.languagesTable.userInteractionEnabled = YES;
    self.languagesTable.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)onView{
    self.title = LocalKey(@"language_languages");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:LocalKey(@"Save")
                                              style:UIBarButtonItemStylePlain target:self action:@selector(updateAppLanguage)];
    [self.languagesTable registerNib:[UINib nibWithNibName:@"LanguageCell" bundle:nil] forCellReuseIdentifier:LanguageCellID];
    
    self.languages = @[].mutableCopy;
    // 1.获取app内的用户语言设置
    [Utils getLanguageSetting:^(NSString *langID, BOOL followedSys) {
        if (followedSys == NO && langID.length == 0) {
            // 2.首次进入语言设置-默认跟随系统
            [Utils setLanguageSetting:@"" followedSys:YES];
            langID = @"";
            followedSys = YES;
        }

        // 3.app目前支持的语言
        NSArray *arr = @[
                               @{
                                 @"langID": @"0",               // 0为采用系统设置的语言
                                 @"isCurrent": @(followedSys),
                                 },
                               @{
                                 @"langID": @"zh",
                                 @"isCurrent": [langID hasPrefix:@"zh"] ? @(1) : @(0),
                                 },
                               @{
                                 @"langID": @"en",
                                 @"isCurrent": [langID hasPrefix:@"en"] ? @(1) : @(0)},
                               ];

        for (NSDictionary *dic in arr){
            NSString *langID = dic[@"langID"];
            NSString *langDes = @"";
            if ([langID isEqualToString:@"0"]){
                langDes = LocalKey(@"language_followSystem");
            } else {
                langDes = [Utils languageDes:langID];
            }

            Language *lang = [Language LanguageID:langID languageDes:langDes currentLanguage:[dic[@"isCurrent"] boolValue]];
            [self.languages addObject:lang];
        }
    }];
}

// 更改本地语言设置
- (void)saveLocalLanguageSetting {
    Language *lang = self.languages[self.currentIndexPath.row];
    BOOL followSys = [lang.languageID isEqualToString:@"0"];
    [Utils setLanguageSetting:followSys ? @"" : lang.languageID followedSys:followSys];
}

// 更新App语言
- (void)updateAppLanguage {
  //  UIApplication.sharedApplication.keyWindow.userInteractionEnabled = NO;
  //  UIApplication.sharedApplication.applicationSupportsShakeToEdit = NO;
    
    //[SVProgressHUD showWithStatus:MCLocalKey(@"Loading")];
   // [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    // 本地语言设置更改
        [self saveLocalLanguageSetting];
        // ShortcutItems本地化更新
//        [MC3DTouch localizedShortcutItems];
//        
//        // 更新界面到新语言 --（未登陆不可向服务器发IQ同步语言设置--(token失效相关问题)）
//        UIViewController *vc = [self newLanguageRootController];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            LockScreen *lockScreenInfo = AdvancedFunctionManager.cachedAdvancedFunctionInfo.lockScreenInfo;
//            if (lockScreenInfo.locked) {
////                lockScreenInfo.locked = NO;
////                [AdvancedFunctionManager saveAdvancedFunctionInfo];
//                
//            } else {
//                UIWindow *window = [(AppDelegate *)UIApplication.sharedApplication.delegate window];
//                window.rootViewController = vc;
//            }
//            
//           // [SVProgressHUD dismiss];
//            UIApplication.sharedApplication.keyWindow.userInteractionEnabled = YES;
//            UIApplication.sharedApplication.applicationSupportsShakeToEdit=YES;
//        });
}

// 获取切换成新语言的root controller
//- (UIViewController *)newLanguageRootController {
//    UIWindow *window = [(AppDelegate *)UIApplication.sharedApplication.delegate window];
//    UIViewController *rootVC = window.rootViewController;
//    UIViewController *newRootVC = nil;
//    if ([rootVC isKindOfClass:UINavigationController.class]){
//        UINavigationController *newNaviVC = [[rootVC.class alloc] init];
//        UIViewController *oldNaviRootVc = [(UINavigationController *)rootVC rootController];
//        UIViewController *newVC = nil;
//        
//        if ([oldNaviRootVc isKindOfClass:LoginController.class]){
//            LoginController *loginVC = UIStoryboard_VC(SB_UserLogin, NSStringFromClass(LoginController.class));
//            newVC = loginVC;
//        } else {
//            newVC = [[oldNaviRootVc.class alloc] init];
//        }
//        
//        newNaviVC.viewControllers = @[newVC];
//        newRootVC = newNaviVC;
//    } else {
//        newRootVC = [[rootVC.class alloc] init];
//    }
//    
//    return newRootVC;
//}

// 点击刷新列表勾选
- (void)refreshTable:(NSIndexPath *)indexPath {
    if (self.currentIndexPath != indexPath){
        Language *newLang = self.languages[indexPath.row];
        newLang.currentLanguage = YES;
        
        Language *oldLang = self.languages[self.currentIndexPath.row];
        oldLang.currentLanguage = NO;
        self.currentIndexPath = indexPath;
        [self.languagesTable reloadData];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.languages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:LanguageCellID forIndexPath:indexPath];
    cell.language = self.languages[indexPath.row];
    if (cell.language.currentLanguage){
        self.currentIndexPath = indexPath;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self refreshTable:indexPath];
}

- (void)request_uploadChatTranslateLanguages {
    //[[TranslateManager sharedManager] refreshLanuage:nil];
}
@end
