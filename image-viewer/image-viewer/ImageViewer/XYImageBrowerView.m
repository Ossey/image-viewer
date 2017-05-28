//
//  XYImageBrowerView.m
//  image-viewer
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYImageBrowerView.h"
#import "XYImageView.h"
#import "UIImageView+WebCache.h"

@interface XYImageBrowerView () <UIScrollViewDelegate, XYImageViewDelegate>
/// 图片数组，3个 UIImageView, 进行复用
@property (nonatomic, strong) NSMutableArray<XYImageView *> *pictureViews;
/// 准备待用的图片视图（缓存）
@property (nonatomic, strong) NSMutableArray<XYImageView *> *readyToUsePictureViews;
/// 图片张数
@property (nonatomic, assign) NSInteger picturesCount;
/// 当前页数
@property (nonatomic, assign) NSInteger currentPage;
/// 界面子控件
@property (nonatomic, weak) UIScrollView *scrollView;
/// 页码文字控件
@property (nonatomic, weak) UILabel *pageTextLabel;
/// 消失的 tap 手势
@property (nonatomic, weak) UITapGestureRecognizer *dismissTapGes;

@end

@implementation XYImageBrowerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    // 设置默认属性
    self.betweenImagesSpacing = 20;
    self.pageTextFont = [UIFont systemFontOfSize:16];
    self.pageTextCenter = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - 20);
    self.pageTextColor = [UIColor whiteColor];
    // 初始化数组
    self.pictureViews = [NSMutableArray array];
    self.readyToUsePictureViews = [NSMutableArray array];
    
    // 初始化 scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-_betweenImagesSpacing * 0.5, 0, self.frame.size.width + _betweenImagesSpacing, self.frame.size.height)];
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.pagingEnabled = true;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 初始化label
    UILabel *label = [[UILabel alloc] init];
    label.alpha = 0;
    label.textColor = self.pageTextColor;
    label.center = self.pageTextCenter;
    label.font = self.pageTextFont;
    [self addSubview:label];
    self.pageTextLabel = label;
    
    // 添加手势事件
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longGes];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self addGestureRecognizer:tapGes];
    self.dismissTapGes = tapGes;
}

- (void)showFromView:(UIView *)fromView picturesCount:(NSInteger)picturesCount currentPictureIndex:(NSInteger)currentPictureIndex {
    
    NSString *errorStr = [NSString stringWithFormat:@"Parameter is not correct, pictureCount is %zd, currentPictureIndex is %zd", picturesCount, currentPictureIndex];
    NSAssert(picturesCount > 0 && currentPictureIndex < picturesCount, errorStr);
    NSAssert(self.delegate != nil, @"Please set up delegate for pictureBrowser");
    
    // 记录值并设置位置
    _currentPage = currentPictureIndex;
    self.picturesCount = picturesCount;
    [self setPageText:currentPictureIndex];
    // 添加到 window 上
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    // 计算 scrollView 的 contentSize
    self.scrollView.contentSize = CGSizeMake(picturesCount * _scrollView.frame.size.width, _scrollView.frame.size.height);
    // 滚动到指定位置
    [self.scrollView setContentOffset:CGPointMake(currentPictureIndex * _scrollView.frame.size.width, 0) animated:false];
    // 设置第1个 view 的位置以及大小
    XYImageView *imageView = [self setPictureViewForIndex:currentPictureIndex];
    // 获取来源图片在屏幕上的位置
    CGRect rect = [fromView convertRect:fromView.bounds toView:nil];
    
    [imageView animationShowWithFromRect:rect duration:self.duration animationBlock:^{
        self.backgroundColor = [UIColor blackColor];
        self.pageTextLabel.alpha = 1;
    } completionBlock:^{
        // 设置左边与右边的 pictureView
        if (currentPictureIndex != 0 && picturesCount > 1) {
            // 设置左边
            [self setPictureViewForIndex:currentPictureIndex - 1];
        }
        
        if (currentPictureIndex < picturesCount - 1) {
            // 设置右边
            [self setPictureViewForIndex:currentPictureIndex + 1];
        }
    }];
}

