//
//  AlbumTableCell.m
//  PhotoLibrary
//
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "AlbumTableCell.h"
@implementation AlbumTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(albumModel *)model {
    if (_model != model) {
        _model = model;
    }

   self.image.image =[[PhotosImagesManager manager] getPostImageWithAlbumModel:_model];
    self.name.text = model.name;
}
@end
