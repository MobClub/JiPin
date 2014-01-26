//
//  FavViewController.m
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "FavViewController.h"
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import <SinaWeiboConnection/SinaWeiboConnection.h>
#import <SinaWeiboConnection/SSSinaWeiboStatus.h>
#import "AGSinaWeiboMoreCell.h"
#import "AGSinaWeiboFriendsViewController.h"
#import "AGSinaWeiboUserDetailInfoViewController.h"
#import "AGSinaWeiboPictureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SinaWeiboFavorite.h"
#import "ReplyViewController.h"
#import "ContentViewController.h"
#import "UILabel+AGJiPinConfig.h"
#import "AGCurrentUserIconView.h"
#import <AGCommon/NSString+Common.h>

@implementation FavViewController

#define WEIBO_CELL @"weiboCell"
#define MORE_CELL @"moreCell"
#define HEADER_HEIGHT 145


- (id)init
{
    self = [super init];
    if (self)
    {
        
        _imageCacheManager = [[CMImageCacheManager alloc] init];
        _statusArray = [[NSMutableArray alloc] init];
        _heightDict = [[NSMutableDictionary alloc] init];
        _statusCell = [[AGSinaWeiboStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:WEIBO_CELL
                                                 imageCacheManager:_imageCacheManager];
        
        // initialize the left side view control button
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [leftBtn setImage:[UIImage imageNamed:@"LeftSideControlButton.png"]
                 forState:UIControlStateNormal];
        [leftBtn addTarget:self
                    action:@selector(leftButtonClickHandler:)
          forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
        [leftBtn release];
        
        AGCurrentUserIconView *iconView = [[AGCurrentUserIconView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 45.0f, 30.0f)];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:iconView] autorelease];
        [iconView release];
        
        self.title = @"收藏";

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label applyStyle:[AGJiPinStyle NavigationBarTitleStyle]];
        label.textAlignment = NSTextAlignmentCenter; // ^-Use UITextAlignmentCenter for older SDKs.
        label.text = self.title;
        self.navigationItem.titleView = label;
        [label sizeToFit];
        [label release];
    }
    return self;
}

- (void)dealloc
{
    //对数据进行缓存
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    _refreshTableHeaderView = nil;
    
    SAFE_RELEASE(_imageCacheManager);
    SAFE_RELEASE(_statusArray);
    SAFE_RELEASE(_heightDict);
    SAFE_RELEASE(_statusCell);
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData];

    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, self.view.height)
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView release];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutView:self.interfaceOrientation];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (!_initialized)
    {
        _initialized = YES;
        
        [self getFavoritesWithPage:1];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

-(BOOL)shouldAutorotate
{
    //iOS6下旋屏方法
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //iOS6下旋屏方法
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutView:toInterfaceOrientation];
}

#pragma mark - Private

/**
 *	@brief	显示侧栏按钮点击
 *
 *	@param 	sender 	事件对象
 */
- (void)leftButtonClickHandler:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)layoutPortrait
{
    UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    btn.frame = CGRectMake(btn.left, btn.top, 55.0, 32.0);
    [btn setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"
                                     bundleName:BUNDLE_NAME]
                   forState:UIControlStateNormal];
    
    if ([UIDevice currentDevice].isPad)
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
    }
}

- (void)layoutLandscape
{
    if (![UIDevice currentDevice].isPad)
    {
        //iPhone
        UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        btn.frame = CGRectMake(btn.left, btn.top, 48.0, 24.0);
        [btn setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"
                                         bundleName:BUNDLE_NAME]
                       forState:UIControlStateNormal];
        
        if ([[UIDevice currentDevice] isPhone5])
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
        }
        else
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
        }
    }
    else
    {
        UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        btn.frame = CGRectMake(btn.left, btn.top, 55.0, 32.0);
        [btn setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"
                                         bundleName:BUNDLE_NAME]
                       forState:UIControlStateNormal];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
    }
}

- (void)layoutView:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self layoutLandscape];
    }
    else
    {
        [self layoutPortrait];
    }
}

