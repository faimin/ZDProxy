//
//  PushController.m
//  ZDProxy
//
//  Created by 符现超 on 15/12/31.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//

#import "PushController.h"
#import "NSObject+ZDDealloc.h"
#import "ZDWeakProxy.h"
#import "NSObject+ZDLazyInit.h"

@interface PushController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PushController

- (void)dealloc
{
	NSLog(@"当前控制器正常释放了%s, %d", __FUNCTION__, __LINE__);
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	[self autoDeallocTest];
	[self removeTimerTest];
	[self lazyInitTest];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - TEST

- (void)autoDeallocTest
{
	__unsafe_unretained __typeof( & *self) weakSelf1 = self;

	[self zd_releaseAtDealloc:^{
		[[NSNotificationCenter defaultCenter] removeObserver:weakSelf1 name:@"myNotification" object:nil];
	}];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNum:) name:@"myNotification" object:nil];
}

- (void)removeTimerTest
{
	ZDWeakProxy *weakProxy = [ZDWeakProxy proxyWithTarget:self];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakProxy selector:@selector(showTime) userInfo:nil repeats:YES];
}

- (void)lazyInitTest
{
    //此方法无法通过验证,pass
    return;
	UIView *lazyView = [[UIView lazy] initWithFrame:(CGRect) {50, 50, 200, 200}];
	lazyView.backgroundColor = [UIColor purpleColor];
	[self.view addSubview:lazyView];
}

#pragma mark - Private Action

- (void)showNum:(NSNotification *)notif
{
	NSNumber *num = notif.object;

	self.textField.text = [NSString stringWithFormat:@"%@", num];
	NSLog(@"%@", num);
}

- (void)showTime
{
	NSDate *date = [NSDate date];
    self.textField.text = [NSString stringWithFormat:@"%@", date];
	NSLog(@"%@", date);
}

/*
 * #pragma mark - Navigation
 *
 *  // In a storyboard-based application, you will often want to do a little preparation before navigation
 *  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *   // Get the new view controller using [segue destinationViewController].
 *   // Pass the selected object to the new view controller.
 *  }
 */

@end
