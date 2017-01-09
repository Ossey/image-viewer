//
//  XYImageBrowerView.h
//  image-viewer
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XYImageBrowerView;

@protocol XYImageBrowerViewDelegate <NSObject>

@required


/**
 * @explain 获取对应索引的视图
 *
 * @param   imageBrowerView  图片浏览器
 * @param   index          索引
 * @return  图片大小
 * @return  对应索引的视图
 */
- (UIView *)imageBrowerView:(XYImageBrowerView *)imageBrowerView viewForIndex:(NSInteger)index;


/**
 * @explain 获取所有要的高质量图片地址字符串
 *
 * @return  图片的 url 字符串数组
 * 注意: 当执行了获取图片url数组的方法，就不再执行获取单张图片url的方法
 */
- (NSArray<NSString *> *)imageBrowerViewWithOriginalImageUrlStrArray:(XYImageBrowerView *)imageBrowerView;


@optional

/**
 * @explain 获取对应索引的图片大小
 *
 * @param   imageBrowerView  图片浏览器
 * @return  图片大小
 */
- (CGSize)imageBrowerView:(XYImageBrowerView *)imageBrowerView imageSizeForIndex:(NSInteger)index;



/**
 * @explain 获取对应索引默认图片，可以是占位图片，可以是缩略图
 *
 * @param   imageBrowerView  图片浏览器
 * @param   index          索引
 * @return  图片
 */
- (UIImage *)imageBrowerView:(XYImageBrowerView *)imageBrowerView defaultImageForIndex:(NSInteger)index;

/**
 获取所有默认图片，可以是占位图片，可以是缩略图
 
 @return 图片名 字符串数组
 
 注意: 当执行了获取图片数组的方法，就不再执行获取单张图片的方法
 */

/**
 * @explain 获取要显示的默认图片数组，可以是占位图片，可以是缩略图
 *
 * @param   imageBrowerView  图片浏览器
 * @return  图片名称 字符串数组
 */
- (NSArray<NSString *> *)imageBrowerViewWithImageNameArray:(XYImageBrowerView *)imageBrowerView;


/**
 * @explain 获取对应索引的高质量图片地址字符串
 *
 * @param   imageBrowerView  图片浏览器
 * @param   index          索引
 * @return  图片的 url 字符串
 */
- (NSString *)imageBrowerView:(XYImageBrowerView *)imageBrowerView highQualityUrlStringForIndex:(NSInteger)index;

@end
@interface XYImageBrowerView : UIView


@property (nonatomic, weak) id<XYImageBrowerViewDelegate> delegate;

/**
 图片之间的间距，默认： 20
 */
@property (nonatomic, assign) CGFloat betweenImagesSpacing;

/**
 页数文字中心点，默认：居中，中心 y 距离底部 20
 */
@property (nonatomic, assign) CGPoint pageTextCenter;

/**
 页数文字字体，默认：系统字体，16号
 */
@property (nonatomic, strong) UIFont *pageTextFont;

/**
 页数文字颜色，默认：白色
 */
@property (nonatomic, strong) UIColor *pageTextColor;

/**
 长按图片要执行的事件，将长按图片索引回调
 */
@property (nonatomic, copy) void(^longPressBlock)(NSInteger);

/**
 动画执行的时间, 默认为0.25秒
 */
@property (nonatomic, assign) CGFloat duration;

/**
 关闭图片浏览器时，动画消失后的回调
 */
@property (nonatomic, copy) void (^dismissCallBack)();

/**
 * @explain 显示图片浏览器
 *
 * @param   fromView  用户点击的视图，图片这个视图开始做动画，并打开图片浏览器
 * @param   picturesCount  图片的数量
 * @param   currentPictureIndex  当前点击图片的索引值
 */
- (void)showFromView:(UIView *)fromView picturesCount:(NSInteger)picturesCount currentPictureIndex:(NSInteger)currentPictureIndex;

/**
 让图片浏览器消失
 */
- (void)dismiss;




@end
