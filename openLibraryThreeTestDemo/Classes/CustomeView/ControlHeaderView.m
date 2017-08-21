//
//  ControlHeaderView.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "ControlHeaderView.h"
#import "PhotoManager.h"
#import "Masonry.h"

@implementation ControlHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.layer.borderWidth = 1;
        
        [self addAndLayoutView];
    }
    return self;
}

#pragma mark - privateMethod

- (void)addAndLayoutView{
    WEAKSELF
    
    [self addSubview:self.photoButton];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4));
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}

#pragma mark - getter

- (UIButton *)photoButton{
    if (!_photoButton) {
        UIButton *tempView = [UIButton new];
        [tempView setTitle:@"相册" forState:UIControlStateNormal];
        [tempView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        tempView.layer.borderWidth = 0.5;
        
        _photoButton = tempView;
    }
    return _photoButton;
}

@end
