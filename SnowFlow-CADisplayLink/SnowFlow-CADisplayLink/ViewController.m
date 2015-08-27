//
//  ViewController.m
//  SnowFlow-CADisplayLink
//
//  Created by 李云龙 on 15/8/27.
//  Copyright (c) 2015年 hihilong. All rights reserved.
//

#import "ViewController.h"

#define degree2angle(angle)  ((angle) * M_PI / 180)

@interface ViewController ()

@property (nonatomic, strong) CADisplayLink *timer;

@property (nonatomic ,assign) long long steps;

@end

@implementation ViewController

- (CADisplayLink *)timer
{
    if (_timer == nil) {
        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    
    return _timer;
}

- (void)loadView
{
    UIImageView *bg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    bg.image = [UIImage imageNamed:@"snowbg.jpg"];
    
    bg.contentMode = UIViewContentModeScaleAspectFill;
    
    bg.userInteractionEnabled = YES;
    
    self.view = bg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

//点击的时候动画停止
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopTimer];
}

- (void)stopTimer
{
    [self.timer invalidate];
}

- (void)update
{
    _steps++;
    //执行5次添加一次
    if (_steps % 5 == 0) {
        [self snow];
    }
    
}
// 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)snow
{
    // 1.实例化一个雪花的图像视图
    // 整个视图的尺寸
    CGSize winSize = self.view.bounds.size;
    UIImage *image = [UIImage imageNamed:@"雪花"];
    
    // 2.添加到视图
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    CGFloat startX = arc4random_uniform(winSize.width);
    CGFloat startY = -imageView.bounds.size.height;
    imageView.center = CGPointMake(startX, startY);
    
    // 0.01~0.4 随机在0.01~0.4缩放
    CGFloat scale = arc4random_uniform(40)/100.0 + 0.01;
    [imageView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
    
    [self.view addSubview:imageView];
    
    //3.动画下落
    [UIView animateWithDuration:10.0f animations:^{
        // 移动到终点位置
        CGFloat endX = arc4random_uniform(winSize.width);
        CGFloat endY = winSize.height + imageView.bounds.size.height;
        imageView.center = CGPointMake(endX, endY);
        // 下落的过程中旋转180度
        [imageView.layer setValue:@(M_PI) forKeyPath:@"transform.rotation"];
        // 不透明度为0.3
        [imageView.layer setValue:@(0.3) forKeyPath:@"opacity"];
        
    } completion:^(BOOL finished) {
        // 结束动画移除imageView
        [imageView removeFromSuperview];
        
    }];
    
}

@end
