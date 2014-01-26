//
//  RegViewController.h
//  JePin
//
//  Created by 冯 鸿杰 on 13-8-20.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegViewController;

/**
 *	@brief	注册视图控制器委托
 */
@protocol RegViewControllerDelegate <NSObject>

@optional

/**
 *	@brief	注册成功
 */
- (void)regSuccess;

@end

/**
 *	@brief	注册视图控制器
 */
@interface RegViewController : UIViewController <UIWebViewDelegate>
{
@private
    NSString *_clientId;
    NSString *_clientSecret;
    NSString *_redirectUri;
    
    UIWebView *_webView;
    id<RegViewControllerDelegate> _delegate;
    
    BOOL _isRegSuc;
}

/**
 *	@brief	协议委托
 */
@property (nonatomic,assign) id<RegViewControllerDelegate> delegate;

/**
 *	@brief	初始化视图控制器
 *
 *	@param 	clientId 	appKey
 *	@param 	clientSecret 	appSecret
 *	@param 	redirectUri 	回调地址
 *
 *	@return	视图控制器
 */
- (id)initWithClientId:(NSString *)clientId
          clientSecret:(NSString *)clientSecret
           redirectUri:(NSString *)redirectUri;


@end
