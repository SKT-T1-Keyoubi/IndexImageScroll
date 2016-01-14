//
//  ViewController.m
//  小项目之图片无限轮播
//
//  Created by LoveQiuYi on 15/12/27.
//  Copyright © 2015年 LoveQiuYi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ViewController
NSTimer * timer;
- (void)viewDidLoad {
    [super viewDidLoad];
    //生成5个imageView
    int count = 5;
    //scrollView框的大小
    CGSize size = self.scrollView.frame.size;
    for (int i = 0; i < count; i++) {
        //创建imageView
        UIImageView * imageView = [[UIImageView alloc] init];
        //添加到ScrollView中
        [self.scrollView addSubview:imageView];
        //从文件夹中获取图片
        NSString * imageName = [NSString stringWithFormat:@"img_%02d",i+1];
        //设置imageView的图片为获取的图片
        imageView.image = [UIImage imageNamed:imageName];
        //设置图片的位置
        CGFloat x = i * size.width;
        imageView.frame = CGRectMake(x, 0, size.width, size.height);
    }
    //设置滚动范围5张图片的大小
    self.scrollView.contentSize = CGSizeMake(count * size.width, 0);
    //水平滚动条不显示
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //设置分页
    self.scrollView.pagingEnabled = YES;
    //设置Page的页数
    self.pageControl.numberOfPages = count;
    self.scrollView.delegate = self;
    //增加定时器方法
    [self addTimer];
    
}
-(void) addTimer{
    //创建一个定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    
    
}
-(void) nextImage{
    //获取当前的页码
    NSInteger page = self.pageControl.currentPage;
    if (page == self.pageControl.numberOfPages - 1) {
        page = 0;
    }
    else{
        page++;
    }
    //移动图片的原理
    CGFloat offSetX = page * self.scrollView.frame.size.width;
    //执行动画
    [UIView animateWithDuration:2.0 animations:^{
        self.scrollView.contentOffset = CGPointMake(offSetX, 0);
    }];
}
//正在滚动的时候
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动超过一半的时候显示下一页
    int page = (scrollView.contentOffset.x + scrollView.frame.size.width/2)/scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}
//拖拽图片暂停定时器
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [timer setFireDate:[NSDate distantFuture]];
}
//拖拽完毕重新启用定时器
-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [timer setFireDate:[NSDate date]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
