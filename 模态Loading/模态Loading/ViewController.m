//
//  ViewController.m
//  模态Loading
//
//  Created by 羊谦 on 2017/2/24.
//  Copyright © 2017年 羊谦. All rights reserved.
//

#import "ViewController.h"
#import "PPSLoadingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showLoading:(id)sender {
    [PPSLoadingView showWithMessage:@"正在加载"];
    
}
- (IBAction)dismissLoading:(id)sender {
    [PPSLoadingView dismiss];
}

@end
