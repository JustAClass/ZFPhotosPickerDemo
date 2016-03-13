//
//  ZFChoosePhotoViewController.h
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;
@class ZFChoosePhotoViewController;
@protocol ZFChoosePhotoDelegate <NSObject>
- (void)ZFChoosePhotoVc:(ZFChoosePhotoViewController *)zfChoosePhotoVc didSelectedArr:(NSArray *)photoArr;
@end

@interface ZFChoosePhotoViewController : UIViewController
@property(nonatomic,weak)id<ZFChoosePhotoDelegate> delegate;
@property(nonatomic,strong)ALAssetsGroup *group;
@end

