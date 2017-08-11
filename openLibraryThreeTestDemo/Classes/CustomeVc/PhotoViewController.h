//
//  PhotoViewController.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) AlbumModel *albumModel;       //这个vc对应的相册资源对象

/**
 *  跳转该页面
 */
+ (void)pushToPhotoVc:(UINavigationController *)nav albumModel:(AlbumModel *)albumModel;

@end
