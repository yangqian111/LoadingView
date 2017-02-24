//
//  PPSLoadingView.h
//  模态Loading
//
//  Created by 羊谦 on 2017/2/24.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSLoadingView : UIView

+ (instancetype)sharedView;

/**
 *  显示加载动画
 */
+ (void)showWithMessage:(NSString *)message;

/**
 *  关闭加载动画
 */
+ (void)dismiss;

@end
