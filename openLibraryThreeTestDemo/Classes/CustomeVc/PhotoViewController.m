//
//  PhotoViewController.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "PhotoViewController.h"
#import "LQGWaterLayout.h"
#import "AssetModel.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoPreviewViewController.h"
#import "PhotoManager.h"

static NSString *photoItemResuableStr = @"PhotoCollectionViewCell";
static NSString *photoHeaderAndFooterResuableStr = @"headerAndFooter";

@interface PhotoViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LQGWaterFlowLayout *waterLayout;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArray;            //数据源
@property (nonatomic, strong) NSMutableArray *selectMuArray;                //选中的asset

@property (nonatomic, strong) UIButton *selectButton;           //底部的选中按钮

@end

@implementation PhotoViewController

- (void)dealloc{
    NSLog(@"%@ dealloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.albumModel.title;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.selectButton];
    
    for (int i = 0; i < self.albumModel.fetchResult.count; i++) {
        AssetModel *tempModel = [[AssetModel alloc] initWithAsset:self.albumModel.fetchResult[i]];
        [self.dataSourceMuArray addObject:tempModel];
    }
    
    if (self.dataSourceMuArray.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceMuArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceMuArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoItemResuableStr forIndexPath:indexPath];
    AssetModel *assetModel = self.dataSourceMuArray[indexPath.row];
    cell.assetModel = assetModel;
    
    [cell setSelectBlock:^(BOOL isSelect){
        if (isSelect && ![weakSelf.selectMuArray containsObject:assetModel]) {
            [weakSelf.selectMuArray addObject:assetModel];
        }
        
        if (!isSelect && [weakSelf.selectMuArray containsObject:assetModel]) {
            [weakSelf.selectMuArray removeObject:assetModel];
        }
        
        [weakSelf.selectButton setTitle:[NSString stringWithFormat:@"选中（%ld）", weakSelf.selectMuArray.count] forState:UIControlStateNormal];
    }];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:photoHeaderAndFooterResuableStr forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        return header;
    }else{
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:photoHeaderAndFooterResuableStr forIndexPath:indexPath];
        footer.backgroundColor = [UIColor whiteColor];
        return footer;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [PhotoPreviewViewController pushToPreviewVc:self.navigationController dataSource:self.dataSourceMuArray indexPath:indexPath];
}


#pragma mark - publicMethod

+ (void)pushToPhotoVc:(UINavigationController *)nav albumModel:(AlbumModel *)albumModel{
    
    if (albumModel.fetchResult.count > 0) {
        PhotoViewController *tempVc = [PhotoViewController new];
        tempVc.albumModel = albumModel;
        [nav pushViewController:tempVc animated:YES];
    }
    
}

#pragma mark - privateMethod

- (void)rightBarButtonClicked:(UIBarButtonItem *)barButtonItem{
    WEAKSELF
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSNotification *noti = [NSNotification notificationWithName:selectAssetNotiName object:nil userInfo:@{@"info":weakSelf.selectMuArray}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }];
}

- (void)selectButtonAction:(UIButton *)button{
    [self rightBarButtonClicked:nil];
}

#pragma mark - getter&setter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionView *tempCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.waterLayout];
        tempCollectionView.delegate = self;
        tempCollectionView.dataSource = self;
        tempCollectionView.backgroundColor = [UIColor clearColor];
        [[MAIN_BUNDLE loadNibNamed:photoItemResuableStr owner:self options:nil] lastObject];
        [tempCollectionView registerNib:[UINib nibWithNibName:photoItemResuableStr bundle:MAIN_BUNDLE] forCellWithReuseIdentifier:photoItemResuableStr];
        [tempCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:photoHeaderAndFooterResuableStr];
        [tempCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:photoHeaderAndFooterResuableStr];
        
        _collectionView = tempCollectionView;
    }
    return _collectionView;
}

- (LQGWaterFlowLayout *)waterLayout{
    if (!_waterLayout) {
        LQGWaterFlowLayout *tempWaterLayout = [[LQGWaterFlowLayout alloc] initWithColumnsCount:4 rowMargin:0 columnsMargin:0 sectionEdgeInset:UIEdgeInsetsMake(0, 0, 0, 0) getItemSize:^CGFloat(NSIndexPath *itemIndex) {
            return SCREEN_WIDTH / 4;
        } getHeaderSize:^CGSize(NSIndexPath *headerIndex) {
            return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
        } getFooterSize:^CGSize(NSIndexPath *footerIndex) {
            return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
        }];
        _waterLayout = tempWaterLayout;
    }
    return _waterLayout;
}

- (NSMutableArray *)dataSourceMuArray{
    if (!_dataSourceMuArray) {
        NSMutableArray *tempMuArray = [NSMutableArray new];
        
        _dataSourceMuArray = tempMuArray;
    }
    return _dataSourceMuArray;
}

- (UIButton *)selectButton{
    if (!_selectButton) {
        UIButton *tempView = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        tempView.backgroundColor = [UIColor lightGrayColor];
        [tempView setTitle:@"选中（0）" forState:UIControlStateNormal];
        [tempView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempView addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        _selectButton = tempView;
    }
    return _selectButton;
}

- (NSMutableArray *)selectMuArray{
    if (!_selectMuArray) {
        _selectMuArray = [[NSMutableArray alloc] init];
    }
    return _selectMuArray;
}

@end
