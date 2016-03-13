//
//  PhotoCell.h
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZF_Asset;
@interface PhotoCell : UICollectionViewCell
@property(nonatomic,strong)ZF_Asset *asset;
@end
