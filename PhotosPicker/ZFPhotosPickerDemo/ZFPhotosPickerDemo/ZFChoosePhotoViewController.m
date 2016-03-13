//
//  ZFChoosePhotoViewController.m
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import "ZFChoosePhotoViewController.h"
#import "ZF_Asset.h"
#import "PhotoCell.h"
@interface ZFChoosePhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *collectionFlowLayout;
@property(nonatomic,strong)NSMutableArray *photoArr;
@end
#define MainBoundSize [[UIScreen mainScreen] bounds].size
@implementation ZFChoosePhotoViewController

- (NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scanPhoto];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionFlowLayout.minimumInteritemSpacing = 5;
    self.collectionFlowLayout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, MainBoundSize.width - 20, MainBoundSize.height - 64) collectionViewLayout:self.collectionFlowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[PhotoCell class]
            forCellWithReuseIdentifier:@"identifier"];
    [self.view addSubview:self.collectionView];
    
    UIBarButtonItem  * doneBarItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clickDone)];
    self.navigationItem.rightBarButtonItem = doneBarItem;
}

- (void)clickDone
{
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (ZF_Asset *asset in self.photoArr) {
        if (asset.selected) {
            [selectedArray addObject:asset];
        }
    }
    [self performSelectorInBackground:@selector(selectedAssets:) withObject:selectedArray];
}

-(void)selectedAssets:(NSArray*)assets{
    
    NSMutableArray  * imageArr = [NSMutableArray array];
    for (ZF_Asset  * zfAS in assets) {
        ALAssetRepresentation  * representation = [zfAS.asset defaultRepresentation];
        CGImageRef  imageRef = [representation fullResolutionImage];
        UIImage    * image = [UIImage imageWithCGImage:imageRef scale:0 orientation:(UIImageOrientation)representation.orientation];
        [imageArr addObject:image];
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if ([_delegate respondsToSelector:@selector(ZFChoosePhotoVc:didSelectedArr:)]) {
                [_delegate ZFChoosePhotoVc:self didSelectedArr:imageArr];
            }
        }];
    });
}

- (void)scanPhoto{
    if(self.group){
        [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result){
                ZF_Asset  * zfAS = [[ZF_Asset alloc]initWithAsset:result];
                [self.photoArr addObject:zfAS];
            }
        }];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setAsset:self.photoArr[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//每个UICollectionView大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60,60);
}

//没个collection view的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    ZF_Asset *asset = self.photoArr[indexPath.row];
    asset.selected = !(asset.selected);
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    [cell setAsset:asset];
}

//返回这个collectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
