
#import "ZLLCycleScrollView.h"
#import "UIImageView+WebCache.h"

@interface ZLLCycleScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

//scrollView
@property (strong, nonatomic) UIScrollView *scrollView;

//pageControl
@property (strong, nonatomic) UIPageControl *pageControl;

// 背景图
@property (nonatomic, strong) UIImageView *backgroundImageView;

//定时
@property (nonatomic,strong) NSTimer *timer;

//所有的图片url
@property(nonatomic,strong)NSArray *urlStrings;

//所有图片的名字
@property(nonatomic,strong)NSArray *imageNames;

//所有图片的contentsOfFile
@property(nonatomic,strong)NSArray *files;

//整合数组（urlStrings/imageNames/files）
@property(nonatomic,strong)NSArray *imageArray;

@end

@implementation ZLLCycleScrollView

#pragma mark - 懒加载
-(UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    }

    return _backgroundImageView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        //_scrollView的基本设置
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        NSInteger count = self.imageArray.count;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(count*width, 0);
        _scrollView.userInteractionEnabled = YES;
        //在scrollView上添加imageView
        for (int i = 0; i< count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
            if (self.urlStrings) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlStrings[i]]];
            }else if(self.imageNames){
                imageView.image = [UIImage imageNamed:self.imageNames[i]];
            }else{
                imageView.image = [UIImage imageWithContentsOfFile:self.files[i]];
            }
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)]];
            [_scrollView addSubview:imageView];
        }
        
        //如果轮播图片的个数不是一个或者两个，则在scrollView后再加一个和第一张图片一样的图片(为了实现无限轮播效果)
        if (count !=0 && count!=1) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(count*width, 0, width, height)];
            if (self.urlStrings) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlStrings[0]]];
            }else if(self.imageNames){
                imageView.image = [UIImage imageNamed:self.imageNames[0]];
            }else{
                imageView.image = [UIImage imageWithContentsOfFile:self.files[0]];
            }
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)]];
            [_scrollView addSubview:imageView];
            _scrollView.contentSize = CGSizeMake((count+1)*width, 0);
        }
    }
    return _scrollView;

}
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        CGFloat height = self.bounds.size.height;
        CGFloat width = self.bounds.size.width;
        //pageControll的位置在中间
        if (self.pageControlAliment == ZLLCycleScrollViewPageContolAlimentCenter) {
            _pageControl.frame = CGRectMake(0, height-20, width, 20);
        }else{ //pageControll的位置在右面（defaylt）
            _pageControl.frame = CGRectMake(width-70, height-20, 50, 20);
        }
        
        //设置显示个数 默认为0
        _pageControl.numberOfPages = self.imageArray.count;
        //设置当前页之外的点的颜色
        _pageControl.pageIndicatorTintColor = self.pageDotColor?self.pageDotColor:[UIColor redColor];
        //设置当前指示点的颜色
        _pageControl.currentPageIndicatorTintColor = self.currentPageDotColor?self.currentPageDotColor:[UIColor whiteColor];
        _pageControl.currentPage = 0;
        
    }
    
    return _pageControl;
    
}

#pragma mark - 设置定时器
-(void)setupTimer
{
    NSInteger timeInterval = self.timeInterval?self.timeInterval:2;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
}

#pragma mark - 实现图片无限轮播
- (void)automaticScroll
{
    float offset_X = self.scrollView.contentOffset.x;
    NSInteger count = self.imageArray.count;
    CGFloat width = self.bounds.size.width;
    
    //如果只有两张图片轮播的情况
    if (count == 2) {
        offset_X = offset_X == 0 ?  width :  0;
        self.pageControl.currentPage = offset_X/width;
        [self.scrollView setContentOffset:CGPointMake(offset_X, 0) animated:YES];
        return;
    }
    //其他情况
    offset_X += width;
    if (offset_X > width * count) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    self.pageControl.currentPage = offset_X == width * count?0:offset_X/width;
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    if (offset_X > width *count) {
        self.pageControl.currentPage = 1;
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:resultPoint animated:YES];
    }
}

#pragma mark - 处理图片点击事件
-(void)imageViewClick:(UITapGestureRecognizer *)tapRestureRecognizer{

    UIImageView *imageView = (UIImageView *)tapRestureRecognizer.view;
    NSInteger index = [self.scrollView.subviews indexOfObject:imageView];
    NSInteger count = self.imageArray.count;
    if (index>1 && index == count){
        imageView = self.scrollView.subviews[0];
        index = 0;
    }
    if (_selectItemBlock) {
         _selectItemBlock(imageView,index);
    }
}

#pragma mark - 外部接口
+(instancetype)zll_cycleScrollViewWithFrame:(CGRect)frame imageUrlStrings:(NSArray *)urlStrings placeholderImage:(UIImage *)placeholderImage
{

    ZLLCycleScrollView *cycleView = [[self alloc]initWithFrame:frame];
    
    cycleView.urlStrings = urlStrings;
    
    [cycleView imageArray:urlStrings placeholderImage:placeholderImage];

    return cycleView;
}

+(instancetype)zll_cycleScrollViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames placeholderImage:(UIImage *)placeholderImage
{
    ZLLCycleScrollView *cycleView = [[self alloc]initWithFrame:frame];
    
    cycleView.imageNames = imageNames;
    
    [cycleView imageArray:imageNames placeholderImage:placeholderImage];
    
    return cycleView;

}

+(instancetype)zll_cycleScrollViewWithFrame:(CGRect)frame imageContentsOfFiles:(NSArray *)files placeholderImage:(UIImage *)placeholderImage
{
    ZLLCycleScrollView *cycleView = [[self alloc]initWithFrame:frame];
    
    cycleView.files = files;
    
    [cycleView imageArray:files placeholderImage:placeholderImage];
    
    return cycleView;

}

-(void)imageArray:(NSArray *)imageArray placeholderImage:(UIImage *)placeholderImage
{
    //如果有占位图片
    if (placeholderImage) {
        [self insertSubview:self.backgroundImageView atIndex:0];
        self.backgroundImageView.image = placeholderImage;
    }
    //如果有图片
    if (imageArray) {
        self.imageArray = imageArray;
        [self addSubview:self.scrollView];
        
        //如果图片轮播的数量不是1，则添加pageControl和定时器
        if (imageArray.count!=1) {
            [self addSubview:self.pageControl];
            [self setupTimer];
        }
    }
}

-(void)zll_scrollViewWithSelectItemBlock:(SelectItemBlock)selectItemBlock
{
    _selectItemBlock = [selectItemBlock copy];
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //手动拖拽scrollView的时候定时器无效
    [self.timer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //停止拖动的时候重新启动定时器
    [self setupTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置停止拖拽的时候的currentPage
    float offset_X = self.scrollView.contentOffset.x;
    NSInteger count = self.imageArray.count;
    CGFloat width = self.bounds.size.width;
    self.pageControl.currentPage = offset_X == width * count?0:offset_X/width;
}






@end
