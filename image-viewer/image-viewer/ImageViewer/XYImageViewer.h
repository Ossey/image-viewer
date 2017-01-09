//
//  XYImageViewer.h
//  image-viewer
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYImageViewer : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;

+ (instancetype)shareInstance;

/**
 * @explain 准备需要展示的图片的各种数据
 *
 * @param   URLStrList  图片的url 字符串数组
 * @param   endViewBlock  当点击图片时动画结束到的视图---block:回调给外界索引值，外界根据索引值找到要结束的视图
 */
- (void)prepareImageURLStrList:(NSArray<NSString *> *)URLStrList endView:(UIView *(^)(NSIndexPath *indexPath))endViewBlock;


/**
 * @explain 准备需要展示的图片的各种数据
 *
 * @param   images  需要展示的图片数组
 * @param   endViewBlock  当点击图片时动画结束到的视图---block:回调给外界索引值，外界根据索引值找到要结束的视图
 */
- (void)prepareImages:(NSArray<NSString*> *)images endView:(UIView *(^)(NSIndexPath *indexPath))endViewBlock;

/**
 * @explain 显示图片浏览器
 *
 * @param   fromView  用户点击的视图，图片这个视图开始做动画，并打开图片浏览器
 * @param   currentImgIndex  当前点击图片的索引值
 */
- (__kindof UIView *)show:(UIView *)fromView currentImgIndex:(NSInteger)currentImgIndex;

@end


