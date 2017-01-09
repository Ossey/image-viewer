//
//  XYDynamicItem.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDynamicInfo;
@interface XYDynamicItem : NSObject

@property (nonatomic, copy) NSString *content;        // 文本内容
@property (nonatomic, copy) NSString *title;          // 标题
@property (nonatomic, copy) NSString *createTime;     // 创建日期
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, assign) NSInteger imgCount;     // 发布的图片数量
@property (nonatomic, strong) NSArray *imgList;       // 发布的图片数组
@property (nonatomic, assign) NSInteger isInvest;     // 是否被当前登录的用户投资
@property (nonatomic, assign) NSInteger isPraise;     // 是否被当前登录用户赞
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *location;       // 用户位置
@property (nonatomic, copy) NSString *name;           // 用户昵称
@property (nonatomic, assign) NSInteger praiseCount;  // 点赞数量
@property (nonatomic, copy) NSString *radioContent;
@property (nonatomic, assign) NSInteger radioTime;
@property (nonatomic, assign) NSInteger commentCount; // 评论次数
@property (nonatomic, assign) NSInteger readCount;    // 被读的数
@property (nonatomic, assign) NSInteger rewardCount;  // 赏的数据
@property (nonatomic, assign) NSInteger shareCount;   // 分享的数量
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger topicId;      // 话题ID
@property (nonatomic, copy) NSString *topicName;      // 话题名称
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *videoImg;
@property (nonatomic, copy) NSString *videoUrl;

// 扩展属性
@property (nonatomic, strong) NSURL *headerImageURL;
@property (nonatomic, strong) XYDynamicInfo *info;
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;

- (instancetype)initWithDict:(NSDictionary *)dict info:(XYDynamicInfo *)info;
+ (instancetype)dynamicItemWithDict:(NSDictionary *)dict info:(XYDynamicInfo *)info;

@end

@interface XYDynamicImgItem : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger tiid;
@property (nonatomic, assign) NSInteger uid;

// 扩展属性
@property (nonatomic, strong)XYDynamicInfo *info;
@property (nonatomic, strong) NSURL *imgFullURL;
@property (nonatomic, assign) CGSize imgSize;            // 图片的原始尺寸

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)dynamicImgItemWithDict:(NSDictionary *)dict;

@end
