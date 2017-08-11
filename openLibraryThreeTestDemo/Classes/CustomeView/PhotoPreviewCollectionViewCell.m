//
//  PhotoPreviewCollectionViewCell.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "PhotoPreviewCollectionViewCell.h"

@interface PhotoPreviewCollectionViewCell()

@end

@implementation PhotoPreviewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - privateMethod

- (IBAction)playButtonAction:(id)sender {
    
    UIButton *tempButton = (UIButton *)sender;
    tempButton.hidden = YES;
    self.imageView.hidden = YES;
    
    if (self.playButtonBlock) {
        self.playButtonBlock();
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (self.assetModel.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        
        //播放livePhoto
        [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.touchImageBlock) {
        self.touchImageBlock();
    }
}

#pragma mark - getter & setter

- (void)setAssetModel:(AssetModel *)assetModel{
    WEAKSELF
    _assetModel = assetModel;
    
    //处理livePhoto
    if (assetModel.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        _imageView.hidden = YES;
        _playButton.hidden = YES;
        _livePhotoLabel.hidden = NO;
        
        //获取livePhoto
        [[PhotoManager shareInstance] getLivePhoto:assetModel.asset completionHandler:^(PHLivePhoto *livePhoto) {
           [PhotoManager asyncMainQueue:^{
               weakSelf.livePhotoView.livePhoto = livePhoto;
           }];
        }];
        
        return;
    }else{
        _livePhotoLabel.hidden = YES;
    }
    
    
    //处理普通的图片或者视频
    [assetModel getPreviewImageCompletionHandler:^(UIImage *image) {
        _imageView.image = image;
    }];
    
    if (assetModel.type != Video) {
        _playButton.hidden = YES;
    }else{
        _playButton.hidden = NO;
    }
    
    _imageView.hidden = NO;
}

- (PHLivePhotoView *)livePhotoView{
    if (!_livePhotoView) {
        PHLivePhotoView *tempView = [[PHLivePhotoView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:tempView];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        
        _livePhotoView = tempView;
    }
    return _livePhotoView;
}

@end
