//
//  ZFImageViewController.h
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFImageViewController;
@protocol ZFImageDelegate <NSObject>
- (void)zfImageVc:(ZFImageViewController *)zfImageVc dismissWithImageArrary:(NSArray *)imgArr;
@end

@interface ZFImageViewController : UIViewController
@property(nonatomic,weak)id<ZFImageDelegate> delegate;
- (instancetype)initWithImageArray:(NSArray *)array andStartIdx:(int)index;
@end
