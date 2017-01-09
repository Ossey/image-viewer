//
//  ViewController.h
//  image-viewer
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDynamicImgItem;
@interface ViewController : UIViewController


@end

@interface XYCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XYDynamicImgItem *imgItem;
@property (nonatomic, copy) NSString *imageName;
@end
