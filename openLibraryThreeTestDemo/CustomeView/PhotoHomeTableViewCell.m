//
//  PhotoHomeTableViewCell.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "PhotoHomeTableViewCell.h"

@implementation PhotoHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter&setter

- (void)setAlbumModel:(AlbumModel *)albumModel{
    _albumModel = albumModel;
    
    NSString *tempString = [NSString stringWithFormat:@"%@(%ld)", albumModel.title, albumModel.fetchResult.count];
    _nameLabel.text = tempString;
    
    [albumModel getThumbnailCompletionHandler:^(UIImage *image) {
        _image.image = image;
    }];
}

@end
