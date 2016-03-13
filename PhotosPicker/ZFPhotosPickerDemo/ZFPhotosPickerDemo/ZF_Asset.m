//
//  ZF_Asset.m
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import "ZF_Asset.h"

@implementation ZF_Asset
- (instancetype)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if(self)
    {
        _asset = asset;
        _selected = NO;
    }
    return self;
}
@end
