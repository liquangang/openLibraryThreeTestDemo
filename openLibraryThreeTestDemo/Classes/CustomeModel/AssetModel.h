//
//  AssetModel.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, MediaType) {
    Unknown = 0,
    Image   = 1,
    Video   = 2,
    Audio   = 3,
};

@interface AssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;           //对应的资源对象

@property (nonatomic, strong) UIImage *thumbnail;       //对应的缩略图

@property (nonatomic, strong) UIImage *previewImage;    //预览图

@property (nonatomic, strong) UIImage *originalImage;    //原图

@property (nonatomic, assign) MediaType type;           //资源类型

@property (nonatomic, assign) BOOL isSelect;            //是否被选中

/**
 *  初始化方法
 */
- (instancetype)initWithAsset:(PHAsset *)asset;

/**
 *  block获取缩略图
 */
- (void)getThumbnailCompletionHandler:(void(^)(UIImage *image))completionHandler;

/**
 *  block获取预览图
 */
- (void)getPreviewImageCompletionHandler:(void(^)(UIImage *image))completionHandler;

/**
 *  block获取原图
 */
- (void)getOriginalImageCompletionHandler:(void(^)(UIImage *image))completionHandler;

@end
