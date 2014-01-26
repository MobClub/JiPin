//
//  DetailToolbar.h
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-8.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailToolbarItem.h"

/**
 *	@brief	详情工具栏
 */
@interface DetailToolbar : UIView
{
@private
    DetailToolbarItem *_commentItem;
    DetailToolbarItem *_replyItem;
    DetailToolbarItem *_favoriteItem;
    DetailToolbarItem *_shareItem;
}

/**
 *	@brief	评论
 */
@property (nonatomic,readonly) DetailToolbarItem *commentItem;

/**
 *	@brief	转发
 */
@property (nonatomic,readonly) DetailToolbarItem *replyItem;

/**
 *	@brief	收藏
 */
@property (nonatomic,readonly) DetailToolbarItem *favoriteItem;

/**
 *	@brief	分享
 */
@property (nonatomic,readonly) DetailToolbarItem *shareItem;


@end
