//
//  ZFPhotosPickerViewController.m
//  ZFPhotosPickerDemo
//
//  Created by infosec2013 on 15/11/2.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import "ZFPhotosPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZFCameraViewController.h"
#import "ZFAlbumsViewController.h"
#import "ZFChoosePhotoViewController.h"
#import "ZFImageViewController.h"
#import "ZFImageViewController.h"
@interface ZFPhotosPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZFCameraVcDelegate,UIActionSheetDelegate,ZFChoosePhotoDelegate,ZFImageDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *collectionLayout;
@property(nonatomic,strong)NSMutableArray *arrayImages;
@property(nonatomic,strong)ZFImageViewController *imgVc;
@end
#define MainBoundSize [[UIScreen mainScreen] bounds].size
@implementation ZFPhotosPickerViewController

- (NSMutableArray *)arrayImages
{
    if (!_arrayImages) {
        _arrayImages = [NSMutableArray array];
    }
    return _arrayImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionLayout.minimumInteritemSpacing = 10;
    self.collectionLayout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 64, MainBoundSize.width - 20, MainBoundSize.height - 64) collectionViewLayout:self.collectionLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class]
        forCellWithReuseIdentifier:@"identifier"];
    [self.view addSubview:self.collectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showImages:(NSArray *)array atIndex:(int)index
{
    self.imgVc = [[ZFImageViewController alloc] initWithImageArray:array andStartIdx:index];
    self.imgVc.delegate = self;
    [self presentViewController:self.imgVc animated:NO completion:nil];
}

- (void)ZFChoosePhotoVc:(ZFChoosePhotoViewController *)zfChoosePhotoVc didSelectedArr:(NSArray *)photoArr
{
    [self.arrayImages addObjectsFromArray:photoArr];
    [self.collectionView reloadData];
}

- (void)zfImageVc:(ZFImageViewController *)zfImageVc dismissWithImageArrary:(NSArray *)imgArr
{
    [self.arrayImages removeAllObjects];
    [self.arrayImages addObjectsFromArray:imgArr];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayImages.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imgAdd = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [cell addSubview:imgAdd];
    if (indexPath.row == self.arrayImages.count) {
        [imgAdd setImage:[UIImage imageNamed:@"addpic_clicked"]];
    }else
    {
        [imgAdd setImage:self.arrayImages[indexPath.row]];
    }
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
    if (indexPath.row == self.arrayImages.count) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册中选取照片" otherButtonTitles:@"拍照", nil];
        [actionSheet showInView:self.view];
        return;
    }
    if (self.arrayImages.count > 0) {
        [self showImages:self.arrayImages atIndex:indexPath.row];
    }
}

//返回这个collectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark- ZFCameraViewController
- (void)ZFCameraViewController:(ZFCameraViewController *)zfCameraVc didFinishedPickImage:(UIImage *)image
{
    [self.arrayImages insertObject:image atIndex:self.arrayImages.count];
    [self.collectionView reloadData];
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            ZFAlbumsViewController *alumsVc = [[ZFAlbumsViewController alloc] init];
            alumsVc.delegate = self;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:alumsVc] animated:YES completion:nil];
        }
            break;
        case 1:
        {
            ZFCameraViewController *cameraVc = [[ZFCameraViewController alloc] init];
            cameraVc.delegate = self;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cameraVc] animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
@end