- (void)dismiss {
    UIView *endView = [_delegate imageBrowerView:self viewForIndex:_currentPage];
    // 取到当前显示的 pictureView
    XYImageView *imageView = [[_pictureViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d", _currentPage]] firstObject];
    // 取消所有的下载
    for (XYImageView *imageView in _pictureViews) {
        [imageView.imageView sd_cancelCurrentImageLoad];
    }
    
    for (XYImageView *imageView in _readyToUsePictureViews) {
        [imageView.imageView sd_cancelCurrentImageLoad];
    }
    
    CGRect endRect = [endView convertRect:endView.bounds toView:nil];
    if (!endView) {
        endRect = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)*0.5, CGRectGetHeight([UIScreen mainScreen].bounds)*0.5, 0, 0);
    }
    // 执行关闭动画
    [imageView animationDismissWithToRect:endRect duration:self.duration animationBlock:^{
        self.backgroundColor = [UIColor clearColor];
        self.pageTextLabel.alpha = 0;
    } completionBlock:^{
        [self removeFromSuperview];
        if (self.dismissCallBack) {
            self.dismissCallBack();
        }
    }];
}

#pragma mark - 监听事件

- (void)tapGes:(UITapGestureRecognizer *)ges {
    [self dismiss];
}

- (void)longPress:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateEnded) {
        if (self.longPressBlock) {
            self.longPressBlock(_currentPage);
        }
    }
}

#pragma mark - 私有方法

- (void)setPageTextFont:(UIFont *)pageTextFont {
    _pageTextFont = pageTextFont;
    self.pageTextLabel.font = pageTextFont;
}

- (void)setPageTextColor:(UIColor *)pageTextColor {
    _pageTextColor = pageTextColor;
    self.pageTextLabel.textColor = pageTextColor;
}

- (void)setPageTextCenter:(CGPoint)pageTextCenter {
    _pageTextCenter = pageTextCenter;
    [self.pageTextLabel sizeToFit];
    self.pageTextLabel.center = pageTextCenter;
}

- (void)setBetweenImagesSpacing:(CGFloat)betweenImagesSpacing {
    _betweenImagesSpacing = betweenImagesSpacing;
    self.scrollView.frame = CGRectMake(-_betweenImagesSpacing * 0.5, 0, self.frame.size.width + _betweenImagesSpacing, self.frame.size.height);
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage) {
        return;
    }
    NSUInteger oldValue = _currentPage;
    _currentPage = currentPage;
    [self removeViewToReUse];
    [self setPageText:currentPage];
    // 如果新值大于旧值
    if (currentPage > oldValue) {
        // 往右滑，设置右边的视图
        if (currentPage + 1 < _picturesCount) {
            [self setPictureViewForIndex:currentPage + 1];
        }
    }else {
        // 往左滑，设置左边的视图
        if (currentPage > 0) {
            [self setPictureViewForIndex:currentPage - 1];
        }
    }
    
}

/**
 设置pitureView到指定位置
 
 @param index 索引
 
 @return 当前设置的控件
 */
