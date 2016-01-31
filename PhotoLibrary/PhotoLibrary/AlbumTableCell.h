//
//  AlbumTableCell.h
//  PhotoLibrary
//
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosImagesManager.h"
@interface AlbumTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, strong) albumModel *model;

@end
