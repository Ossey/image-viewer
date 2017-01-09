//
//  XYDynamicViewModel.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicViewModel.h"

@implementation XYDynamicViewModel

- (instancetype)initWithItem:(XYDynamicItem *)item info:(XYDynamicInfo *)info {
    if (self = [super init]) {
        self.item = item;
        self.info = info;
    }
    
    return self;
}

+ (instancetype)dynamicViewModelWithItem:(XYDynamicItem *)item info:(XYDynamicInfo *)info {
    
    return [[self alloc] initWithItem:item info:info];
}


- (NSURL *)headerImageURL {
    NSString *fullPath = nil;
    if ([self.item.head containsString:@"http://"]) {
        fullPath = self.item.head;
    } else {
        fullPath = [self.info.basePath stringByAppendingString:self.item.head];
    }
    return [NSURL URLWithString:fullPath];
}

- (CGRect)cellBounds {
    
    return CGRectMake(0, 0, kScreenW, self.cellHeight);
}

- (CGFloat)cellHeight {
    
    if (_cellHeight != 0) {
        // 当已计算好时，就不再计算
        return _cellHeight;
    }
    
    CGFloat x = SIZE_GAP_MARGIN;
    CGFloat y = 0.0;
    
    // 头部
    CGFloat headerHeight = SIZE_GAP_MARGIN + SIZE_HEADERWH;

    
    self.nameLabelFrame = CGRectMake(x, SIZE_GAP_MARGIN, SIZE_HEADERWH, SIZE_HEADERWH);
    
    y = headerHeight + SIZE_GAP_SMALL;
    x += SIZE_HEADERWH + SIZE_GAP_PADDING;
    
    // 图片
    if (self.item.imgCount == 0) {
        self.picCollectionViewFrame = CGRectZero;
        y += 0;
    } else {
        CGSize picSize = [self caculatePicViewSize:self.item.imgCount];
        self.picCollectionViewFrame = CGRectMake(x, y, picSize.width, picSize.height);
        y += picSize.height + SIZE_PIC_BOTTOM;

    }
    
    
    // 标题
    CGSize titleSize = CGSizeZero;
    if (self.item.title.length == 0) {
        self.title_labelFrame = CGRectZero;
        y += titleSize.height;
    } else {
        titleSize = [self.item.title boundingRectWithSize:CGSizeMake(self.contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFontWithSize(SIZE_FONT_TITLE)} context:nil].size;
        self.title_labelFrame = CGRectMake(x, y, titleSize.width, titleSize.height);
        y += titleSize.height + SIZE_GAP_PADDING;
    }
    
   
    // 内容
    CGSize contentSize = CGSizeZero;
    if (self.item.content.length == 0) {
        self.contentLableFrame = CGRectZero;
        y += contentSize.height;
    } else {
        contentSize = [self.item.content boundingRectWithSize:CGSizeMake(self.contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFontWithSize(SIZE_FONT_CONTENT)} context:nil].size;
        self.contentLableFrame = CGRectMake(x, y, contentSize.width, contentSize.height);
        y += contentSize.height + SIZE_PIC_BOTTOM;
    }
    
    // 浏览人数
    CGFloat readCountW = 80;
    CGFloat readCountH = 10;
    CGFloat readCountX = self.contentWidth - SIZE_GAP_MARGIN - 0;
    self.readCountBtnFrame = CGRectMake(readCountX, y, readCountW, readCountH);
    y += readCountH + SIZE_PIC_BOTTOM;
    
    // 工具条
    self.toolViewFrame = CGRectMake(x, y, self.contentWidth, SIZE_TOOLVIEWH);
    y += SIZE_TOOLVIEWH + SIZE_SEPARATORH;
    
    return y;
}



// 计算collectionView的尺寸
- (CGSize)caculatePicViewSize:(NSInteger)count {
    
    
    if (count == 0) {
        return CGSizeZero;
    }
    
    
    if (count == 1) {
        
        return CGSizeMake(self.picItemWH, self.picItemWH);
    }
    
    // 其他
    // 计算行数
    NSInteger rows = (count - 1) / 3 + 1;
    
    if (count == 4) {
        return CGSizeMake(self.picItemWH * 2 + SIZE_PICMARGIN, self.picItemWH * 2 + SIZE_PICMARGIN);
    }
    
    
    CGFloat picViewW = self.contentWidth;
    CGFloat picViewH = rows * self.picItemWH + (rows - 1) * SIZE_PICMARGIN;
    
    
    return CGSizeMake(picViewW, picViewH);
}

- (CGFloat)contentWidth {
    
    return kScreenW - SIZE_GAP_MARGIN * 2 - SIZE_HEADERWH - SIZE_GAP_PADDING;
}

- (CGFloat)picItemWH {
    
    if (self.item.imgCount == 0) {
        return 0;
    } else if (self.item.imgCount == 1) {
        return 150;
    }
    
    return (self.contentWidth - 2 * SIZE_PICMARGIN) / 3;
}



@end
