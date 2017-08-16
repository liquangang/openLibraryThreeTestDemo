//
//  PhotoCollectionViewCell.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

typedef void(^SelectBlock)(BOOL isSelect);

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;
@property (weak, nonatomic) IBOutlet UILabel *livePhotoLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectStatusButton;

@property (nonatomic, copy) SelectBlock selectBlock;

@property (nonatomic, strong) AssetModel *assetModel;
@end
