#define URL1 @"http://pic1.win4000.com/wallpaper/6/543e3204dbd36.jpg"
#define URL2 @"http://attach.bbs.miui.com/forum/201705/04/175246q6df7b1bqbkgbu9w.jpg"
#define URL3 @"http://pic.jj20.com/up/allimg/1011/05241G14R6/1F524114R6-18.jpg"
#define URL4 @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1497664298&di=0b8accc826a3a0e2e51815b8ccd674e7&src=http://img3.iqilu.com/data/attachment/forum/201308/22/091951pb327xq9ebwbhfkw.jpg"

#import "ViewController.h"
#import "ZLLCycleScrollView.h"

@interface ViewController ()

/* url加载一张图片的情况 */
@property(nonatomic,strong)ZLLCycleScrollView *cycleScrollView1;
/* url加载两张图片轮播 */
@property(nonatomic,strong)ZLLCycleScrollView *cycleScrollView2;
/* contentsOfFile加载三张图片轮播 */
@property(nonatomic,strong)ZLLCycleScrollView *cycleScrollView3;
/* imageNames加载四张图片轮播 */
@property(nonatomic,strong)ZLLCycleScrollView *cycleScrollView4;
@end

@implementation ViewController

#pragma mark - 懒加载
-(ZLLCycleScrollView *)cycleScrollView1{
    
    if (!_cycleScrollView1) {
        
        NSArray *urlStrings = @[URL1];
        CGRect rect = CGRectMake(0, 10, 375,150);
        _cycleScrollView1 = [ZLLCycleScrollView zll_cycleScrollViewWithFrame:rect imageUrlStrings:urlStrings placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    return _cycleScrollView1;
    
}
-(ZLLCycleScrollView *)cycleScrollView2
{
    if (!_cycleScrollView2) {

        NSArray *urlStrings = @[URL1,URL2];
        CGRect rect = CGRectMake(0,170, 375,150);
        _cycleScrollView2 = [ZLLCycleScrollView zll_cycleScrollViewWithFrame:rect imageUrlStrings:urlStrings placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    return _cycleScrollView2;
}
-(ZLLCycleScrollView *)cycleScrollView3
{
    if (!_cycleScrollView3) {
        NSArray *files = @[[[NSBundle mainBundle] pathForResource:@"0.png" ofType:nil],
                           [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil],
                           [[NSBundle mainBundle] pathForResource:@"2.png" ofType:nil]];
        CGRect rect = CGRectMake(0, 330, 375,150);
        _cycleScrollView3 = [ZLLCycleScrollView zll_cycleScrollViewWithFrame:rect imageContentsOfFiles:files placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    return _cycleScrollView3;
}

-(ZLLCycleScrollView *)cycleScrollView4
{
    if (!_cycleScrollView4) {
        NSArray *imageNames = @[@"0.png",@"1.png",@"2.png",@"3.png"];
        CGRect rect = CGRectMake(0, 490, 375,150);
        _cycleScrollView4 = [ZLLCycleScrollView zll_cycleScrollViewWithFrame:rect imageNames:imageNames placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    }
    return _cycleScrollView4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupSubViews];
  
    //添加点击事件调用接口示例
    [self.cycleScrollView4 zll_scrollViewWithSelectItemBlock:^(id item, NSInteger index) {
        NSLog(@"%@----------index = %ld",item,index);
    }];
}

/**
 * 添加cycleScrollView到view上
 */
-(void)setupSubViews
{
    [self.view addSubview:self.cycleScrollView1];
    [self.view addSubview:self.cycleScrollView2];
    [self.view addSubview:self.cycleScrollView3];
    [self.view addSubview:self.cycleScrollView4];
}

@end
