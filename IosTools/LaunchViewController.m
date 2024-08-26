#import "LaunchViewController.h"
#import "ViewController.h"

@interface LaunchViewController ()

@property (strong, nonatomic) UILabel *helloWorldLabel;
//@property (strong, nonatomic) UIImageView *launchImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self launchAnimation:nil];
    }
- (void)launchAnimation:(void (^)(BOOL completed))completion {
    UIImageView *launchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch01"]];
    launchImageView.frame = self.view.bounds;
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i ++) {
        NSInteger index = [self launchIndex:i];
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"launch0%d", (long)index]]];
    }
    launchImageView.userInteractionEnabled = YES;
    launchImageView.animationImages = images;
    launchImageView.animationDuration = 3;
    launchImageView.animationRepeatCount = 1;
    launchImageView.contentMode = UIViewContentModeScaleAspectFill;
    launchImageView.clipsToBounds = YES;
    [launchImageView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [launchImageView stopAnimating];
        !completion?:completion(YES);
        [self transitionToMainView];
    });
    //self.launchImageView = launchImageView;
    [self.view addSubview:launchImageView];
}

- (void)transitionToMainView {
    // 切换到主视图控制器
    ViewController *mainViewController = [[ViewController alloc] init];
    mainViewController.view.backgroundColor = [UIColor whiteColor]; // 设置主视图控制器的背景色
    self.view.window.rootViewController = mainViewController;
}
-(NSInteger) launchIndex:(NSInteger)i{
    if (i <7 ) return 3;
    else if(i<14) return 2;
    else return 1;
}
@end
