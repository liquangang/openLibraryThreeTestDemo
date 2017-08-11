//
//  UIViewController+AuthorityManager.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AuthorityManager)

/**
 *  获取相册权限
 */
- (void)getPhotoAuthority:(void(^)(BOOL isCanUse))completed;

@end
