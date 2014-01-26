//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import "AGSinaWeiboListViewController.h"
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
#import "UILabel+AGJiPinConfig.h"
#import "AGCurrentUserIconView.h"
#import "ReplyViewController.h"
#import <AGCommon/NSString+Common.h>

#define WEIBO_CELL @"weiboCell"
#define MORE_CELL @"moreCell"
#define HEADER_HEIGHT 145

#define CACHE_NAME @"%@/sinaweibo_%@_timeline"

@implementation AGSinaWeiboListViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        _imageCacheManager = _appDelegate.imageCacheManager;
        _statusArray = [[NSMutableArray alloc] init];
        _heightDict = [[NSMutableDictionary alloc] init];
        _statusCell = [[AGSinaWeiboStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:WEIBO_CELL
                                                 imageCacheManager:_imageCacheManager];

        // initialize the left side view control button
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setFrame:CGRectMake(0.0f, 0.0f, 45.0f, 30.0f)];
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

        [self setTitleView];

    }
    return self;
}

- (void)dealloc
{
    _appDelegate = nil;
    _statusesTableView.delegate = nil;
    _statusesTableView.dataSource = nil;
    _statusesTableView = nil;
    _headerView = nil;
    _refreshTableHeaderView = nil;

    SAFE_RELEASE(_statusArray);
    SAFE_RELEASE(_heightDict);
    SAFE_RELEASE(_statusCell);
    SAFE_RELEASE(_user);

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self refreshData];

    if (!_initialized)
    {
        //读取缓存
        @try
        {
            NSString *cachePath = [NSString stringWithFormat:CACHE_NAME, NSTemporaryDirectory(), TARGET_USER_NAME];
            NSDictionary *cacheDict = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
            if ([cacheDict isKindOfClass:[NSDictionary class]])
            {
                id value = [cacheDict objectForKey:@"user"];
                if ([value isKindOfClass:[SSSinaWeiboUser class]])
                {
                    _user = [value retain];
                }

                value = [cacheDict objectForKey:@"status"];
                if ([value isKindOfClass:[NSArray class]])
                {
                    [_statusArray addObjectsFromArray:value];
                }

                value = [cacheDict objectForKey:@"hasnext"];
                if ([value isKindOfClass:[NSNumber class]])
                {
                    _hasNext = [value boolValue];
                }

                value = [cacheDict objectForKey:@"page"];
                if ([value isKindOfClass:[NSNumber class]])
                {
                    _page = [value integerValue];
                }
            }
        }
        @catch (NSException *exception) {

        }
    }

    _statusesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, self.view.height)
                                                      style:UITableViewStylePlain];
    _statusesTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _statusesTableView.delegate = self;
    _statusesTableView.dataSource = self;
    _statusesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_statusesTableView];
    [_statusesTableView release];

    //下拉刷新
    _refreshTableHeaderView = [[CMRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                         0.0f - _statusesTableView.bounds.size.height,
                                                                                         self.view.width,
                                                                                         _statusesTableView.bounds.size.height)
                                                                   arrowImage:[UIImage imageNamed:@"blueArrow.png"]
                                                                    textColor:nil];
    _refreshTableHeaderView.delegate = self;
    [_statusesTableView addSubview:_refreshTableHeaderView];
    [_refreshTableHeaderView refreshLastUpdatedDate];
    [_refreshTableHeaderView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self layoutView:self.interfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!_initialized)
    {
        _initialized = YES;

        if (!_user)
        {
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                                    field:TARGET_USER_NAME
                                fieldType:SSUserFieldTypeName
                              authOptions:_appDelegate.authOptions
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                       if (result)
                                       {
                                           SAFE_RELEASE(_user);
                                           _user = [userInfo retain];
                                           
                                           SSSinaWeiboUserInfoReader *reader = [SSSinaWeiboUserInfoReader readerWithSourceData:[_user sourceData]];
                                           [_headerView setUserInfo:reader];

                                           //获取微博列表
                                           [self getTimelineWithPage:1];
                                       }
                                   }];
        }
        else if ([_statusArray count] == 0)
        {
            [_headerView setUserInfo:_user];
            [self getTimelineWithPage:1];
        }
        else
        {
            [_headerView setUserInfo:_user];
            [_statusesTableView reloadData];
        }
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

