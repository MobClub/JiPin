//
//  AGiPhoneViewDelegate.m
//  AGShareSDKDemo
//
//  Created by 冯 鸿杰 on 13-4-12.
//  Copyright (c) 2013年 vimfung. All rights reserved.
//

#import "AGViewDelegate.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import "AGJiPinStyle.h"
#import "UILabel+AGJiPinConfig.h"
#import <AGCommon/UIColor+Common.h>
		
@implementation AGViewDelegate

#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label applyStyle:[AGJiPinStyle NavigationBarTitleStyle]];
    label.textAlignment = NSTextAlignmentCenter;  // ^-Use UITextAlignmentCenter for older SDKs.
    label.text = viewController.title;
    viewController.navigationItem.titleView = label;
    [label sizeToFit];
    [label release];
    
    UIButton *btn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
    [btn setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateNormal];

}

@end
