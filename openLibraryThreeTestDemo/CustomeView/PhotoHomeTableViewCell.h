//
//  PhotoHomeTableViewCell.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

@interface PhotoHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) AlbumModel *albumModel;
@end
