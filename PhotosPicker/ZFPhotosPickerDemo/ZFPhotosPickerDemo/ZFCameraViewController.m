//
//  ZFCameraViewController.m
//  ZFPhotosPickerDemo
//
//  Created by infosec2013 on 15/11/6.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import "ZFCameraViewController.h"

@interface ZFCameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UIImagePickerController *cameraPicker;
@end

@implementation ZFCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCameraPicker];
}

- (void)initCameraPicker
{
    self.cameraPicker.allowsEditing = YES;
    self.cameraPicker.delegate = self;
    self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraPicker.view.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:self.cameraPicker.view];
}

- (UIImagePickerController *)cameraPicker
{
    if (!_cameraPicker) {
        _cameraPicker = [[UIImagePickerController alloc] init];
    }
    return _cameraPicker;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (!image) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ZFCameraViewController:didFinishedPickImage:)]) {
                [self.delegate ZFCameraViewController:self didFinishedPickImage:image];
            }
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        if (image) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ZFCameraViewController:didFinishedPickImage:)]) {
                [self.delegate ZFCameraViewController:self didFinishedPickImage:image];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
