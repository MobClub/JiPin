//
//  FavViewController.h
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import <AGCommon/CMImageCacheManager.h>
#import <AGCommon/CMRefreshTableHeaderView.h>
#import "AGSinaWeiboStatusCell.h"
#import "ContentViewController.h"

@interface FavViewController : UIViewController <UITableViewDataSource,
                                                 UITableViewDelegate,
                                                 CMRefreshTableHeaderDelegate,
                                                 AGSinaWeiboStatusCellDelegate,
                                                 ContentViewControllerDelegate>
{
@private
    BOOL _initialized;
    CMImageCacheManager *_imageCacheManager;
    NSMutableArray *_statusArray;
    NSMutableDictionary *_heightDict;
    BOOL _hasNext;
    NSInteger _page;
    BOOL _isGetting;
    BOOL _refreshData;
    
    UITableView *_tableView;
    AGSinaWeiboStatusCell *_statusCell;
    CMRefreshTableHeaderView *_refreshTableHeaderView;
}

@end
