//
//  CollectionViewCell.m
//  PhotoLibrary
//
//  Created by zqwl001 on 16/1/31.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.i];
    }
    return self;
}

- (UIImageView *)i {
    if (_i == nil) {
        _i = [[UIImageView alloc] init];
        _i.contentMode = UIViewContentModeScaleAspectFill;
        _i.clipsToBounds = YES;
        _i.backgroundColor = [UIColor yellowColor];
    }
    return _i;
}
- (void)setModel:(PHAsset *)model {
    if (_model != model) {
        _model = model;
    }
    self.i.image =  [[PhotosImagesManager manager] getPhotoWithAsset:_model  photoWidth:self.frame.size.width];
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    CGFloat cWidth = self.frame.size.width;
    CGFloat cHight = self.frame.size.height;
    
    _i.frame = CGRectMake(0, 0, cWidth, cHight);
    _i.frame = CGRectMake(0, 0, cWidth, cHight);
    
}



@end
