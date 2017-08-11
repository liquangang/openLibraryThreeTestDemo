//
//  PhotoPreviewViewController.h
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPreviewViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataSource;   //该vc的数据源

@property (nonatomic, strong) NSIndexPath *indexPath;       //用户点击的item位置，用来判断显示的图片

/**
 *  跳转该页面
 */
+ (void)pushToPreviewVc:(UINavigationController *)nav dataSource:(NSMutableArray *)dataSource indexPath:(NSIndexPath *)indexPath;

@end
