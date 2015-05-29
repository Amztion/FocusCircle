//
//  ItemsNavigationController.m
//  RememberMe
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import "ItemsNavigationController.h"

@interface ItemsNavigationController ()


@end

@implementation ItemsNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar{
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.67 green:0.25 blue:0.22 alpha:1];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
