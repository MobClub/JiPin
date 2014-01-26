//
//  RootViewController.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface RootViewController : UIViewController

/**
 *	@brief	显示视图
 *
 *	@param 	type 	类型
 *  @param  animated    动画过渡标识
 */
- (void)showViewWithType:(NSInteger)type animated:(BOOL)animated;


/**
 *	@brief	显示登录界面
 *
 *	@param 	animated 	动画过渡标识
 */
- (LoginViewController *)showLoginWithAnimated:(BOOL)animated;


@end
