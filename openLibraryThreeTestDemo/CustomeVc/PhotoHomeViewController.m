//
//  PhotoHomeViewController.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/15.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "PhotoHomeViewController.h"
#import "PhotoManager.h"
#import "AlbumModel.h"
#import "PhotoHomeTableViewCell.h"
#import "UIViewController+AuthorityManager.h"
#import "PhotoViewController.h"
#import "Masonry.h"

static NSString *cellResuableID = @"PhotoHomeTableViewCell";
static CGFloat cellHeight = 66;

@interface PhotoHomeViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArray;
@property (nonatomic, strong) NSMutableArray *selectAssetMuArray;

@end

@implementation PhotoHomeViewController

- (void)dealloc{
    NSLog(@"%@ dealloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceMuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellResuableID];
    cell.albumModel = self.dataSourceMuArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [PhotoViewController pushToPhotoVc:self.navigationController albumModel:self.dataSourceMuArray[indexPath.row]];
}

#pragma mark - publicMethod

+ (void)presentSelectPhoto:(UIViewController *)viewController{
    [viewController getPhotoAuthority:^(BOOL isCanUse) {
        
        if (isCanUse) {
            [PhotoManager asyncMainQueue:^{
                PhotoHomeViewController *tempVc = [PhotoHomeViewController new];
                UINavigationController *tempNav = [[UINavigationController alloc] initWithRootViewController:tempVc];
                
                //跳转到相机胶卷
                for (AlbumModel *albumModel in tempVc.dataSourceMuArray) {
                    if ([albumModel.title isEqualToString:@"相机胶卷"]) {
                        [PhotoViewController pushToPhotoVc:tempNav albumModel:albumModel];
                        break;
                    }
                }
                
                [viewController presentViewController:tempNav animated:YES completion:nil];
            }];
        }
    }];
}

#pragma mark - privateMethod

- (void)rightBarButtonClicked:(UIBarButtonItem *)barButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tempView = [[UITableView alloc] init];
        
        tempView.delegate = self;
        tempView.dataSource = self;
        tempView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tempView.backgroundColor = [UIColor clearColor];
        [[MAIN_BUNDLE loadNibNamed:cellResuableID owner:self options:nil] lastObject];
        [tempView registerNib:[UINib nibWithNibName:cellResuableID bundle:MAIN_BUNDLE] forCellReuseIdentifier:cellResuableID];
        
        _tableView = tempView;
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceMuArray{
    if (!_dataSourceMuArray) {
        NSArray *tempArray = [[PhotoManager shareInstance] getAlbums];
        NSMutableArray *tempMuArray = [[NSMutableArray alloc] initWithArray:tempArray];
        
        _dataSourceMuArray = tempMuArray;
    }
    return _dataSourceMuArray;
}

@end
