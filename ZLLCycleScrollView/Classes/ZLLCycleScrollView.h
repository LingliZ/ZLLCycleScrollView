

#import <UIKit/UIKit.h>

typedef void (^SelectItemBlock)(id item,NSInteger index);

@interface ZLLCycleScrollView : UIView
{
    SelectItemBlock _selectItemBlock;
    
}

/** PageContol位置的枚举 */
typedef enum {
    ZLLCycleScrollViewPageContolAlimentRight,
    ZLLCycleScrollViewPageContolAlimentCenter
} ZLLCycleScrollViewPageContolAliment;

/** 分页控件位置 */
@property (nonatomic, assign) ZLLCycleScrollViewPageContolAliment pageControlAliment;//defaule is ZLLCycleScrollViewPageContolAlimentRight

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor; //defaule is white

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor; //defaule is red

/** 定时器的时间间隔*/
@property(nonatomic,assign)NSInteger timeInterval; //default is 2 seconds

/**
 * 设置轮播view
 */
+(instancetype)zll_cycleScrollViewWithFrame:(CGRect)frame imageUrlStrings:(NSArray *)urlStrings placeholderImage:(UIImage *)placeholderImage;

+(instancetype)zll_cycleScrollViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames placeholderImage:(UIImage *)placeholderImage;

+(instancetype)zll_cycleScrollViewWithFrame:(CGRect)frame imageContentsOfFiles:(NSArray *)files placeholderImage:(UIImage *)placeholderImage;

- (void)zll_scrollViewWithSelectItemBlock:(SelectItemBlock)selectItemBlock;

@end
