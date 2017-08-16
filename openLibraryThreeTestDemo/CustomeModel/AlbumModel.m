//
//  AlbumModel.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "AlbumModel.h"
#import "PhotoManager.h"

@implementation AlbumModel

@synthesize thumbnail = _thumbnail;

- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.fetchResult = fetchResult;
        self.title = title;
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
   
    if (_fetchResult.count > 0) {
        PHAsset *tempAsset = _fetchResult[_fetchResult.count - 1];
    
        [[PhotoManager shareInstance] getThumbnail:tempAsset completed:^(UIImage *image) {
            tempBlock(_thumbnail = image);
        }];
    }else{
        tempBlock(_thumbnail = [UIImage imageNamed:LQG_RESOURCE_NAME(@"blank")]);
    }
}

#pragma mark - getter&setter

- (UIImage *)thumbnail{
    if (!_thumbnail) {
        __block UIImage *tempImage;
        
        if (_fetchResult.count > 0) {
            PHAsset *tempAsset = [_fetchResult lastObject];
            [[PhotoManager shareInstance] getThumbnail:tempAsset completed:^(UIImage *image) {
                tempImage = image;
            }];
        }else{
            tempImage = [UIImage imageNamed:LQG_RESOURCE_NAME(@"blank")];
        }
        
        _thumbnail = tempImage;
    }
    return _thumbnail;
}

@end
