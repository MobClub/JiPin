//
//  ContentViewController.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
#import <SinaWeiboConnection/SSSinaWeiboStatus.h>
#import <AGCommon/CMRefreshTableHeaderView.h>
#import "SinaWeiboCommentCell.h"
#import "ReplyViewController.h"
#import "DetailToolbar.h"

@class ContentViewController;
@class AGSinaWeiboStatusCell;

@protocol ContentViewControllerDelegate <NSObject>

/**
 *	@brief	更新微博信息
 *
 *	@param 	contentViewController 	内容视图控制器
 *	@param 	oldStatus 	旧微博信息
 *	@param 	newStatus 	新微博信息
 */
- (void)contentViewController:(ContentViewController *)contentViewController
                 updateStatus:(SSSinaWeiboStatusInfoReader *)oldStatus
                    newStatus:(SSSinaWeiboStatusInfoReader *)newStatus;


@end

/**
 *	@brief	微博内容视图控制器
 */
@interface ContentViewController : UIViewController <UITableViewDataSource,
                                                     UITableViewDelegate,
                                                     CMRefreshTableHeaderDelegate>
{
@private
    UITableView *_tableView;
    AGSinaWeiboStatusCell *_statusCell;
    SinaWeiboCommentCell *_commentCell;
    CMRefreshTableHeaderView *_refreshTableHeaderView;
//    UIBarButtonItem *_favBarButtonItem;
    DetailToolbar *_toolbar;
    
    SSSinaWeiboStatusInfoReader *_status;
    NSMutableArray *_comments;
    NSMutableDictionary *_heightDict;
    BOOL _initialized;
    CMImageCacheManager *_imageCacheManager;
    CMImageLoader *_picLoader;
    NSInteger _page;
    BOOL _hasNext;
    BOOL _isGetting;
    BOOL _refreshData;
    BOOL _didLoadComment;
    id<ContentViewControllerDelegate> _delegate;
}

/**
 *	@brief	视图委托
 */
@property (nonatomic,assign) id<ContentViewControllerDelegate> delegate;


/**
 *	@brief	初始化视图控制器
 *
 *	@param 	status 	微博信息
 *  @param  imageCacheManager   图片缓存管理器
 *
 *	@return	视图控制器
 */
- (id)initWithStatus:(SSSinaWeiboStatusInfoReader *)status imageCacheManager:(CMImageCacheManager *)imageCacheManager;

@end