- (XYImageView *)setPictureViewForIndex:(NSInteger)index {
    [self removeViewToReUse];
    XYImageView *view = [self getPhotoView];
    view.index = index;
    CGRect frame = view.frame;
    frame.size = self.frame.size;
    view.frame = frame;
    
    // 设置图片的大小<在下载完毕之后会根据下载的图片计算大小>
    CGSize defaultSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    
    void(^setImageSizeBlock)(UIImage *) = ^(UIImage *image) {
        if (image != nil) {
            if (image != nil) {
                view.pictureSize = image.size;
            }else {
                view.pictureSize = defaultSize;
            }
        }
    };
    
    // 1. 判断是否实现图片大小的方法
    if ([_delegate respondsToSelector:@selector(imageBrowerView:imageSizeForIndex:)]) {
        view.pictureSize = [_delegate imageBrowerView:self imageSizeForIndex:index];
    }else if ([_delegate respondsToSelector:@selector(imageBrowerView:defaultImageForIndex:)]) {
        UIImage *image = [_delegate imageBrowerView:self defaultImageForIndex:index];
        // 2. 如果没有实现，判断是否有默认图片，获取默认图片大小
        setImageSizeBlock(image);
    } else if ([_delegate respondsToSelector:@selector(imageBrowerView:viewForIndex:)]) {
        UIView *v = [_delegate imageBrowerView:self viewForIndex:index];
        if ([v isKindOfClass:[UIImageView class]]) {
            UIImage *image = ((UIImageView *)v).image;
            setImageSizeBlock(image);
            // 并且设置占位图片
            view.placeholderImage = image;
        }
    }else {
        // 3. 如果都没有就设置为屏幕宽度，待下载完成之后再次计算
        view.pictureSize = defaultSize;
    }
    
    // 设置占位图
    if (_delegate && [_delegate respondsToSelector:@selector(imageBrowerViewWithImageNameArray:)]) {
        NSArray *imageNames = [_delegate imageBrowerViewWithImageNameArray:self];
        view.placeholderImage = [UIImage imageNamed:imageNames[index]];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(imageBrowerView:defaultImageForIndex:)]) {
            view.placeholderImage = [_delegate imageBrowerView:self defaultImageForIndex:index];
        }
    }
    
    
    // 设置显示的图片
    if (_delegate && [_delegate respondsToSelector:@selector(imageBrowerViewWithOriginalImageUrlStrArray:)]) {
        NSArray *urlStrArr = [_delegate imageBrowerViewWithOriginalImageUrlStrArray:self];
        view.urlString = [urlStrArr objectAtIndex:index];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(imageBrowerView:highQualityUrlStringForIndex:)]) {
            
            view.urlString = [_delegate imageBrowerView:self highQualityUrlStringForIndex:index];
        }
    }
    
    CGPoint center = view.center;
    center.x = index * _scrollView.frame.size.width + _scrollView.frame.size.width * 0.5;
    view.center = center;
    return view;
}


/**
 获取图片控件：如果缓存里面有，那就从缓存里面取，没有就创建
 
 @return 图片控件
 */
- (XYImageView *)getPhotoView {
    XYImageView *view;
    if (_readyToUsePictureViews.count == 0) {
        view = [XYImageView new];
        // 手势事件冲突处理
        [self.dismissTapGes requireGestureRecognizerToFail:view.imageView.gestureRecognizers.firstObject];
        view.imageViewDelegate = self;
    }else {
        view = [_readyToUsePictureViews firstObject];
        [_readyToUsePictureViews removeObjectAtIndex:0];
    }
    [_scrollView addSubview:view];
    [_pictureViews addObject:view];
    return view;
}

- (CGFloat)duration {
    
    return _duration ?: 0.25;
}

/**
 移动到超出屏幕的视图到可重用数组里面去
 */
- (void)removeViewToReUse {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (XYImageView *view in self.pictureViews) {
        // 判断某个view的页数与当前页数相差值为2的话，那么让这个view从视图上移除
        if (abs((int)view.index - (int)_currentPage) == 2){
            [tempArray addObject:view];
            [view removeFromSuperview];
            [_readyToUsePictureViews addObject:view];
        }
    }
    [self.pictureViews removeObjectsInArray:tempArray];
}

/**
 设置文字，并设置位置
 */
- (void)setPageText:(NSUInteger)index {
    _pageTextLabel.text = [NSString stringWithFormat:@"%zd / %zd", index + 1, self.picturesCount];
    [_pageTextLabel sizeToFit];
    _pageTextLabel.center = self.pageTextCenter;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger page = (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.currentPage = page;
}

#pragma mark - ESPictureViewDelegate

- (void)imageViewTouch:(XYImageView *)imageView {
    [self dismiss];
}

- (void)imageView:(XYImageView *)imageView scale:(CGFloat)scale {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1 - scale];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
