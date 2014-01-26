//
//  ContentViewController.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "ContentViewController.h"
#import "SinaWeiboComment.h"
#import "AGSinaWeiboMoreCell.h"
#import "UILabel+AGJiPinConfig.h"
#import "AGCurrentUserIconView.h"
#import "AGSinaWeiboStatusCell.h"
#import "AppDelegate.h"
#import "AGSinaWeiboStatusDispLoadingCell.h"
#import "AGSinaWeiboStatusNoCommentCell.h"
#import <AGCommon/NSString+Common.h>

#define STATUS_CELL @"statusCell"
#define COMMENT_CELL @"commentCell"
#define MORE_CELL @"moreCell"

#define TOOLBAR_HEIGHT 50.0

@implementation ContentViewController

@synthesize delegate = _delegate;

- (id)initWithStatus:(SSSinaWeiboStatusInfoReader *)status imageCacheManager:(CMImageCacheManager *)imageCacheManager
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        _didLoadComment = NO;
        
        _imageCacheManager = [imageCacheManager retain];
        _status = [status retain];
        _comments = [[NSMutableArray alloc] init];
        _heightDict = [[NSMutableDictionary alloc] init];
        
        _statusCell = [[AGSinaWeiboStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:STATUS_CELL
                                                 imageCacheManager:_imageCacheManager
                                                showControlButtons:NO];
        _statusCell.showControlBar = NO;
        
        _commentCell = [[SinaWeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:COMMENT_CELL
                                                 imageCacheManager:_imageCacheManager];
        
        //返回按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"BackIcon.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0.0, 0.0, 45.0, 30.0);
        [button addTarget:self action:@selector(backButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
        
        //标题视图
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label applyStyle:[AGJiPinStyle NavigationBarTitleStyle]];
        label.textAlignment = NSTextAlignmentCenter;  // ^-Use UITextAlignmentCenter for older SDKs.
        label.text = @"详情";
        self.navigationItem.titleView = label;
        [label sizeToFit];
        [label release];
        
        //用户头像
        AGCurrentUserIconView *iconView = [[AGCurrentUserIconView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 45.0f, 30.0f)];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:iconView] autorelease];
        [iconView release];
        
        ((AppDelegate *)[UIApplication sharedApplication].delegate).viewController.enabled = NO;
    }
    return self;
}

- (void)dealloc
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).viewController.enabled = YES;
    
    SAFE_RELEASE(_imageCacheManager);
    SAFE_RELEASE(_status);
    SAFE_RELEASE(_comments);
    SAFE_RELEASE(_statusCell);
    SAFE_RELEASE(_heightDict);
    SAFE_RELEASE(_commentCell);
    
    [_picLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_picLoader);
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                               0.0,
                                                               self.view.width,
                                                               self.view.height - TOOLBAR_HEIGHT)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _toolbar = [[DetailToolbar alloc] initWithFrame:CGRectMake(0.0,
                                                               self.view.height - TOOLBAR_HEIGHT,
                                                               self.view.width,
                                                               TOOLBAR_HEIGHT)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_toolbar.commentItem addTarget:self
                             action:@selector(commentButtoClickHandler:)
                   forControlEvents:UIControlEventTouchUpInside];
    [_toolbar.replyItem addTarget:self
                           action:@selector(reportButtonClickHandler:)
                 forControlEvents:UIControlEventTouchUpInside];
    [_toolbar.favoriteItem addTarget:self
                              action:@selector(favButtonClickHandler:)
                    forControlEvents:UIControlEventTouchUpInside];

    _toolbar.favoriteItem.selected = _status.favorited;
    
    [_toolbar.shareItem addTarget:self
                           action:@selector(shareButtonClickHandler:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_toolbar];
    [_toolbar release];
    
    //下拉刷新
    _refreshTableHeaderView = [[CMRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                         0.0f - _tableView.bounds.size.height,
                                                                                         self.view.width,
                                                                                         _tableView.bounds.size.height)
                                                                   arrowImage:[UIImage imageNamed:@"blueArrow.png"]
                                                                    textColor:nil];
    _refreshTableHeaderView.delegate = self;
    [_tableView addSubview:_refreshTableHeaderView];
    [_refreshTableHeaderView refreshLastUpdatedDate];
    [_refreshTableHeaderView release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //获取评论列表
    if (!_initialized)
    {
        _initialized = YES;
        
        //获取评论一页
        [self getCommentsWithPage:1];
    }
}

#pragma mark - Private

/**
 *	@brief	执行分享
 */
- (void)doFavorite
{
    if (_status.favorited)
    {
        //取消收藏
        id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
        id<ISSCParameters> params = [ShareSDKCoreService parameters];
        [params addParameter:@"id" value:_status.idstr];
        
        [sinaApp api:@"https://api.weibo.com/2/favorites/destroy.json"
              method:SSSinaWeiboRequestMethodPost
              params:params
                user:nil
              result:^(id responder) {
                  id value = [responder objectForKey:@"status"];
                  if ([value isKindOfClass:[NSDictionary class]])
                  {
                      SSSinaWeiboStatusInfoReader *status = [SSSinaWeiboStatusInfoReader readerWithSourceData:value];
                      //替换原来的微博信息
                      if ([_delegate conformsToProtocol:@protocol(ContentViewControllerDelegate)] &&
                          [_delegate respondsToSelector:@selector(contentViewController:updateStatus:newStatus:)])
                      {
                          [_delegate contentViewController:self updateStatus:_status newStatus:status];
                      }
                      
                      [status retain];
                      SAFE_RELEASE(_status);
                      _status = status;
                  }
                  _toolbar.favoriteItem.selected = _status.favorited;
              }
               fault:^(CMErrorInfo *error) {
                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                       message:[error errorDescription]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"知道了"
                                                             otherButtonTitles:nil];
                   [alertView show];
                   [alertView release];
               }];
    }
    else
    {
        //收藏
        id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
        id<ISSCParameters> params = [ShareSDKCoreService parameters];
        [params addParameter:@"id" value:_status.idstr];
        
        [sinaApp api:@"https://api.weibo.com/2/favorites/create.json"
              method:SSSinaWeiboRequestMethodPost
              params:params
                user:nil
              result:^(id responder) {
                  id value = [responder objectForKey:@"status"];
                  if ([value isKindOfClass:[NSDictionary class]])
                  {
                      SSSinaWeiboStatusInfoReader *status = [SSSinaWeiboStatusInfoReader readerWithSourceData:value];
                      //替换原来的微博信息
                      if ([_delegate conformsToProtocol:@protocol(ContentViewControllerDelegate)] &&
                          [_delegate respondsToSelector:@selector(contentViewController:updateStatus:newStatus:)])
                      {
                          [_delegate contentViewController:self updateStatus:_status newStatus:status];
                      }
                      
                      [status retain];
                      SAFE_RELEASE(_status);
                      _status = status;
                  }
                  _toolbar.favoriteItem.selected = _status.favorited;
              }
               fault:^(CMErrorInfo *error) {
                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                       message:[error errorDescription]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"知道了"
                                                             otherButtonTitles:nil];
                   [alertView show];
                   [alertView release];
               }];
    }
}

