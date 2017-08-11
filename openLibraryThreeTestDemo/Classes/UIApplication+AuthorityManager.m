//
//  UIApplication+AuthorityManager.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//
#import "UIApplication+AuthorityManager.h"

@implementation UIApplication (AuthorityManager)

/**
 *  获取相册权限
 */
- (void)getPhotoAuthority:(void(^)(PHAuthorizationStatus photoAuthorizationStatus))completed{
    
    void(^tempBlock)(PHAuthorizationStatus photoAuthorizationStatus) = ^(PHAuthorizationStatus photoAuthorizationStatus){
        if (completed) {
            completed(photoAuthorizationStatus);
        }
    };
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    
    if (authStatus == PHAuthorizationStatusAuthorized ||
        authStatus == PHAuthorizationStatusRestricted ||
        authStatus == PHAuthorizationStatusDenied) {
        
        tempBlock(authStatus);
        
    }else if (authStatus == PHAuthorizationStatusNotDetermined){
        
        //用户未做过请求，主动请求一次
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            tempBlock(status);
        }];
    }
}

/**
 *  获取相机权限
 */
- (void)getCameraAuthority:(void(^)(AVAuthorizationStatus authorizationStatus))completed{
    
    /*
     AVAuthorizationStatusNotDetermined = 0,
     AVAuthorizationStatusRestricted,
     AVAuthorizationStatusDenied,
     AVAuthorizationStatusAuthorized
     */
    
    void(^tempBlock)(AVAuthorizationStatus authorizationStatus) = ^(AVAuthorizationStatus authorizationStatus){
        if (completed) {
            completed(authorizationStatus);
        }
    };
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authorizationStatus == AVAuthorizationStatusRestricted ||
        authorizationStatus == AVAuthorizationStatusDenied ||
        authorizationStatus == AVAuthorizationStatusAuthorized) {
        
        tempBlock(authorizationStatus);
        
    }else if (authorizationStatus == AVAuthorizationStatusNotDetermined){
        
        //用户未做过请求，主动请求一次
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                tempBlock(AVAuthorizationStatusAuthorized);
            }else{
                tempBlock(AVAuthorizationStatusDenied);
            }
        }];
        
    }
}

@end
