//
//  ZFAlbumsViewController.m
//  ZFPhotosPickerDemo
//
//  Created by infosec2013 on 15/11/6.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import "ZFAlbumsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ZFAlbumsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)ALAssetsLibrary *assetLibrary; //图片库
@property(nonatomic,strong)NSMutableArray *assetGroupArr; //图片库集合
@property(nonatomic,strong)NSMutableArray *imageArr; //图片集合
@property(nonatomic,strong)UITableView *imageList;
@end

#define CELL_HEIGHT 64

@implementation ZFAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageList];
    [self layoutUI];
    [self initData];
    [self getImageGroup];
}

- (void)initData
{
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    _assetGroupArr = [NSMutableArray array];
}

- (UITableView *)imageList
{
    if (!_imageList) {
        _imageList = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _imageList.delegate = self;
        _imageList.dataSource = self;
    }
    return _imageList;
}

- (void)layoutUI
{
    self.navigationItem.title = @"照片库";
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelItem:)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
}

- (void)getImageGroup
{
    __weak typeof(self) sf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^enumerationBlock)(ALAssetsGroup *,BOOL *) = ^(ALAssetsGroup *group,BOOL *stop){
            if (group) {
                NSString *groupPropertyName = [group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
                if ([[groupPropertyName lowercaseString] isEqualToString:@"camera roll"]&&groupType == ALAssetsGroupSavedPhotos) {
                    [_assetGroupArr insertObject:group atIndex:0];
                }
                else{
                    [_assetGroupArr addObject:group];
                }
                [sf performSelectorOnMainThread:@selector(updateImageList) withObject:nil waitUntilDone:YES];
            }
        };
        void (^faulureBlock)(NSError *) = ^(NSError *error)
        {
            NSString *msg = @"读取相册失败";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView show];
            });
        };
        [_assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:enumerationBlock failureBlock:faulureBlock];
    });
}

- (void)updateImageList
{
    [self.imageList reloadData];
}

- (void)clickCancelItem:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ALAssetsGroup *group = self.assetGroupArr[indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger count = [group numberOfAssets];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%lu张)",[group valueForProperty:ALAssetsGroupPropertyName],count];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _assetGroupArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZFChoosePhotoViewController *choosePhotoVc = [[ZFChoosePhotoViewController alloc] init];
    choosePhotoVc.delegate = self.delegate;
    choosePhotoVc.group = self.assetGroupArr[indexPath.row];
    [self.navigationController pushViewController:choosePhotoVc animated:YES];
}
@end
