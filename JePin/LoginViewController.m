//
//  LoginViewController.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIDevice+Common.h>
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import <AGCommon/NSString+Common.h>

@implementation LoginViewController

@synthesize loginButtonHidden = _loginButtonHidden;

- (void)dealloc
{
    [_indicator release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ShareSDK ssoEnabled:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        statusBarHeight = 0;
    }
    
    UIImage *bgImg = nil;
    if ([UIDevice currentDevice].isPhone5)
    {
        bgImg = [UIImage imageNamed:@"Default-568h.png"];
    }
    else
    {
        bgImg = [UIImage imageNamed:@"Default.png"];
    }
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImg];
    [bgImageView setFrame:CGRectMake(0.0, - statusBarHeight, bgImageView.width, bgImageView.height)];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"LoginButton.png"] forState:UIControlStateNormal];
    [_loginButton sizeToFit];
    _loginButton.hidden = _loginButtonHidden;
    _loginButton.frame = CGRectMake((self.view.width - _loginButton.width) / 2,
                           self.view.height - _loginButton.height - 35,
                           _loginButton.width,
                           _loginButton.height);
    _loginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_loginButton addTarget:self action:@selector(loginBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regButton setBackgroundImage:[UIImage imageNamed:@"RegButton.png"] forState:UIControlStateNormal];
    _regButton.frame = CGRectMake(self.view.width - 56.0 - 18, 20.0, 56.0, 22.0);
    [_regButton addTarget:self action:@selector(regBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regButton];
    
}

- (void)setLoginButtonHidden:(BOOL)loginButtonHidden
{
    if (!_indicator)
    {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = CGRectMake((self.view.width - _indicator.width) /2, _loginButton.top + (_loginButton.height - _indicator.height) / 2, _indicator.width, _indicator.height);
    }

    [self.view addSubview:_indicator];

    if (loginButtonHidden)
    {
        [_indicator startAnimating];
    }
    else
    {
        [_indicator stopAnimating];
    }
    
    _loginButtonHidden = loginButtonHidden;
    _loginButton.hidden = _loginButtonHidden;
    _regButton.hidden = _loginButtonHidden;
}

- (void)loginBtnClickHandler:(id)sender
{
    [self setLoginButtonHidden:YES];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:appDelegate.authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   UINavigationController *navController = self.navigationController;
                                   [self.navigationController popViewControllerAnimated:NO];
                                   
                                   RootViewController *rootVC = (RootViewController *)[navController.viewControllers objectAtIndex:0];
                                   [rootVC showViewWithType:0 animated:YES];
                                   
                                   IIViewDeckController *deckController = ((AppDelegate *)[UIApplication sharedApplication].delegate).viewController;
                                   
                                   deckController.enabled = YES;
                               }
                               else
                               {
                                   if ([error errorCode] != -103)
                                   {
                                       if ([error errorCode] == 21321)
                                       {
                                           //取消新浪授权
                                           [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
                                       }
                                       
                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                           message:@"登录失败"
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"知道了"
                                                                                 otherButtonTitles: nil];
                                       [alertView show];
                                       [alertView release];
                                   }
                                   
                                   [self setLoginButtonHidden:NO];
                               }
                           }];
}

- (void)regBtnClickHandler:(id)sender
{
    RegViewController *regVC = [[[RegViewController alloc] initWithClientId:@"474962333"
                                                               clientSecret:@"26522c6ed236057fd4ff5005449f98e9"
                                                                redirectUri:@"http://www.sharesdk.cn"]
                                autorelease];
    regVC.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:regVC];
    [self.navigationController presentModalViewController:navController animated:YES];
    [navController release];
}

#pragma mark - RegViewControllerDelegate

- (void)regSuccess
{
    [_loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
