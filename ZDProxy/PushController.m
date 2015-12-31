//
//  PushController.m
//  ZDProxy
//
//  Created by 符现超 on 15/12/31.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//

#import "PushController.h"
#import "NSObject+ZDDealloc.h"
#import "NSTimer+BlocksKit.h"

@interface PushController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation PushController

- (void)dealloc
{
    NSLog(@"释放了%s, %d", __FUNCTION__, __LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __unsafe_unretained __typeof(&*self)weakSelf1 = self;
    [self zd_releaseAtDealloc:^{
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf1 name:@"myNotification" object:nil];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNum:) name:@"myNotification" object:nil];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
    __weak __typeof(&*self)weakSelf = self;
    [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
        [weakSelf showTime];
    } repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showNum:(NSNotification *)notif
{
    NSNumber *num = notif.object;
    self.textField.text = [NSString stringWithFormat:@"%@", num];
    NSLog(@"%@", num);
}

- (void)showTime
{
    NSDate *date = [NSDate date];
    NSLog(@"%@", date);
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
