//
//  PhotoCell.m
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import "PhotoCell.h"
#import "ZF_Asset.h"
@interface PhotoCell()
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,strong)UIImageView* selectediCon;
@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        [self addSubview:self.imageView];
        
        self.selectediCon = [[UIImageView alloc] initWithFrame:CGRectMake(44, 0, 16, 16)];
        [self.selectediCon setImage:[UIImage imageNamed:@"icon_data_select"]];
        [self.imageView addSubview:self.selectediCon];
    }
    return self;
}

-(void)setAsset:(ZF_Asset *)asset
{
    _asset = asset;
    if (_asset.selected) {
        self.selectediCon.hidden = NO;
    }
    else
    {
        self.selectediCon.hidden = YES;
    }
    [self.imageView setImage:[UIImage imageWithCGImage:_asset.asset.thumbnail]];
    NSLog(@"%@,hidden = %@",self.imageView,@(self.imageView.hidden));
}
@end
