//
//  ZF_Asset.h
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ZF_Asset : ALAsset
@property(nonatomic,strong)ALAsset *asset;
@property(nonatomic,assign)BOOL selected;
- (instancetype)initWithAsset:(ALAsset *)asset;
@end
