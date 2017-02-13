//
//  ViewController.m
//  image-viewer
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "ViewController.h"
#import "XYDynamicViewModel.h"
#import "UIImageView+WebCache.h"
#import "XYImageViewer.h"
//#import "XYImageBrowerManager.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource/*, ESPictureBrowserDelegate*/>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) XYDynamicItem *dynamicItem;

@property (nonatomic, strong) NSArray *images;
@end

@implementation ViewController {
    
    XYDynamicInfo *_dynamicInfo;
    NSMutableArray<XYDynamicViewModel *> *_dynamicList;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dynamicList = [NSMutableArray arrayWithCapacity:15];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 5;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - 2 * padding) / 3 ;
    CGFloat h = w;
    layout.itemSize = CGSizeMake(w, h);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[XYCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // 第一种加载网络的
    [self loadData];
    
    // 第二种加载本地的
//    [self loadImage];
}

- (void)loadImage {
    
    _images = @[@"1", @"2", @"3", @"4", @"5"];
    [self.collectionView reloadData];
}

- (void)loadData {
    
    NSDictionary *responseObject = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dynamic.plist" ofType:nil]];
    
    _dynamicInfo = [XYDynamicInfo dynamicInfoWithDict:responseObject];
    
    if ([responseObject[@"code"] integerValue] == 0) {
        
        for (id obj in responseObject[@"datas"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                XYDynamicItem *item = [XYDynamicItem dynamicItemWithDict:obj info:_dynamicInfo];
                XYDynamicViewModel *viewModel = [XYDynamicViewModel dynamicViewModelWithItem:item info:_dynamicInfo];
                [_dynamicList addObject:viewModel];
            }
        }
    }
    
    [self.collectionView reloadData];

}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dynamicItem.imgList.count;
//    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imgItem = self.dynamicItem.imgList[indexPath.row];
    cell.imageName = self.images[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYCollectionViewCell *cell = (XYCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    /************ 加载本地照片，需要设置代理，不需要实现代理方法 ****************/
//    [[XYImageViewer shareInstance] prepareImages:self.images endView:^UIView *(NSIndexPath *indexPath) {
//        return [collectionView cellForItemAtIndexPath:indexPath];
//    }];
//    [[XYImageViewer shareInstance] showFromView:cell picturesCount:self.images.count currentPictureIndex:indexPath.row];
    /************ 加载本地照片，需要设置代理，不需要实现代理方法 ****************/
    
    /************ 第一种创建方式，加载网络照片，需要设置代理，不需要实现代理方法 ****************/
    [[XYImageViewer shareInstance] prepareImageUrls:self.dynamicItem.imageUrls endView:^UIView *(NSIndexPath *indexPath) {
         return [collectionView cellForItemAtIndexPath:indexPath];
    }];
    [[XYImageViewer shareInstance] show:cell currentImgIndex:indexPath.row];
    

    /************ 第一种创建方式，需要设置代理，不需要实现代理方法 ****************/
    
    
    
    /************ 第二种创建方式，需要设置代理，实现下面的代理方法 ****************/
//    XYDynamicImgItem *model = self.dynamicItem.imgList[indexPath.row];
//        ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
//        [browser setDelegate:self];
//        [browser setLongPressBlock:^(NSInteger index) {
//            NSLog(@"%zd", index);
//        }];
//    [browser showFromView:cell picturesCount:self.dynamicItem.imgList.count currentPictureIndex:indexPath.row];
     /************ 第二种创建方式，需要设置代理，实现下面的代理方法 ****************/
}

//#pragma mark - ESPictureBrowserDelegate
//
//
///**
// 获取对应索引的视图
// 
// @param pictureBrowser 图片浏览器
// @param index          索引
// 
// @return 视图
// */
//- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
//    // 获取要结束的view
//    XYCollectionViewCell *cell = (XYCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    
//    return cell;
//}
//
///**
// 获取对应索引的图片大小
// 
// @param pictureBrowser 图片浏览器
// @param index          索引
// 
// @return 图片大小
// */
//- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
//    
//    XYDynamicImgItem *model = self.dynamicItem.imgList[index];
//    
//    return model.imgSize;
//}
//
//
///**
// 获取对应索引的高质量图片地址字符串
// 
// @param pictureBrowser 图片浏览器
// @param index          索引
// 
// @return 图片的 url 字符串
// */
//- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
//    
//    XYDynamicImgItem *model = self.dynamicItem.imgList[index];
//    return model.imgFullURL.absoluteString;
//}
//


- (XYDynamicItem *)dynamicItem {
    if (_dynamicList.count) {
        
        return _dynamicList[4].item;
    }
    return nil;
    
}

@end


@interface XYCollectionViewCell () {
    
    UIImageView *_imageView;
}
@end

@implementation XYCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setImgItem:(XYDynamicImgItem *)imgItem {
    
    _imgItem = imgItem;
    
    [_imageView sd_setImageWithURL:self.imgItem.imgFullURL];
    
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    _imageView.image = [UIImage imageNamed:self.imageName];
}


@end
