//
//  PhotoPreviewViewController.m
//  LQGPhotoKit
//
//  Created by quangang on 2017/6/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

//图片全屏预览界面

#import "PhotoPreviewViewController.h"
#import "AssetModel.h"
#import "PhotoPreviewCollectionViewCell.h"
#import "PhotoHomeViewController.h"

static NSString *itemResuableID = @"PhotoPreviewCollectionViewCell";

@interface PhotoPreviewViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AVPlayerLayer *playLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIView *navView;                      //自定义导航栏
@property (nonatomic, assign) BOOL isPlay;                          //记录播放状态
@property (nonatomic, strong) AVPlayerItem *playerItem;             //播放资源对象

@end

@implementation PhotoPreviewViewController

- (void)dealloc{
    NSLog(@"%@ dealloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [self.view addSubview:self.navView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    
    AssetModel *tempModel = self.dataSource[indexPath.row];
    PhotoPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemResuableID forIndexPath:indexPath];
    cell.assetModel = tempModel;
    
    [cell setPlayButtonBlock:^{
        [[PhotoManager shareInstance] getPlayItem:tempModel.asset completionHandler:^(AVPlayerItem *playerItem) {
            [PhotoManager asyncMainQueue:^{
                weakSelf.playerItem = playerItem;
                [weakSelf playerPlay];
            }];
        }];
    }];
    
    [cell setTouchImageBlock:^{
        weakSelf.navView.hidden = !weakSelf.navView.hidden;
        
        if (weakSelf.isPlay) {
            weakSelf.isPlay = NO;
            [weakSelf.collectionView reloadData];
            weakSelf.navView.hidden = NO;
        }
    }];
    
    return cell;
}

/**
 *  当cell要出现的时候处理一下，因为collectionView会预加载一个未显示的cell，这会导致cell的内容未被刷新，导致ui显示错误（全屏显示会遇到）
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //当下一个cell出现时移除播放器（其他时刻移除会出现播放器移除过早的情况，此时还没有切到另一个cell）
    [self playerPause];
    
    AssetModel *tempModel = self.dataSource[indexPath.row];
    PhotoPreviewCollectionViewCell *previewCell = (PhotoPreviewCollectionViewCell *)cell;
    previewCell.assetModel = tempModel;
}

#pragma mark - publicMethod

+ (void)pushToPreviewVc:(UINavigationController *)nav dataSource:(NSMutableArray *)dataSource indexPath:(NSIndexPath *)indexPath{
    
    if (dataSource.count > 0) {
        PhotoPreviewViewController *tempVc = [PhotoPreviewViewController new];
        tempVc.dataSource = dataSource;
        tempVc.indexPath = indexPath;
        
        [nav pushViewController:tempVc animated:YES];
    }
}

#pragma mark - privateMethod

- (void)cancleButtonAction:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playerPause{
    [self.playLayer removeFromSuperlayer];
    [self.player pause];
}

- (void)playerPlay{
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:self.playLayer];
    [self.player play];
    self.isPlay = YES;
}

#pragma mark - getter & setter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *tempLayout = [[UICollectionViewFlowLayout alloc] init];
        tempLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        tempLayout.itemSize = self.view.bounds.size;
        tempLayout.minimumLineSpacing = 0;
        tempLayout.minimumInteritemSpacing = 0;
        tempLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UICollectionView *tempView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:tempLayout];
        tempView.backgroundColor = [UIColor clearColor];
        tempView.pagingEnabled = YES;
        tempView.dataSource = self;
        tempView.delegate = self;
        [[MAIN_BUNDLE loadNibNamed:itemResuableID owner:self options:nil] lastObject];
        [tempView registerNib:[UINib nibWithNibName:itemResuableID bundle:MAIN_BUNDLE] forCellWithReuseIdentifier:itemResuableID];
        
        _collectionView = tempView;
    }
    return _collectionView;
}

- (UIView *)navView{
    if (!_navView) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        tempView.backgroundColor = ColorFromRGBA(0xFFFFFF, 0.88);
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 44, 44)];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempView addSubview:backButton];
        
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[PhotoHomeViewController class]]) {
            UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 64, 20, 44, 44)];
            [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [tempView addSubview:cancleButton];
        }
        
        _navView = tempView;
    }
    return _navView;
}

@end
