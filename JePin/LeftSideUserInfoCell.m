//
//  UserInfoCell.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "LeftSideUserInfoCell.h"
#import <AGCommon/UIColor+Common.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
#import "AppDelegate.h"
#import <SinaWeiboConnection/SSSinaWeiboUserInfoReader.h>

#define PADDING_LEFT 14.0
#define PADDING_TOP 15.0
#define PADDING_RIGHT 14.0
#define PADDING_BOTTOM 15.0
#define HORIZONTAL_GAP 8.0
#define VERTICAL_GAP 4.0

#define ICON_WIDTH 44.0
#define ICON_HEIGHT 44.0

@implementation LeftSideUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _imageCacheManager = ((AppDelegate *)[UIApplication sharedApplication].delegate).imageCacheManager;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //阴影
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userInfoCellShadow.png"]];
        shadowImageView.frame = CGRectMake(0.0, self.contentView.height - shadowImageView.height, self.contentView.width, shadowImageView.height);
        shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:shadowImageView];
        [shadowImageView release];
        
        _iconImageView = [[CMImageView alloc] initWithFrame:CGRectMake(PADDING_LEFT,
                                                                       PADDING_TOP,
                                                                       ICON_WIDTH,
                                                                       ICON_HEIGHT)];
        [self.contentView addSubview:_iconImageView];
        [_iconImageView release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectMake(_iconImageView.right + HORIZONTAL_GAP,
                                      PADDING_TOP,
                                      _nameLabel.width,
                                      _nameLabel.height);
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.textColor = [UIColor colorWithRGB:0xb4b4b4];
        _descLabel.backgroundColor = [UIColor clearColor];
        [_descLabel sizeToFit];
        _descLabel.frame = CGRectMake(_iconImageView.right + HORIZONTAL_GAP,
                                      _iconImageView.bottom + VERTICAL_GAP,
                                      _descLabel.width,
                                      _descLabel.height);
        [self.contentView addSubview:_descLabel];
        [_descLabel release];
        
        id<ISSSinaWeiboApp> app = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
        SSSinaWeiboUserInfoReader *user = [SSSinaWeiboUserInfoReader readerWithSourceData:[[app currentUser] sourceData]];
        [self fillUserInfo:user];
        
        [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                                   target:self
                                   action:@selector(userInfoUpdateHandler:)];
        
    }
    return self;
}

- (void)dealloc
{
    [ShareSDK removeAllNotificationWithTarget:self];
    [self releaseImageLoader];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needLayout)
    {
        _needLayout = NO;
        
        [_nameLabel sizeToFit];
        [_descLabel sizeToFit];
        
        CGFloat left = _iconImageView.right + HORIZONTAL_GAP;
        _nameLabel.frame = CGRectMake(left, PADDING_TOP, self.contentView.width - left, _nameLabel.height);
        _descLabel.frame = CGRectMake(left, _nameLabel.bottom + VERTICAL_GAP, self.contentView.width - left, _descLabel.height);
    }
}

#pragma mark - Private

/**
 *	@brief	释放图片加载器
 */
- (void)releaseImageLoader
{
    [_imageLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_imageLoader);
}

/**
 *	@brief	填充用户信息
 *
 *	@param 	userInfo 	用户信息
 */
- (void)fillUserInfo:(SSSinaWeiboUserInfoReader *)userInfo
{
    if (userInfo)
    {
        //填充用户信息
        if (userInfo.avatarLarge)
        {
            [self releaseImageLoader];
            
            _imageLoader = [[_imageCacheManager getImage:userInfo.avatarLarge
                                            cornerRadius:22
                                                    size:_iconImageView.frame.size]
                            retain];
            if (_imageLoader.state == ImageLoaderStateReady)
            {
                _iconImageView.image = _imageLoader.content;
            }
            else
            {
                [_imageLoader addNotificationWithName:NOTIF_IMAGE_LOAD_COMPLETE target:self action:@selector(loadImageCompleteHandler:)];
                [_imageLoader addNotificationWithName:NOTIF_IMAGE_LOAD_ERROR target:self action:@selector(loadImageErrorHandler:)];
            }
        }
        
        _nameLabel.text = userInfo.name;
        if (userInfo.verified)
        {
            _descLabel.text = userInfo.verifiedReason;
        }
        else
        {
            _descLabel.text = userInfo.description;
        }
        
        _needLayout = YES;
        [self setNeedsLayout];
    }
}

/**
 *	@brief	加载头像完成
 *
 *	@param 	notif 	通知
 */
- (void)loadImageCompleteHandler:(NSNotification *)notif
{
    _iconImageView.image = _imageLoader.content;
    
    [self releaseImageLoader];
}

/**
 *	@brief	加载头像失败
 *
 *	@param 	notif 	通知
 */
- (void)loadImageErrorHandler:(NSNotification *)notif
{
    _iconImageView.image = nil;
    [self releaseImageLoader];
}

/**
 *	@brief	用户信息更新
 *
 *	@param 	notif 	通知
 */
- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    id<ISSSinaWeiboApp> app = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
    SSSinaWeiboUserInfoReader *user = [SSSinaWeiboUserInfoReader readerWithSourceData:[[app currentUser] sourceData]];
    [self fillUserInfo:user];
}

@end
