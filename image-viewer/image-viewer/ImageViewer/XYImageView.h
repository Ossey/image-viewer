//
//  XYImageView.h
//  image-viewer
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYImageView;
@protocol XYImageViewDelegate <NSObject>

- (void)imageViewTouch:(XYImageView *)imageView;

- (void)imageView:(XYImageView *)imageView scale:(CGFloat)scale;

@end

@interface XYImageView : UIScrollView

/// 当前视图所在的索引
@property (nonatomic, assign) NSInteger index;
/// 图片的大小
@property (nonatomic, assign) CGSize pictureSize;
/// 显示的默认图片
@property (nonatomic, strong) UIImage *placeholderImage;
/// 图片的地址 URL
@property (nonatomic, strong) NSString *urlString;
/// 当前显示图片的控件
@property (nonatomic, strong, readonly) UIImageView *imageView;
/// 代理
@property (nonatomic, weak) id<XYImageViewDelegate> imageViewDelegate;


/**
 * @explain 动画显示
 *
 * @param   rect            从哪个位置开始做动画
 * @param   animationBlock  附带的动画信息
 * @param   completionBlock 结束的回调
 */
- (void)animationShowWithFromRect:(CGRect)rect duration:(CGFloat)duration  animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;


/**
 * @explain 动画消失
 *
 * @param   rect            回到哪个位置
 * @param   animationBlock  附带的动画信息
 * @param   completionBlock 结束的回调
 */
- (void)animationDismissWithToRect:(CGRect)rect duration:(CGFloat)duration  animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;


@end

@interface XYImageProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)showError;

@end
