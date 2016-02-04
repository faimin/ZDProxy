//
//  SecondController.m
//  ZDProxy
//
//  Created by 符现超 on 15/12/31.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//

#import "SecondController.h"

@interface SecondController ()

@property (nonatomic, assign) NSUInteger number;

@end

@implementation SecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postNotification:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotification" object:@(self.number++) userInfo:nil];
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
