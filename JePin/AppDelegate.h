//
//  AppDelegate.h
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "AGViewDelegate.h"
#import "IIViewDeckController.h"
#import <AGCommon/CMImageCacheManager.h>
#import <ShareSDK/ShareSDK.h>
#import <SinaWeiboConnection/SSSinaWeiboStatus.h>
#import <SinaWeiboConnection/SSSinaWeiboStatusInfoReader.h>

@class AGViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,
                                      IIViewDeckControllerDelegate,
                                      WXApiDelegate>
{
    AGViewDelegate *_viewDelegate;
    enum WXScene _scene;
    UIInterfaceOrientationMask _interfaceOrientationMask;
    CMImageCacheManager *_imageCacheManager;
    id<ISSAuthOptions> _authOptions;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IIViewDeckController *viewController;

/**
 *	@brief	图片缓存管理器
 */
@property (nonatomic,readonly) CMImageCacheManager *imageCacheManager;

/**
 *	@brief	授权选项
 */
@property (nonatomic,readonly) id<ISSAuthOptions> authOptions;

/**
 *	@brief	分享微博
 *
 *	@param 	status 	微博信息
 */
- (void)shareStatus:(SSSinaWeiboStatusInfoReader *)status;


@end
