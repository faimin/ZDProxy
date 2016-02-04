//
//  main.m
//  ZDProxy
//
//  Created by 符现超 on 15/12/10.
//  Copyright © 2015年 ZD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    int x = 0;
    @autoreleasepool {
        @try {
            x = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"exception reason: %@",exception.reason);
            NSLog(@"exception debugDescription: %@",exception.debugDescription);
            NSLog(@"exception callStackSymbols: %@",exception.callStackSymbols);
        }
        @finally {
            
        }
        return x;
    }
}