- (void)setTitleView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WeiboListTitle.png"]];
    self.navigationItem.titleView = imageView;
    [imageView release];
}

- (void)cancelButtonClickHandler:(id)sender
{
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)layoutPortrait
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
}

- (void)layoutLandscape
{

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

- (void)getTimelineWithPage:(NSInteger)page
{
    if (!_isGetting)
    {
        _isGetting = YES;

        id<ISSSinaWeiboApp> sinaWeiboApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
        id<ISSCParameters> params = [ShareSDKCoreService parameters];
        [params addParameter:@"page" value:[NSNumber numberWithInteger:page]];
        [params addParameter:@"uid" value:[_user uid]];

        [sinaWeiboApp api:@"https://api.weibo.com/2/statuses/user_timeline.json"
                   method:SSSinaWeiboRequestMethodGet
                   params:params
                     user:nil
                   result:^(id responder) {
                       _isGetting = NO;
                       _page = page;

                       if (page == 1)
                       {
                           [_statusArray removeAllObjects];
                           [_heightDict removeAllObjects];
                       }

                       id value = [responder objectForKey:@"statuses"];
                       if ([value isKindOfClass:[NSArray class]])
                       {
                           for (int i = 0; i < [value count]; i++)
                           {
                               id item = [value objectAtIndex:i];
                               if ([item isKindOfClass:[NSDictionary class]])
                               {
                                   SSSinaWeiboStatus *status = [SSSinaWeiboStatus statusWithResponse:item];
                                   [_statusArray addObject:status];
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

                       //对数据进行缓存
                       NSDictionary *cacheData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  _user,
                                                  @"user",
                                                  _statusArray,
                                                  @"status",
                                                  [NSNumber numberWithBool:_hasNext],
                                                  @"hasnext",
                                                  [NSNumber numberWithInt:_page],
                                                  @"page",
                                                  nil];
                       [NSKeyedArchiver archiveRootObject:cacheData toFile:[NSString stringWithFormat:CACHE_NAME, NSTemporaryDirectory(), TARGET_USER_NAME]];

                       [_statusesTableView reloadData];
                   }
                    fault:^(CMErrorInfo *error) {
                        _isGetting = NO;
                    }];
    }

}

- (void)refreshData
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                            field:TARGET_USER_NAME
                        fieldType:SSUserFieldTypeName
                      authOptions:_appDelegate.authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   SAFE_RELEASE(_user);
                                   _user = [userInfo retain];
                                   
                                   SSSinaWeiboUserInfoReader *reader = [SSSinaWeiboUserInfoReader readerWithSourceData:[_user sourceData]];
                                   [_headerView setUserInfo:reader];

                                   //获取微博列表
                                   [self getTimelineWithPage:1];
                               }

                               _isGetting = NO;

                               //结束下拉
                               _refreshData = NO;
                               [_refreshTableHeaderView refreshScrollViewDataSourceDidFinishedLoading:_statusesTableView];
                           }];

}

- (void)friendsButtonClickHandler:(id)sender
{
    AGSinaWeiboFriendsViewController *vc = [[[AGSinaWeiboFriendsViewController alloc] initWithType:AGSinaWeiboFriendsTypeFriend
                                                                                          userName:TARGET_USER_NAME
                                                                                 imageCacheManager:_imageCacheManager]
                                            autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentViewController:navController animated:YES completion:nil];

}

