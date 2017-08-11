//
//  PhotoManager.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#define WEAKSELF __weak __typeof(&*self)weakSelf = self;        //弱引用宏

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width    //屏幕宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height  //屏幕高度

#define THUMBNAILWIdth (SCREEN_WIDTH / 4)                       //缩略图默认宽度（由于是正方形，也是默认高度）

#define SCREENSCALE [UIScreen mainScreen].scale                 //屏幕缩放比例

#define ColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alphaValue)];      //颜色设置

/**
 *  创建单例
 */
#define CREATESINGLETON(singletonClassName) \
static singletonClassName *instance;\
+ (instancetype)shareInstance{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [[singletonClassName alloc] init] ;\
}) ;\
return instance;\
}\
+ (id)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [super allocWithZone:zone] ;\
}) ;\
return instance;\
}\
- (id)copyWithZone:(NSZone *)zone{\
return instance;\
}

//获取选中数组的通知
static NSString *const selectAssetNotiName = @"selectAssetNotiName";

@interface PhotoManager : NSObject

/**
 *  获取该类的对象的单例
 */
+ (instancetype)shareInstance;

/**
 *  获取相册资源数组
 */
- (NSArray *)getAlbums;

/**
 *  获取每个资源对应的缩略图（用于item上显示）
 */
- (void)getThumbnail:(PHAsset *)asset completed:(void(^)(UIImage *image))completed;

/**
 *  获取预览图（用于全屏显示的预览图）
 */
- (void)getPreviewImage:(PHAsset *)asset completed:(void(^)(UIImage *image))completed;

/**
 *  获取原图
 */
- (void)getOriginalImage:(PHAsset *)asset completed:(void(^)(UIImage *image))completed;

/**
 *  获取playItem
 */
- (void)getPlayItem:(PHAsset *)asset completionHandler:(void(^)(AVPlayerItem *playerItem))completionHandler;

/**
 *  获取livePhoto
 */
- (void)getLivePhoto:(PHAsset *)asset completionHandler:(void(^)(PHLivePhoto *livePhoto))completionHandler;

/**
 *  主线程
 */
+ (void)asyncMainQueue:(void(^)())mainQueueBlock;

/**
 *  后台异步多线程
 */
+ (void)asyncBackgroundQueue:(void(^)())backgroundQueueBlock;

@end
