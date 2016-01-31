//
//  PhotosImagesManager.h
//  PhotoLibrary
//
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface albumModel : NSObject
@property (nonatomic, strong) NSString *name;        /// 相册名字
@property (nonatomic, assign) NSInteger count;       /// 相册内照片的数量
@property (nonatomic, strong) PHFetchResult *result;       /// PHFetchResult<PHAsset> 用于获得具体的照片数据.
@end

@interface PhotosImagesManager : NSObject

+ (instancetype)manager;
// 判断是否又有权限调用相册
- (BOOL)autorizationPhtosStatus;
// 获取所有的相册个数
- (NSArray *)getAllAlbumCompletion;

// 获得相册中的PHAsset对象, 并存放到数组里
- (NSArray *)getAssetsFromFetchResult:(id)result;
// 获取到具体的照片
- (UIImage *)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth;
// 获得某个相册最后一张图片
- (UIImage *)getPostImageWithAlbumModel:(albumModel *)model;
@end
