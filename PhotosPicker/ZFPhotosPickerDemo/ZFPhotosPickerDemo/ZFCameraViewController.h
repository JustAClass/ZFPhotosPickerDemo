//
//  ZFCameraViewController.h
//  ZFPhotosPickerDemo
//
//  Created by infosec2013 on 15/11/6.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCameraViewController;
@protocol ZFCameraVcDelegate <NSObject>
- (void)ZFCameraViewController:(ZFCameraViewController *)zfCameraVc didFinishedPickImage:(UIImage *)image;
@end

@interface ZFCameraViewController : UIViewController
@property(nonatomic,weak)id<ZFCameraVcDelegate> delegate;
@end
