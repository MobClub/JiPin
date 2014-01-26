//
//  AGCurrentUserIconView.m
//  JePin
//
//  Created by vimfung on 13-7-6.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "AGCurrentUserIconView.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
#import <SinaWeiboConnection/SSSinaWeiboUserInfoReader.h>

@implementation AGCurrentUserIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _imageView = [[CMImageView alloc] initWithFrame:CGRectMake((self.width - 30) / 2,
                                                                   (self.height - 30) / 2,
                                                                   30,
                                                                   30)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_imageView];
        [_imageView release];
        
        [self updateUserIcon];
        [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                                   target:self
                                   action:@selector(userInfoUpdateHandler:)];
        
    }
    
    return self;
}

- (void)dealloc
{
    [ShareSDK removeAllNotificationWithTarget:self];
    [_imageLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_imageLoader);
    
    [super dealloc];
}

#pragma mark - Private

/**
 *	@brief	更新用户头像
 */
- (void)updateUserIcon
{
    id<ISSSinaWeiboApp> app = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
    SSSinaWeiboUserInfoReader *userInfo = [SSSinaWeiboUserInfoReader readerWithSourceData:[[app currentUser] sourceData]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (userInfo.avatarLarge)
    {
        [_imageLoader removeAllNotificationWithTarget:self];
        SAFE_RELEASE(_imageLoader);
        
        _imageLoader = [[appDelegate.imageCacheManager getImage:userInfo.avatarLarge
                                                   cornerRadius:15
                                                           size:_imageView.bounds.size]
                        retain];
        
        if (_imageLoader.state == ImageLoaderStateReady)
        {
            _imageView.image = _imageLoader.content;
        }
        else
        {
            [_imageLoader addNotificationWithName:NOTIF_IMAGE_LOAD_COMPLETE
                                           target:self
                                           action:@selector(imageLoadCompleteHandler:)];
            [_imageLoader addNotificationWithName:NOTIF_IMAGE_LOAD_ERROR
                                           target:self
                                           action:@selector(imageLoadErrorHandler:)];
        }
    }
}

/**
 *	@brief	加载完成
 *
 *	@param 	notif 	通知
 */
- (void)imageLoadCompleteHandler:(NSNotification *)notif
{
    _imageView.image = _imageLoader.content;
}

/**
 *	@brief	加载失败
 *
 *	@param 	notif 	通知
 */
- (void)imageLoadErrorHandler:(NSNotification *)notif
{
    
}

/**
 *	@brief	用户信息更新
 *
 *	@param 	notif 	通知
 */
- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    [self updateUserIcon];
}

@end
