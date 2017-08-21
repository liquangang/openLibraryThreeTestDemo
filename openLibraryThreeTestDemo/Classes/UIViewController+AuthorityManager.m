//
//  UIViewController+AuthorityManager.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "UIViewController+AuthorityManager.h"
#import "UIApplication+AuthorityManager.h"
#import "PhotoManager.h"

#define PHOTOALERT @"无法访问相册，请在【设置】-【隐私】-【相册】中打开权限"
#define CAMERAALERT @"无法访问相机，请在【设置】-【隐私】-【相机】中打开权限"

@implementation UIViewController (AuthorityManager)

/**
 *  获取相册权限
 */
- (void)getPhotoAuthority:(void(^)(BOOL isCanUse))completed{
    
    WEAKSELF
    
    void(^tempBlock)(BOOL isCanUse) = ^(BOOL isCanUse){
        if (completed) {
            completed(isCanUse);
        }
    };
    
    [[UIApplication sharedApplication] getPhotoAuthority:^(PHAuthorizationStatus photoAuthorizationStatus) {
        
        if (photoAuthorizationStatus == PHAuthorizationStatusRestricted ||
            photoAuthorizationStatus == PHAuthorizationStatusDenied ||
            photoAuthorizationStatus == PHAuthorizationStatusNotDetermined) {
            
            [weakSelf showAuthorityAlert:PHOTOALERT];
            
            tempBlock(NO);
            
        }else if (photoAuthorizationStatus == PHAuthorizationStatusAuthorized){
            tempBlock(YES);
        }
        
    }];
}

/**
 *  获取相机权限
 */
- (void)getCameraAuthority:(void(^)(BOOL isCanUse))completed{
    
    WEAKSELF
    
    void(^tempBlock)(BOOL isCanUse) = ^(BOOL isCanUse){
        if (completed) {
            completed(isCanUse);
        }
    };
    
    [[UIApplication sharedApplication] getCameraAuthority:^(AVAuthorizationStatus authorizationStatus) {
        
        if (authorizationStatus == AVAuthorizationStatusRestricted ||
            authorizationStatus == AVAuthorizationStatusDenied ||
            authorizationStatus == AVAuthorizationStatusNotDetermined) {
            
            [weakSelf showAuthorityAlert:CAMERAALERT];
            
            tempBlock(NO);
            
        }else if (authorizationStatus == AVAuthorizationStatusAuthorized){
            tempBlock(YES);
        }
        
    }];
}

/**
 *  显示提示
 */
- (void)showAuthorityAlert:(NSString *)alertString{
    UIAlertController *tempAC = [UIAlertController alertControllerWithTitle:@"" message:alertString preferredStyle:UIAlertControllerStyleAlert];
    
    [tempAC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:tempAC animated:YES completion:nil];
}

@end
