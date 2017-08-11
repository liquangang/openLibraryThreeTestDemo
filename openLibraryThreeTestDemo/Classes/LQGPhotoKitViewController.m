//
//  ViewController.m
//  LQGPhotoKit
//
//  Created by liquangang on 2017/4/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

/**************************************
 保存已选中的部分、缩略图等信息
 **************************************/

#import "LQGPhotoKitViewController.h"
#import "LQGWaterFlowLayout.h"
#import "ControlHeaderView.h"
#import "PhotoHomeViewController.h"
#import "Masonry.h"
#import "PhotoManager.h"
#import "PhotoPreviewViewController.h"
#import "AssetModel.h"
#import "PhotoCollectionViewCell.h"

static NSString *itemResuableStr = @"PhotoCollectionViewCell";
static NSString *headerResuableStr = @"UICollectionReusableView";

@interface LQGPhotoKitViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *selectImageCollectionView;
@property (nonatomic, strong) LQGWaterFlowLayout *waterLayout;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArray;
@property (nonatomic, strong) ControlHeaderView *headerView;

@end

@implementation LQGPhotoKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.selectImageCollectionView];
    
    //接收选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAssetAction:) name:selectAssetNotiName object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceMuArray.count == 0 ? 1 : self.dataSourceMuArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemResuableStr forIndexPath:indexPath];
    
    if (self.dataSourceMuArray.count > 0) {
        AssetModel *assetModel = self.dataSourceMuArray[indexPath.row];
        cell.assetModel = assetModel;
    }
    
    cell.selectStatusButton.hidden = YES;
    cell.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    cell.layer.borderWidth = 0.5;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerResuableStr forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        [header addSubview:self.headerView];
        
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        return header;
    }else{
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerResuableStr forIndexPath:indexPath];
        footer.backgroundColor = [UIColor greenColor];
        return footer;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [PhotoPreviewViewController pushToPreviewVc:self.navigationController dataSource:self.dataSourceMuArray indexPath:indexPath];
}

#pragma mark - private method

- (void)photoButtonAction:(UIButton *)btn{
    [PhotoHomeViewController presentSelectPhoto:self];
}

- (void)selectAssetAction:(NSNotification *)noti{
    NSArray *tempArray = noti.userInfo[@"info"];
    [self.dataSourceMuArray addObjectsFromArray:tempArray];
    [self.selectImageCollectionView reloadData];
}

#pragma mark - getter

- (UICollectionView *)selectImageCollectionView{
    if (!_selectImageCollectionView) {
        UICollectionView *tempCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.waterLayout];
        tempCollectionView.delegate = self;
        tempCollectionView.dataSource = self;
        tempCollectionView.backgroundColor = [UIColor clearColor];
        
        [[MAIN_BUNDLE loadNibNamed:itemResuableStr owner:self options:nil] lastObject];
        [tempCollectionView registerNib:[UINib nibWithNibName:itemResuableStr bundle:MAIN_BUNDLE] forCellWithReuseIdentifier:itemResuableStr];
        [tempCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerResuableStr];
        [tempCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerResuableStr];
        
        _selectImageCollectionView = tempCollectionView;
    }
    return _selectImageCollectionView;
}

- (LQGWaterFlowLayout *)waterLayout{
    if (!_waterLayout) {
        LQGWaterFlowLayout *tempWaterLayout = [[LQGWaterFlowLayout alloc] initWithColumnsCount:4 rowMargin:0 columnsMargin:0 sectionEdgeInset:UIEdgeInsetsMake(0, 0, 0, 0) getItemSize:^CGFloat(NSIndexPath *itemIndex) {
            return SCREEN_WIDTH / 4;
        } getHeaderSize:^CGSize(NSIndexPath *headerIndex) {
            return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), SCREEN_WIDTH / 4);
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

- (ControlHeaderView *)headerView{
    if (!_headerView) {
        ControlHeaderView *tempView = [[ControlHeaderView alloc] init];
        [tempView.photoButton addTarget:self action:@selector(photoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _headerView = tempView;
    }
    return _headerView;
}

@end
