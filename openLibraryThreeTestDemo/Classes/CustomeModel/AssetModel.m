//
//  AssetModel.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "AssetModel.h"
#import "PhotoManager.h"

@implementation AssetModel

@synthesize thumbnail = _thumbnail;
@synthesize previewImage = _previewImage;
@synthesize originalImage = _originalImage;

#pragma mark - init

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        self.asset = asset;
        self.type = (NSInteger)asset.mediaType;
    }
    return self;
}

#pragma mark - publicMethod

/**
 *  block获取缩略图
 */
- (void)getThumbnailCompletionHandler:(void(^)(UIImage *image))completionHandler{
    
    void(^tempBlock)(UIImage *tempImage) = ^(UIImage *tempImage){
        if (completionHandler) {
            completionHandler(_thumbnail);
        }
    };
    
    if (_asset) {
        [[PhotoManager shareInstance] getThumbnail:_asset completed:^(UIImage *image) {
            tempBlock(_thumbnail = image);
        }];
    }else{
        tempBlock(_thumbnail = [UIImage imageNamed:@"blank"]);
    }
}

/**
 *  block获取预览图
 */
- (void)getPreviewImageCompletionHandler:(void(^)(UIImage *image))completionHandler{
    
    void(^tempBlock)(UIImage *tempImage) = ^(UIImage *tempImage){
        if (completionHandler) {
            completionHandler(_previewImage);
        }
    };
    
    if (_asset) {
        [[PhotoManager shareInstance] getPreviewImage:_asset completed:^(UIImage *image) {
            tempBlock(_previewImage = image);
        }];
    }else{
        tempBlock(_previewImage = [UIImage imageNamed:@"blank"]);
    }
}

/**
 *  block获取原图
 */
- (void)getOriginalImageCompletionHandler:(void(^)(UIImage *image))completionHandler{
    
    void(^tempBlock)(UIImage *tempImage) = ^(UIImage *tempImage){
        if (completionHandler) {
            completionHandler(_originalImage);
        }
    };
    
    if (_asset) {
        [[PhotoManager shareInstance] getOriginalImage:_asset completed:^(UIImage *image) {
            tempBlock(_originalImage = image);
        }];
    }else{
        tempBlock(_originalImage = [UIImage imageNamed:@"blank"]);
    }
}

#pragma mark - getter&setter

- (UIImage *)thumbnail{
    if (!_thumbnail) {
        __block UIImage *tempImage;
        
        if (_asset) {
            [[PhotoManager shareInstance] getThumbnail:_asset completed:^(UIImage *image) {
                tempImage = image;
            }];
        }else{
            tempImage = [UIImage imageNamed:@"blank"];
        }
        
        _thumbnail = tempImage;
    }
    return _thumbnail;
}

- (UIImage *)previewImage{
    if (!_previewImage) {
        __block UIImage *tempImage;
        
        if (_asset) {
            [[PhotoManager shareInstance] getPreviewImage:_asset completed:^(UIImage *image) {
                tempImage = image;
            }];
        }else{
            tempImage = [UIImage imageNamed:@"blank"];
        }
        
        _previewImage = tempImage;
    }
    return _previewImage;
}

- (UIImage *)originalImage{
    if (!_originalImage) {
        __block UIImage *tempImage;
        
        if (_asset) {
            [[PhotoManager shareInstance] getOriginalImage:_asset completed:^(UIImage *image) {
                tempImage = image;
            }];
        }else{
            tempImage = [UIImage imageNamed:@"blank"];
        }
        
        _originalImage = tempImage;
    }
    return _originalImage;
}

@end
