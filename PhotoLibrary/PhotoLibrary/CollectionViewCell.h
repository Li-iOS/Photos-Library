//
//  CollectionViewCell.h
//  PhotoLibrary
//
//  Created by zqwl001 on 16/1/31.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosImagesManager.h"
@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *i;
@property (nonatomic, strong) PHAsset *model;
@end
