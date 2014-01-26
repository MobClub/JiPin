//
//  RootViewController.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "RootViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "IIViewDeckController.h"
#import "AGSinaWeiboListViewController.h"
#import "FavViewController.h"
#import "MoreViewController.h"
#import <AGCommon/NSString+Common.h>

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.navigationController.navigationBarHidden = YES;
    
    LoginViewController *loginVC = [self showLoginWithAnimated:NO];
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
    {
        loginVC.loginButtonHidden = YES;
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                          authOptions:[ShareSDK authOptionsWithAutoAuth:NO
                                                          allowCallback:NO
                                                          authViewStyle:SSAuthViewStyleModal
                                                           viewDelegate:nil
                                                authManagerViewDelegate:nil]
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result)
                                   {
                                       [self showViewWithType:0 animated:NO];
                                   }
                                   else
                                   {
                                       loginVC.loginButtonHidden = NO;
                                   }
                               }];
    }
}

- (void)showViewWithType:(NSInteger)type animated:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    switch (type)
    {
        case 0:
            [self showNewestViewWithAnimated:animated];
            break;
        case 1:
            [self showFavoriteViewWithAnimated:animated];
            break;
        case 2:
            [self showSettingViewWithAnimated:animated];
            break;
        default:
            break;
    }
}

- (LoginViewController *)showLoginWithAnimated:(BOOL)animated;
{
    [self.navigationController setNavigationBarHidden:YES];
    self.viewDeckController.enabled = NO;
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:animated];
    [vc release];
    
    return vc;
}

#pragma mark - Private

/**
 *	@brief	显示最新界面
 *
 *  @param  animated    动画过渡标识
 */
- (void)showNewestViewWithAnimated:(BOOL)animated
{
    self.viewDeckController.enabled = YES;
    
    [self.navigationController setNavigationBarHidden:NO];
    UIViewController *newViewController = [[[AGSinaWeiboListViewController alloc] init] autorelease];
    [self.navigationController pushViewController:newViewController animated:animated];
}

/**
 *	@brief	显示收藏界面
 *
 *  @param  animated    动画过渡标识
 */
- (void)showFavoriteViewWithAnimated:(BOOL)animated
{
    self.viewDeckController.enabled = YES;
    
    UIViewController *favViewController = [[[FavViewController alloc] init] autorelease];
    [self.navigationController pushViewController:favViewController animated:animated];
}

/**
 *	@brief	显示设置界面
 *
 *  @param  animated    动画过渡标识
 */
- (void)showSettingViewWithAnimated:(BOOL)animated
{
    self.viewDeckController.enabled = YES;
    
    UIViewController *moreViewController = [[[MoreViewController alloc] init] autorelease];
    [self.navigationController pushViewController:moreViewController animated:animated];

}

@end
