//
//  ZFImageViewController.m
//  ZFPhotosPickerDemo
//
//  Created by 张繁 on 15/11/8.
//  Copyright (c) 2015年 Infosec. All rights reserved.
//

#import "ZFImageViewController.h"

@interface ZFImageViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *imgArr;
@property(nonatomic,strong)NSMutableArray *imgViewArr;
@property(nonatomic,assign)int currIndex;
@end

@implementation ZFImageViewController

- (instancetype)initWithImageArray:(NSArray *)array andStartIdx:(int)index
{
    self = [super init];
    if (self) {
        self.imgArr = [NSMutableArray arrayWithArray:array];
        self.currIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    CGFloat scrollW = self.scrollView.frame.size.width;
    CGFloat scrollH = self.scrollView.frame.size.height;
    int temp;
    for (temp = 0; temp<self.imgArr.count; temp++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(temp*scrollW, 0, scrollW, scrollH)];
        [self.scrollView addSubview:imgView];
        [imgView setImage:self.imgArr[temp]];
        
        [self.imgViewArr addObject:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(temp * scrollW, 0);
    self.scrollView.contentOffset = CGPointMake(self.currIndex * scrollW, 0);
    self.scrollView.pagingEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:NO completion:^{
        if ([_delegate respondsToSelector:@selector(zfImageVc:dismissWithImageArrary:)]) {
            [_delegate zfImageVc:self dismissWithImageArrary:self.imgArr];
        }
    }];
}

@end
