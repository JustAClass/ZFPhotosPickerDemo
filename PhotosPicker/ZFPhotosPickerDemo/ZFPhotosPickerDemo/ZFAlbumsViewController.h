//
//  ZFAlbumsViewController.h
//  ZFPhotosPickerDemo
//
//  Created by infosec2013 on 15/11/6.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFChoosePhotoViewController.h"
@interface ZFAlbumsViewController : UIViewController
@property(nonatomic,weak)id<ZFChoosePhotoDelegate> delegate;
@end
