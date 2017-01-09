//
//  XYDynamicViewModel.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDynamicInfo.h"
#import "XYDynamicItem.h"


@interface XYDynamicViewModel : NSObject

@property (nonatomic, strong) XYDynamicInfo *info;
@property (nonatomic, strong) XYDynamicItem *item;

@property (nonatomic, assign) CGRect cellBounds;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect title_labelFrame;
@property (nonatomic, assign) CGRect contentLableFrame;
@property (nonatomic, assign) CGRect picCollectionViewFrame;
@property (nonatomic, assign) CGRect readCountBtnFrame;
@property (nonatomic, assign) CGRect toolViewFrame;
@property (nonatomic, assign) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect headerViewFrame;

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat picItemWH;


+ (instancetype)dynamicViewModelWithItem:(XYDynamicItem *)item info:(XYDynamicInfo *)info;
@end
