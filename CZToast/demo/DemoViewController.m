//
//  DemoViewController.m
//  CZToast
//
//  Created by yunshan on 2019/4/12.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import "DemoViewController.h"
#import "CZToast.h"

@interface DemoViewController ()
@property (nonatomic, assign) NSInteger uniqueID;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)noCallback:(id)sender {
    //控制显示策略
    [CZToast shareManager].showType = CZToastShowTypeImmediately;
    ++self.uniqueID;
    switch (self.uniqueID%3) {
        case 0:
        {
            [[CZToast shareManager] showInTop:[NSString stringWithFormat:@"陈哲是个好孩子abcccc-陈哲是个好孩子abcccc %ld",(long)self.uniqueID]];
        }
            break;
        case 1:
        {
            [[CZToast shareManager] showInCenter:[NSString stringWithFormat:@"陈哲是个好孩子abcccc-陈哲是个好孩子abcccc %ld",(long)self.uniqueID]];
        }
            break;
        case 2:
        {
            [[CZToast shareManager] showInBottom:[NSString stringWithFormat:@"陈哲是个好孩子abcccc-陈哲是个好孩子abcccc %ld",(long)self.uniqueID]];
        }
            break;
        default:
            break;
    }
}

- (IBAction)callback:(id)sender {
    //控制显示策略
    [CZToast shareManager].showType = CZToastShowTypeQueue;
    ++self.uniqueID;
    [[CZToast shareManager] showInCenter:[NSString stringWithFormat:@"陈哲是个好孩子abcccc-陈哲是个好孩子abcccc %ld",(long)self.uniqueID] callback:^(BOOL success, NSError * _Nullable error, NSDictionary * _Nullable dic) {
        NSLog(@"success");
    }];
}

@end
