//
//  LoginViewController.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegViewController.h"

/**
 *	@brief	登录视图
 */
@interface LoginViewController : UIViewController <RegViewControllerDelegate>
{
@private
    UIButton *_loginButton;
    UIButton *_regButton;
    UIActivityIndicatorView *_indicator;
    BOOL _loginButtonHidden;
}

/**
 *	@brief	登录按钮隐藏标志
 */
@property (nonatomic) BOOL loginButtonHidden;


@end
