//
//  UserInfoCell.h
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGCommon/CMImageView.h>
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/CMImageCacheManager.h>

/**
 *	@brief	用户信息单元格
 */
@interface LeftSideUserInfoCell : UITableViewCell
{
@private
    CMImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_descLabel;
    CMImageCacheManager *_imageCacheManager;
    CMImageLoader *_imageLoader;
    
    BOOL _needLayout;
}

@end
