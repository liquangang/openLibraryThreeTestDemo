//
//  PhotoPreviewCollectionViewCell.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"
#import "PhotoManager.h"
#import <AVKit/AVKit.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface PhotoPreviewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;        //预览图
@property (nonatomic, strong) AssetModel *assetModel;               //model
@property (weak, nonatomic) IBOutlet UIButton *playButton;          //播放按钮
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;       //livePhotoView
@property (weak, nonatomic) IBOutlet UILabel *livePhotoLabel;

@property (nonatomic, copy) void(^playButtonBlock)();               //点击播放按钮
@property (nonatomic, copy) void(^touchImageBlock)();               //单击手势block

@end
