//
//  PhotosViewController.h
//  PhotoLibrary
//
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosImagesManager.h"
//#import <Photos/Photos.h>
@interface PhotosViewController : UIViewController
- (instancetype)initWithPHFetchResult:(PHFetchResult *)result;
@end