- (void)followerButtonClickHandler:(id)sender
{
    AGSinaWeiboFriendsViewController *vc = [[[AGSinaWeiboFriendsViewController alloc] initWithType:AGSinaWeiboFriendsTypeFollower
                                                                                          userName:TARGET_USER_NAME
                                                                                 imageCacheManager:_imageCacheManager]
                                            autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)infoButtonClickHandler:(id)sender
{
    AGSinaWeiboUserDetailInfoViewController *vc = [[[AGSinaWeiboUserDetailInfoViewController alloc] initWithUser:_user] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)addFavorite:(SSSinaWeiboStatusInfoReader *)status
{
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
              
              id value = [responder objectForKey:@"status"];
              if ([value isKindOfClass:[NSDictionary class]])
              {
                  SSSinaWeiboStatus *newStatus = [SSSinaWeiboStatus statusWithResponse:value];
                  NSUInteger index = [_statusArray indexOfObject:status];
                  if (index != NSNotFound)
                  {
                      [_statusArray replaceObjectAtIndex:index withObject:newStatus];
                  }
                  
              }
              
              [_statusesTableView reloadData];
              NSString *msgStr = @"微博收藏成功";
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
        
        SSSinaWeiboStatus *status = [_statusArray objectAtIndex:indexPath.row];
        SSSinaWeiboStatusInfoReader *reader = [SSSinaWeiboStatusInfoReader readerWithSourceData:[status sourceData]];
        
        ((AGSinaWeiboStatusCell *)cell).status = reader;
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
            SSSinaWeiboStatus *status = [_statusArray objectAtIndex:indexPath.row];
            SSSinaWeiboStatusInfoReader *reader = [SSSinaWeiboStatusInfoReader readerWithSourceData:[status sourceData]];
            
            CGFloat cellHeight = [_statusCell layoutThatStaus:reader isCalCellHeight:YES];
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
            [self getTimelineWithPage:_page + 1];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_statusArray count])
    {
        SSSinaWeiboStatus *status = [_statusArray objectAtIndex:indexPath.row];
        SSSinaWeiboStatusInfoReader *reader = [SSSinaWeiboStatusInfoReader readerWithSourceData:[status sourceData]];
        
        ContentViewController *contentVC = [[[ContentViewController alloc] initWithStatus:reader imageCacheManager:_imageCacheManager] autorelease];
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
        case AGSinaWeiboComment:
        {
            ReplyViewController *vc = [[[ReplyViewController alloc] initWithStatus:status
                                                                              type:ReplyViewControllerTypeComment
                                                                   commentComplete:nil] autorelease];
            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
            [self presentModalViewController:navController animated:YES];
            break;
        }
        case AGSinaWeiboReply:
        {
            ReplyViewController *vc = [[[ReplyViewController alloc] initWithStatus:status
                                                                              type:ReplyViewControllerTypeReply
                                                                   commentComplete:nil] autorelease];
            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
            [self presentModalViewController:navController animated:YES];
            break;
        }
        case AGSinaWeiboAddFavor:
        {
            id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
            if ([[sinaApp currentUser].uid isEqualToString:USER_ID])
            {
                [ShareSDK authWithType:ShareTypeSinaWeibo options:_appDelegate.authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
                   
                    if (state == SSAuthStateSuccess)
                    {
                        [self addFavorite:status];
                    }
                    
                }];
            }
            else
            {
                [self addFavorite:status];
            }
            
            break;
        }
        case AGSinaWeiboShare:
        {
            [_appDelegate shareStatus:status];
            break;
        }
        default:
            break;
    }
}

#pragma mark - AGSinaWeiboUserInfoHeaderViewDelegate

- (void)headerViewOnAddFriend:(AGSinaWeiboUserInfoHeaderView *)headerView
{
    //重新获取用户资料
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                            field:TARGET_USER_NAME
                        fieldType:SSUserFieldTypeName
                      authOptions:_appDelegate.authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   SAFE_RELEASE(_user);
                                   _user = [userInfo retain];
                                   
                                   SSSinaWeiboUserInfoReader *reader = [SSSinaWeiboUserInfoReader readerWithSourceData:[_user sourceData]];
                                   [_headerView setUserInfo:reader];
                               }
                           }];
}

#pragma mark - ContentViewControllerDelegate

- (void)contentViewController:(ContentViewController *)contentViewController
                 updateStatus:(SSSinaWeiboStatus *)oldStatus
                    newStatus:(SSSinaWeiboStatus *)newStatus
{
    NSUInteger index = [_statusArray indexOfObject:oldStatus];
    if (index != NSNotFound)
    {
        [_statusArray replaceObjectAtIndex:index withObject:newStatus];
    }
}

@end
