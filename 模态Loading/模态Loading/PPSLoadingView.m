//
//  PPSLoadingView.m
//  模态Loading
//
//  Created by 羊谦 on 2017/2/24.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "PPSLoadingView.h"

static CGFloat const KLoadingViewWidth = 70;
static CGFloat const KShapeLayerWidth = 40;
static CGFloat const KShapeLayerRadius = KShapeLayerWidth / 2;
static CGFloat const KShapelayerLineWidth = 2.5;
static CGFloat const KAnimationDurationTime = 1.0;
static CGFloat const KShapeLayerMargin = (KLoadingViewWidth - KShapeLayerWidth) / 2;

@interface PPSLoadingView()

@property (nonatomic, strong)CAShapeLayer *ovalShapeLayer;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic,strong)UILabel *messageLabel;

@end

@implementation PPSLoadingView
{
    UIVisualEffectView *blurView;
    BOOL isShowing;
}

+(void)showWithMessage:(NSString *)message{
    PPSLoadingView *loadIngView = [PPSLoadingView sharedView];
    [loadIngView removeFromSuperview];
    loadIngView.messageLabel.text = message;
    [loadIngView showLoadingViewWithBlur];
}

+(void)dismiss{
    PPSLoadingView *loadIngView = [PPSLoadingView sharedView];
    [loadIngView dismissLoadingViewWithBlur];

}

+(instancetype)sharedView{
    static PPSLoadingView *__loadingView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __loadingView = [[PPSLoadingView alloc] init];
    });
    return __loadingView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}


- (void)showLoadingViewWithBlur{
    
    if (isShowing) { // 如果没有退出动画，就不能继续添加
        return;
    }
    isShowing = YES;
    
    /// 拿到主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    /// view的X
    CGFloat viewCenterX = CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
    /// view的Y
    CGFloat viewCenterY = CGRectGetHeight([UIScreen mainScreen].bounds) / 2;
    
    self.frame = CGRectMake(0, 0, KLoadingViewWidth, KLoadingViewWidth);
    self.center = CGPointMake(viewCenterX, viewCenterY);
    /// 添加到主窗口中
    [window addSubview:self];
    
    blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    blurView.layer.cornerRadius = 10;
    blurView.layer.masksToBounds = YES;
    blurView.frame = CGRectMake(0, 0, 100, 100);
    blurView.center = CGPointMake(viewCenterX, viewCenterY);
    /// 添加毛玻璃效果
    [window insertSubview:blurView belowSubview:self];
}

- (void)dismissLoadingViewWithBlur{
    if (isShowing == NO) {
        return;
    }
    isShowing = NO;
    [blurView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)setUI{
    /// 底部的灰色layer
    CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.strokeColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bottomShapeLayer.lineWidth = KShapelayerLineWidth;
    bottomShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KShapeLayerMargin, 0, KShapeLayerWidth, KShapeLayerWidth) cornerRadius:KShapeLayerRadius].CGPath;
    [self.layer addSublayer:bottomShapeLayer];
    
    /// 橘黄色的layer
    self.ovalShapeLayer = [CAShapeLayer layer];
    self.ovalShapeLayer.strokeColor = [UIColor colorWithRed:0.984 green:0.153 blue:0.039 alpha:1.000].CGColor;
    self.ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.ovalShapeLayer.lineWidth = KShapelayerLineWidth;
    self.ovalShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KShapeLayerMargin, 0,KShapeLayerWidth, KShapeLayerWidth) cornerRadius:KShapeLayerRadius].CGPath;
    [self.layer addSublayer:self.ovalShapeLayer];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animations) userInfo:nil repeats:YES];
    [self.timer fire];
//
//    _messageLabel = ({
//        UILabel *label = [UILabel new];
//        //        label.text = @"正在加载...";
//        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
//        label.font = [UIFont systemFontOfSize:14];
//        label.frame = CGRectMake(0, KShapeLayerWidth + 5, KLoadingViewWidth, 20);
//        label.textAlignment = NSTextAlignmentCenter;
//        label;
//    });
//    
//    [self addSubview:_messageLabel];
}


- (void)animations{
    /// 起点动画
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(0.0);
    strokeStartAnimation.toValue = @(0.25);
    
    /// 终点动画
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(0.5);
    
    /// 组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation,strokeEndAnimation];
    animationGroup.duration = KAnimationDurationTime;
    animationGroup.repeatCount = 1;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [self.ovalShapeLayer addAnimation:animationGroup forKey:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 起点动画
        CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @(0.25);
        strokeStartAnimation.toValue = @(1.0);
        
        /// 终点动画
        CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @(0.5);
        strokeEndAnimation.toValue = @(1.0);
        
        /// 组合动画
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[strokeStartAnimation,strokeEndAnimation];
        animationGroup.duration = KAnimationDurationTime;
        animationGroup.repeatCount = 1;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        [self.ovalShapeLayer addAnimation:animationGroup forKey:nil];
    });
}





@end
