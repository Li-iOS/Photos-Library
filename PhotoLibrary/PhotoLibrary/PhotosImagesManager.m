//
//  PhotosImagesManager.m
//  PhotoLibrary
//
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "PhotosImagesManager.h"

@implementation albumModel
@end



@implementation PhotosImagesManager
+ (instancetype)manager {
    static PhotosImagesManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken , ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (BOOL)autorizationPhtosStatus {
    if ([PHPhotoLibrary authorizationStatus]==PHAuthorizationStatusAuthorized ) {
        return YES;
    } else {
        return NO;
    }
}

// 获取所有的相册个数
- (NSArray *)getAllAlbumCompletion {
    NSMutableArray *albumArr = [NSMutableArray array];
    
    // 获取
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType = %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

    PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
    // 如果是9.0 则获取的相册是不同的
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
    }
    
    // 获取相册的信息
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];

    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle containsString:@"Deleted"]) continue;
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
            [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }

    }
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    for (PHAssetCollection *collection in albums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
            [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
        } else {
            [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    return albumArr;
}


// 获得相册中的PHAsset对象, 并存放到数组里
- (NSArray *)getAssetsFromFetchResult:(PHFetchResult *)result  {
    NSMutableArray *photoArr = [NSMutableArray array];
        for (PHAsset *asset in result) {
            NSLog(@" tupe %d", asset.mediaType);
            if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaType == PHAssetMediaTypeAudio) {
                continue;
            }
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [photoArr addObject:asset];
            }
        }
    return photoArr;
}
//- (void)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion {
- (UIImage *)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth{
    __block UIImage *image;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        //
        //        // 采取同步获取图片（只获得一次图片）
        //        PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
        //
        //        // synchronous 标示同步还是异步
        //        imageOptions.synchronous = NO;
        //
        //
        //        //    imageOptions.deliveryMode
        //        imageOptions.networkAccessAllowed = NO; // 标示不进行网络请求
        //
        //        // 表示是 resizeMode 属性可以设置为 .Exact (返回图像必须和目标大小相匹配)，.Fast (比 .Exact 效率更高，但返回图像可能和目标大小不一样) 或者 .None。
        //        imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        //
        //
        //        // 返回的策略,  当为PHImageRequestOptionsDeliveryModeHighQualityFormat   只返回高质量的图, 若是
        //        //               PHImageRequestOptionsDeliveryModeOpportunistic       系统会先返回安targetsize的大小返回的缩略图, 然后继续执行, 再返回一组一所需要的尺寸
        //        //               PHImageRequestOptionsDeliveryModeFastFormat          如果你想要更快的加载速度，且可以牺牲一点图像质量，那么将属性设置为 .FastFormat。
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined) {
                image = result;
            }
        }];
    }
    return image;
}

// 获取相册的最后一张图片
- (UIImage *)getPostImageWithAlbumModel:(albumModel *)model  {
    return [[PhotosImagesManager manager] getPhotoWithAsset:[model.result lastObject] photoWidth:80];
}

/**
 *   转换成PHResult的model对象
 */
- (albumModel *)modelWithResult:(id)result name:(NSString *)name{
    albumModel *model = [[albumModel alloc] init];
    model.result = result;
    model.name = [self getNewAlbumName:name];
    PHFetchResult *fetchResult = (PHFetchResult *)result;
    model.count = fetchResult.count;
    return model;
}
- (NSString *)getNewAlbumName:(NSString *)name {
        NSString *newName;
        if ([name containsString:@"Roll"])         newName = @"相机胶卷";
        else if ([name containsString:@"Stream"])  newName = @"我的照片流";
        else if ([name containsString:@"Added"])   newName = @"最近添加";
        else if ([name containsString:@"Selfies"]) newName = @"自拍";
        else if ([name containsString:@"shots"])   newName = @"截屏";
        else if ([name containsString:@"Videos"])  newName = @"视频";
        else newName = name;
        return newName;
}




@end
