//
//  aa.m
//  IosTools
//
//  Created by vv on 2024/8/27.
//

#import "LanguageController.h"
@interface LanguageController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *languagesTable;    /**< app支持的多语言table */
@property (strong, nonatomic) NSMutableArray *languages;             /**< 多语言table的数据源 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;         /**< 当前用户采用的语言index */

@end

@implementation LanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self onView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)onView{
    self.title = LocalKey(@"language_languages");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:LocalKey(@"Save")
                                              style:UIBarButtonItemStylePlain target:self action:@selector(updateLang)];
}
-(void)updateLang{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.languages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:LanguageCellID forIndexPath:indexPath];
//    cell.language = self.languages[indexPath.row];
//    if (cell.language.currentLanguage){
//        self.currentIndexPath = indexPath;
//    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self refreshTable:indexPath];
}

- (void)request_uploadChatTranslateLanguages {
//    [[TranslateManager sharedManager] refreshLanuage:nil];
}
@end
