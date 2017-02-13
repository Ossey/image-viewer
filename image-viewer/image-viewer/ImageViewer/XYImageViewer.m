//
//  XYImageViewer.m
//  image-viewer
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYImageViewer.h"
#import "XYImageBrowerView.h"

@interface XYImageViewer () <XYImageBrowerViewDelegate>

/// 图片浏览器视图
@property (nonatomic, strong) XYImageBrowerView *brower;
/// 图片的尺寸数组，当加载本地图片时可用，网络请求不需要
@property (nonatomic, strong) NSArray* imageSizes;
/// 获取点击的当前视图
@property (nonatomic, strong) UIView *fromView;
/// 关闭图片浏览器时点击对应索引的视图, 回调给外界当前点击的索引，外界从tableView或者collectionView中找到对应的cell给我即可
@property (nonatomic, strong) UIView *(^endViewBlock)(NSIndexPath *);
/// 获取对应索引默认图片，可以是占位图片，可以是缩略图
@property (nonatomic, strong) UIImage *image;
/// 需要展示的图片数组，当传入urlStrList后就不用传这个属性了
@property (nonatomic, strong) NSArray<NSString *> *images;
/// 图片的url 字符串数组
@property (nonatomic, strong) NSArray<NSString *> *urlStrList;
/// 当外界调用了prepareImageURLList时为YES，调用prepareImages时为NO
@property (nonatomic, assign, getter=isRequestFromNetwork) BOOL requestFromNetwork;

@end

@implementation XYImageViewer
@synthesize backgroundColor = _backgroundColor;

#pragma mark - 单例设计
static id _instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [XYImageViewer shareInstance] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [XYImageViewer shareInstance] ;
}

#pragma mark - 公开方法
- (__kindof UIView *)show:(UIView *)fromView currentImgIndex:(NSInteger)currentImgIndex {
    
    NSInteger imgCount = 0;
    if (self.isRequestFromNetwork == YES) {
        /// 从服务器请求
        imgCount = self.urlStrList.count;
    } else {
        /// 加载本地图片
        imgCount = self.images.count;
    }
    [self.brower showFromView:fromView picturesCount:imgCount currentPictureIndex:currentImgIndex];
    
    return self.brower;
}


- (XYImageViewer *)prepareImageUrls:(NSArray<NSString *> *)urls endView:(UIView *(^)(NSIndexPath *indexPath))endViewBlock {
    
    _urlStrList = urls;
    _endViewBlock = endViewBlock;
    _requestFromNetwork = YES;
    
    return [XYImageViewer shareInstance];
}


- (XYImageViewer *)prepareImages:(NSArray<NSString *> *)images endView:(UIView *(^)(NSIndexPath *))endViewBlock {
    
    _images = images;
    _endViewBlock = endViewBlock;
    _requestFromNetwork = NO;
    
    NSMutableArray *tempArrM = [NSMutableArray arrayWithCapacity:1];
    for (NSString *imageName in images) {
        UIImage *image = [UIImage imageNamed:imageName];
        [tempArrM addObject:[NSValue valueWithCGSize:image.size]];
    }
    
    self.imageSizes = [tempArrM mutableCopy];
    tempArrM = nil;
    return [XYImageViewer shareInstance];
}


#pragma mark - XYImageBrowerViewDelegate

- (UIView *)imageBrowerView:(XYImageBrowerView *)imageBrowerView viewForIndex:(NSInteger)index {
    
    return self.endViewBlock([NSIndexPath indexPathForRow:index inSection:0]);
}

- (NSArray<NSString *> *)imageBrowerViewWithOriginalImageUrlStrArray:(XYImageBrowerView *)imageBrowerView {
    return self.urlStrList;
}

- (NSArray<NSString *> *)imageBrowerViewWithImageNameArray:(XYImageBrowerView *)imageBrowerView {
    
    return self.images;
}

- (CGSize)imageBrowerView:(XYImageBrowerView *)imageBrowerView imageSizeForIndex:(NSInteger)index {
    CGSize imageSize = [[self.imageSizes objectAtIndex:index] CGSizeValue];
    return imageSize;
}

- (UIImage *)imageBrowerView:(XYImageBrowerView *)imageBrowerView defaultImageForIndex:(NSInteger)index {
    return self.image;
}


#pragma mark - lazy
- (XYImageBrowerView *)brower {
    if (_brower == nil) {
        _brower = [[XYImageBrowerView alloc] init];
        _brower.duration = 0.15;
        _brower.delegate = self;
        [_brower setDismissCallBack:^{
            _brower = nil;
            _fromView = nil;
            _urlStrList = nil;
            _image = nil;
            _endViewBlock = nil;
        }];
    }
    return _brower;
}

- (BOOL)isRequestFromNetwork {
    return _requestFromNetwork ?: NO;
}
@end