- (void)getFavoritesWithPage:(NSInteger)page
{
    if (!_isGetting)
    {
        _isGetting = YES;
        
        id<ISSSinaWeiboApp> sinaWeiboApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
        id<ISSCParameters> params = [ShareSDKCoreService parameters];
        [params addParameter:@"page" value:[NSNumber numberWithInteger:page]];
        
        [sinaWeiboApp api:@"https://api.weibo.com/2/favorites.json"
                   method:SSSinaWeiboRequestMethodGet
                   params:params
                     user:nil
                   result:^(id responder) {
                       //结束下拉
                       _refreshData = NO;
                       [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:_tableView];
                       
                       _isGetting = NO;
                       _page = page;
                       
                       if (page == 1)
                       {
                           [_statusArray removeAllObjects];
                           [_heightDict removeAllObjects];
                       }
                       
                       id value = [responder objectForKey:@"favorites"];
                       if ([value isKindOfClass:[NSArray class]])
                       {
                           for (int i = 0; i < [value count]; i++)
                           {
                               id item = [value objectAtIndex:i];
                               if ([item isKindOfClass:[NSDictionary class]])
                               {
                                   SinaWeiboFavorite *favorite = [SinaWeiboFavorite favoriteWithResponse:item];
                                   [_statusArray addObject:favorite];
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
                                   _hasNext = [value integerValue] > [_statusArray count] ? YES : NO;
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
                       
                       
                       [_tableView reloadData];
                   }
                    fault:^(CMErrorInfo *error) {
                        _isGetting = NO;
                        //结束下拉
                        _refreshData = NO;
                        [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:_tableView];
                    }];
    }
    
}

- (void)refreshData
{
    _isGetting = NO;
    //获取微博列表
    [self getFavoritesWithPage:1];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hasNext)
    {
        return [_statusArray count] + 1;
    }
    
    return [_statusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row < [_statusArray count])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:WEIBO_CELL];
        if (cell == nil)
        {
            cell = [[[AGSinaWeiboStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:WEIBO_CELL
                                               imageCacheManager:_imageCacheManager]
                    autorelease];
        }
        
        ((AGSinaWeiboStatusCell *)cell).status = ((SinaWeiboFavorite *)[_statusArray objectAtIndex:indexPath.row]).status;
        ((AGSinaWeiboStatusCell *)cell).delegate = self;
    }
    else
    {
        //创建获取更多单元格
        cell = [tableView dequeueReusableCellWithIdentifier:MORE_CELL];
        if (cell == nil)
        {
            cell = [[[AGSinaWeiboMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MORE_CELL] autorelease];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *rowNumber = [NSNumber numberWithInteger:indexPath.row];
    if ([_heightDict objectForKey:rowNumber])
    {
        return [[_heightDict objectForKey:rowNumber] floatValue];
    }
    else
    {
        if (indexPath.row < [_statusArray count])
        {
            CGFloat cellHeight = [_statusCell layoutThatStaus:((SinaWeiboFavorite *)[_statusArray objectAtIndex:indexPath.row]).status isCalCellHeight:YES];
            [_heightDict setObject:[NSNumber numberWithFloat:cellHeight] forKey:rowNumber];
            
            return cellHeight;
        }
        
        return tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[AGSinaWeiboMoreCell class]])
    {
        //加载下一页
        if (_hasNext)
        {
            [self getFavoritesWithPage:_page + 1];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_statusArray count])
    {
        ContentViewController *contentVC = [[[ContentViewController alloc] initWithStatus:((SinaWeiboFavorite *)[_statusArray objectAtIndex:indexPath.row]).status imageCacheManager:_imageCacheManager] autorelease];
        contentVC.delegate = self;
        [self.navigationController pushViewController:contentVC animated:YES];
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

#pragma mark - AGSinaWeiboStatusCellDelegate

- (void)cell:(AGSinaWeiboStatusCell *)cell onShowPic:(NSString *)url
{
    AGSinaWeiboPictureViewController *picViewController = [[[AGSinaWeiboPictureViewController alloc] initWithImageUrl:url
                                                                                                    imageCacheManager:_imageCacheManager]
                                                           autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:picViewController] autorelease];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)cell:(AGSinaWeiboStatusCell *)cell
 onOperation:(AGSinaWeiboOperation)operation
   forStatus:(SSSinaWeiboStatusInfoReader *)status
{
    switch (operation) {
        case AGSinaWeiboComment: {
            ReplyViewController *vc = [[[ReplyViewController alloc] initWithStatus:status
                                                                              type:ReplyViewControllerTypeComment
                                                                   commentComplete:nil] autorelease];
            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
            [self presentModalViewController:navController animated:YES];
            break;
        }
        case AGSinaWeiboReply: {
            ReplyViewController *vc = [[[ReplyViewController alloc] initWithStatus:status
                                                                              type:ReplyViewControllerTypeReply
                                                                   commentComplete:nil] autorelease];
            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
            [self presentModalViewController:navController animated:YES];
            break;
        }
        case AGSinaWeiboAddFavor: {
            id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
            id<ISSCParameters> params = [ShareSDKCoreService parameters];
            [params addParameter:@"id" value:status.idstr];

            NSString *favDestroyURL = @"https://api.weibo.com/2/favorites/destroy.json";
            NSString *favCreateURL = @"https://api.weibo.com/2/favorites/create.json";
            NSString *actionURLString = [status favorited] ? favDestroyURL : favCreateURL;
            
            [sinaApp api:actionURLString
                  method:SSSinaWeiboRequestMethodPost
                  params:params
                    user:nil
                  result:^(id responder) {
                      [self refreshData];
                      NSString *msgStr = @"已经取消收藏";
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                          message:msgStr
                                                                         delegate:nil
                                                                cancelButtonTitle:@"知道了"
                                                                otherButtonTitles:nil];
                      [alertView show];
                      [alertView release];
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
            break;
        }

        case AGSinaWeiboShare:
        {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate shareStatus:status];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - ContentViewControllerDelegate

- (void)contentViewController:(ContentViewController *)contentViewController
                 updateStatus:(SSSinaWeiboStatus *)oldStatus
                    newStatus:(SSSinaWeiboStatus *)newStatus
{
    //刷新收藏列表
    [self getFavoritesWithPage:1];
}

@end
