//
//  ZDProxy.h
//  ZDProxy
//
//  Created by 符现超 on 15/12/10.
//  Copyright © 2015年 Fate.D.Bourne. All rights reserved.
//

@import Foundation;

//============================================
// @name
//============================================

@interface ZDProxy : NSObject

@property (nonatomic, strong) IBOutletCollection(id) NSArray *delegateTargets;

@end