/**
 *	@brief	返回按钮点击
 *
 *	@param 	sender 	事件对象
 */
- (void)backButtonClickHandler:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCommentsWithPage:(NSInteger)page
{
    if (!_isGetting)
    {
        _isGetting = YES;
    
        if (page <= 0)
        {
            page = 1;
        }
        
        id<ISSCParameters> params = [ShareSDKCoreService parameters];
        [params addParameter:@"id" value:_status.idstr];
        [params addParameter:@"page" value:[NSNumber numberWithInteger:page]];
        
        id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
        [sinaApp api:@"https://api.weibo.com/2/comments/show.json"
              method:SSSinaWeiboRequestMethodGet
              params:params
                user:nil
              result:^(id responder) {
                  _isGetting = NO;
                  
                  //结束下拉
                  _refreshData = NO;
                  [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:_tableView];
                  
                  if (page <= 1)
                  {
                      [_comments removeAllObjects];
                  }
                  _page = page;
                  
                  id value = [responder objectForKey:@"comments"];
                  if ([value isKindOfClass:[NSArray class]])
                  {
                      for (int i = 0; i < [value count]; i++)
                      {
                          id item = [value objectAtIndex:i];
                          if ([item isKindOfClass:[NSDictionary class]])
                          {
                              [_comments addObject:[SinaWeiboComment commentWithResponse:item]];
                          }
                      }
                      
                      if ([value count] == 0)
                      {
                          _hasNext = NO;
                      }
                      else
                      {
                          value = [responder objectForKey:@"total_number"];
                          if ([value isKindOfClass:[NSNumber class]])
                          {
                              _hasNext = [value integerValue] > [_comments count] ? YES : NO;
                          }
                          else
                          {
                              _hasNext = NO;
                          }
                      }
                  }
                  else
                  {
                      _hasNext = NO;
                  }

                  _didLoadComment = YES;
                  [_tableView reloadData];
              }
               fault:^(CMErrorInfo *error) {
                   _isGetting = NO;
                   
                   //结束下拉
                   _refreshData = NO;
                   [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:_tableView];
                   
                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                       message:@"加载评论失败!"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"知道了"
                                                             otherButtonTitles:nil];
                   [alertView show];
                   [alertView release];
               }];
    }
}

- (void)refreshData
{                       
    _isGetting = NO;
    [self getCommentsWithPage:1];
}

- (void)commentButtoClickHandler:(id)sender
{
    ReplyViewController *vc = [[[ReplyViewController alloc] initWithStatus:_status
                                                                      type:ReplyViewControllerTypeComment
                                                           commentComplete:^{
                                                               //刷新评论列表
                                                               _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, -65.0);
                                                               [_refreshTableHeaderView refreshScrollViewDidEndDragging:_tableView];
                                                           }]
                               autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
}

