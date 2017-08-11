//
//  LQGViewController.m
//  openLibraryThreeTestDemo
//
//  Created by liquangang on 08/11/2017.
//  Copyright (c) 2017 liquangang. All rights reserved.
//

#import "LQGViewController.h"
#import <openLibraryThreeTestDemo/LQGPhotoKitViewController.h>

@interface LQGViewController ()

@end

@implementation LQGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    LQGPhotoKitViewController *tempVc = [[LQGPhotoKitViewController alloc] init];
    [self addChildViewController:tempVc];
    [self.view addSubview:tempVc.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
