//
//  AlbumModel.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface AlbumModel : NSObject

@property (nonatomic, strong) PHFetchResult *fetchResult;   //资源对象
@property (nonatomic, strong) NSString *title;              //相册名称
@property (nonatomic, strong, readonly) UIImage *thumbnail;           //相册缩略图(此方法是在主线程中执行，会造成主线程卡顿)

/**
 *  初始化方法
 */
- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult title:(NSString *)title;

/**
 *  block获取缩略图
 */
- (void)getThumbnailCompletionHandler:(void(^)(UIImage *image))completionHandler;

@end
