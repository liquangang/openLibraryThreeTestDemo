//
//  UIApplication+AuthorityManager.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface UIApplication (AuthorityManager)

/**
 *  获取相册权限状态（如果没有申请过权限，就主动申请之后再返回当前的权限状态）
 */
- (void)getPhotoAuthority:(void(^)(PHAuthorizationStatus photoAuthorizationStatus))completed;

/**
 *  获取相机权限
 */
- (void)getCameraAuthority:(void(^)(AVAuthorizationStatus authorizationStatus))completed;

@end