- (void)reportButtonClickHandler:(id)sender
{
    ReplyViewController *vc = [[[ReplyViewController alloc] initWithStatus:_status
                                                                      type:ReplyViewControllerTypeReply
                                                           commentComplete:nil]
                               autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentModalViewController:navController animated:YES];
}

- (void)favButtonClickHandler:(id)sender
{
    
    if ([[(id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo] currentUser].uid isEqualToString:USER_ID])
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [ShareSDK authWithType:ShareTypeSinaWeibo options:appDelegate.authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
           
            if (state == SSAuthStateSuccess)
            {
                [self doFavorite];
            }
            
        }];
    }
    else
    {
        [self doFavorite];
    }
}

- (void)shareButtonClickHandler:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate shareStatus:_status];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_didLoadComment)
    {
        return 2;
    }
    else
    {
        if ([_status commentsCount] == 0)
        {
            return 2;
        }
        return (_hasNext ? 2 + [_comments count] : 1 + [_comments count]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0)
    {
        //微博信息
        cell = [tableView dequeueReusableCellWithIdentifier:STATUS_CELL];
        if (cell == nil)
        {
            cell = [[[AGSinaWeiboStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:STATUS_CELL
                                               imageCacheManager:_imageCacheManager
                                              showControlButtons:NO]
                    autorelease];
            ((AGSinaWeiboStatusCell *)cell).showControlBar = NO;
        }
        
        ((AGSinaWeiboStatusCell *)cell).status = _status;
    }
    else
    {
        if (!_didLoadComment)
        {
            static NSString *DISP_LOADING_CELL = @"DISP_LOADING_CELL";
            cell = [tableView dequeueReusableCellWithIdentifier:DISP_LOADING_CELL];
            if (cell == nil)
            {
                cell = [[[AGSinaWeiboStatusDispLoadingCell alloc]
                                initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:DISP_LOADING_CELL
                                title:@"给力地加载评论中…"]
                        autorelease];
            }
        }
        else
        {
            if ([_status commentsCount] > 0)
            {
                if (indexPath.row - 1 < [_comments count])
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_CELL];
                    if (cell == nil)
                    {
                        cell = [[[SinaWeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:COMMENT_CELL
                                                          imageCacheManager:_imageCacheManager]
                                autorelease];
                    }

                    ((SinaWeiboCommentCell *)cell).comment = [_comments objectAtIndex:indexPath.row - 1];
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:MORE_CELL];
                    if (cell == nil)
                    {
                        cell = [[[AGSinaWeiboMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MORE_CELL] autorelease];
                    }
                }
            }
            else
            {
                static NSString *NO_COMMENT_CELL = @"NO_COMMENT_CELL";
                cell = [tableView dequeueReusableCellWithIdentifier:NO_COMMENT_CELL];
                if (cell == nil) {
                    UIImage *image = [UIImage imageNamed:@"NoComment.png"];
                    cell = [[[AGSinaWeiboStatusNoCommentCell alloc]
                                initWithStyle:UITableViewCellStyleDefault
                                image:image
                                reuseIdentifier:NO_COMMENT_CELL]
                            autorelease];
                }
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegte

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [_statusCell layoutThatStaus:_status
                            isCalCellHeight:YES];
    }
    else
    {
        if ([_status commentsCount] == 0 && _didLoadComment)
        {
            UIImage *image = [UIImage imageNamed:@"NoComment.png"];
            CGFloat minHeight = [AGSinaWeiboStatusNoCommentCell minCellHeightWithImage:image];
            CGFloat availableHeight = tableView.height - _statusCell.cellHeight;
            return availableHeight >= minHeight ? availableHeight : minHeight;
        }

        NSNumber *rowNumber = [NSNumber numberWithInteger:indexPath.row - 1];
        if ([_heightDict objectForKey:rowNumber])
        {
            return [[_heightDict objectForKey:rowNumber] floatValue];
        }
        else
        {
            if (indexPath.row - 1 < [_comments count])
            {
                CGFloat cellHeight = [_commentCell layoutThatComment:[_comments objectAtIndex:indexPath.row - 1]
                                                     isCalCellHeight:YES];
                [_heightDict setObject:[NSNumber numberWithFloat:cellHeight] forKey:rowNumber];
                return cellHeight;
            }
        }
    }
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[AGSinaWeiboMoreCell class]])
    {
        //加载下一页
        if (_hasNext)
        {
            [self getCommentsWithPage:_page + 1];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshTableHeaderView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshTableHeaderView refreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - SKRefreshTableHeaderDelegate

- (void)refreshTableHeaderDidTriggerRefresh:(CMRefreshTableHeaderView *)view
{
	_refreshData = YES;
	[self performSelector:@selector(refreshData) withObject:nil];
}

- (BOOL)refreshTableHeaderDataSourceIsLoading:(CMRefreshTableHeaderView *)view
{
	return _refreshData;
}

- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(CMRefreshTableHeaderView *)view
{
	return [NSDate date];
}

@end
