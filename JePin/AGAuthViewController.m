//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:1955211608
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import "AGAuthViewController.h"
#import <AGCommon/UIImage+Common.h>
#import "AGShareCell.h"
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import "AppDelegate.h"
#import "AGJiPinStyle.h"
#import "UILabel+AGJiPinConfig.h"
#import <SinaWeiboConnection/SinaWeiboConnection.h>

#define TARGET_CELL_ID @"targetCell"
#define BASE_TAG 100

@interface AGAuthViewController (Private)

/**
 *	@brief	用户信息更新
 *
 *	@param 	notif 	通知
 */
- (void)userInfoUpdateHandler:(NSNotification *)notif;


@end

@implementation AGAuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        //监听用户信息变更
        [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                                   target:self
                                   action:@selector(userInfoUpdateHandler:)];
        
        _shareTypeArray = [[NSMutableArray alloc] initWithObjects:
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"新浪微博",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"腾讯微博",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeTencentWeibo],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"搜狐微博",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeSohuWeibo],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"网易微博",
                            @"title",
                            [NSNumber numberWithInteger:ShareType163Weibo],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"豆瓣社区",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeDouBan],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"QQ空间",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeQQSpace],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"Facebook",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeFacebook],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"Twitter",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeTwitter],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"人人网",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeRenren],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"开心网",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeKaixin],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"印象笔记",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeEvernote],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"Pocket",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypePocket],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"Instapaper",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeInstapaper],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"有道云笔记",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeYouDaoNote],
                            @"type",
                            nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"搜狐随身看",
                            @"title",
                            [NSNumber numberWithInteger:ShareTypeSohuKan],
                            @"type",
                            nil],
                           nil];
        
        NSArray *authList = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
        if (authList == nil)
        {
            [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
        }
        else
        {
            for (int i = 0; i < [authList count]; i++)
            {
                NSDictionary *item = [authList objectAtIndex:i];
                for (int j = 0; j < [_shareTypeArray count]; j++)
                {
                    if ([[[_shareTypeArray objectAtIndex:j] objectForKey:@"type"] integerValue] == [[item objectForKey:@"type"] integerValue])
                    {
                        [_shareTypeArray replaceObjectAtIndex:j withObject:[NSMutableDictionary dictionaryWithDictionary:item]];
                        break;
                    }
                }
            }
        }
        
        UIBarButtonItem *leftBarItem;
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [leftButton setImage:[UIImage imageNamed:@"BackIcon.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(cancelButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.frame = CGRectMake(0.0, 0.0, 45.0, 30.0);
        leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        [leftButton release];
        self.navigationItem.leftBarButtonItem = leftBarItem;
        [leftBarItem release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label applyStyle:[AGJiPinStyle NavigationBarTitleStyle]];
        label.textAlignment = NSTextAlignmentCenter;  // ^-Use UITextAlignmentCenter for older SDKs.
        label.text = @"分享设置";
        self.navigationItem.titleView = label;
        [label sizeToFit];
        [label release];
        
        ((AppDelegate *)[UIApplication sharedApplication].delegate).viewController.enabled = NO;
    }
    return self;
}

- (void)dealloc
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).viewController.enabled = YES;
    
    [ShareSDK removeNotificationWithName:SSN_USER_INFO_UPDATE target:self];
    SAFE_RELEASE(_shareTypeArray);
    
    [super dealloc];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    ((UILabel *)self.navigationItem.titleView).text = title;
    [self.navigationItem.titleView sizeToFit];
}

- (void)loadView
{
    [super loadView];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, self.view.height)
                                               style:UITableViewStyleGrouped];
    _tableView.rowHeight = 50.0;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutView:self.interfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    //iOS6下旋屏方法
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //iOS6下旋屏方法
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutView:toInterfaceOrientation];
}

- (void)authSwitchChangeHandler:(UISwitch *)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSInteger index = sender.tag - BASE_TAG;
    
    if (index < [_shareTypeArray count])
    {
        NSMutableDictionary *item = [_shareTypeArray objectAtIndex:index];
        if (sender.on)
        {
            //用户用户信息
            ShareType type = [[item objectForKey:@"type"] integerValue];
            
            if (type == ShareTypeSinaWeibo &&
                [[(id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo] currentUser].uid isEqualToString:USER_ID])
            {
                [ShareSDK authWithType:ShareTypeSinaWeibo
                               options:appDelegate.authOptions
                                result:^(SSAuthState state, id<ICMErrorInfo> error) {
                                    
                                    [ShareSDK getUserInfoWithType:type
                                                      authOptions:appDelegate.authOptions
                                                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                                               
                                                               if (result)
                                                               {
                                                                   [item setObject:[userInfo nickname] forKey:@"username"];
                                                                   [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                                               }
                                                               NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
                                                               [_tableView reloadData];
                                                           }];
                                    
                                }];
            }
            else
            {
                [ShareSDK getUserInfoWithType:type
                                  authOptions:appDelegate.authOptions
                                       result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                           
                                           if (result)
                                           {
                                               [item setObject:[userInfo nickname] forKey:@"username"];
                                               [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                           }
                                           NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
                                           [_tableView reloadData];
                                       }];
            }
        }
        else
        {
            //取消授权
            [ShareSDK cancelAuthWithType:[[item objectForKey:@"type"] integerValue]];
            [_tableView reloadData];
        }
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shareTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TARGET_CELL_ID];
    if (cell == nil)
    {
        cell = [[[AGShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TARGET_CELL_ID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *switchCtrl = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchCtrl sizeToFit];
        [switchCtrl addTarget:self action:@selector(authSwitchChangeHandler:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchCtrl;
        [switchCtrl release];
    }
    
    if (indexPath.row < [_shareTypeArray count])
    {
        NSDictionary *item = [_shareTypeArray objectAtIndex:indexPath.row];
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:
                                            @"Icon/sns_icon_%d.png",
                                            [[item objectForKey:@"type"] integerValue]]
                                bundleName:BUNDLE_NAME];
        cell.imageView.image = img;
        
        ((UISwitch *)cell.accessoryView).on = [ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]];
        if ([[item objectForKey:@"type"] integerValue] == ShareTypeSinaWeibo &&
            [[(id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo] currentUser].uid isEqualToString:USER_ID])
        {
            //如果为预设账号，需要设置状态为未授权
            ((UISwitch *)cell.accessoryView).on = NO;
        }
        
        ((UISwitch *)cell.accessoryView).tag = BASE_TAG + indexPath.row;
        
        if (((UISwitch *)cell.accessoryView).on)
        {
            cell.textLabel.text = [item objectForKey:@"username"];
        }
        else
        {
            cell.textLabel.text = @"尚未授权";
        }
    }
    
    return cell;
}

#pragma mark - Private

- (void)cancelButtonClickHandler:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    
    for (int i = 0; i < [_shareTypeArray count]; i++)
    {
        NSMutableDictionary *item = [_shareTypeArray objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            [_tableView reloadData];
        }
    }
}

- (void)layoutPortrait
{
    
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

@end
