//
//  PhotoCollectionViewCell.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoManager.h"

@interface PhotoCollectionViewCell()


@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectStatusButton.layer.masksToBounds = YES;
    self.selectStatusButton.layer.cornerRadius = 18;
    self.selectStatusButton.backgroundColor = ColorFromRGBA(0x000000, 0.6);
}

#pragma mark - privateMethod

- (void)showSelectStatus{
    if (self.assetModel.isSelect) {
        [self.selectStatusButton setTitle:@"选中" forState:UIControlStateNormal];
    }else{
        [self.selectStatusButton setTitle:@"" forState:UIControlStateNormal];
    }
}
- (IBAction)selectStatusButtonAction:(id)sender {
    self.assetModel.isSelect = !self.assetModel.isSelect;
    [self showSelectStatus];
    if (self.selectBlock) {
        self.selectBlock(self.assetModel.isSelect);
    }
}

#pragma mark - getter & setter

- (void)setAssetModel:(AssetModel *)assetModel{
    _assetModel = assetModel;
    
    [assetModel getThumbnailCompletionHandler:^(UIImage *image) {
        _imageView.image = image;
    }];
    
    if (assetModel.type != Video) {
        _playImage.hidden = YES;
    }else{
        _playImage.hidden = NO;
    }
    
    if (assetModel.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        _livePhotoLabel.hidden = NO;
    }else{
        _livePhotoLabel.hidden = YES;
    }
    
    [self showSelectStatus];
}

@end
