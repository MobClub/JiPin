//
//  MoreViewController.m
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "MoreViewController.h"
#import <AGCommon/UIColor+Common.h>
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
#import "Appirater.h"
#import "LoginViewController.h"
#import "AGAuthViewController.h"
#import "AppDelegate.h"
#import "UILabel+AGJiPinConfig.h"

#define TABLE_CELL @"tableCell"

static NSString *TABLE_CELL_CONTENT_FONT = @"STHeitiSC-Medium";

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        self.title = @"设置";
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setFrame:CGRectMake(0.0f, 0.0f, 45.0f, 30.0f)];
        [leftBtn setImage:[UIImage imageNamed:@"LeftSideControlButton.png"]
                 forState:UIControlStateNormal];
        [leftBtn addTarget:self
                    action:@selector(leftButtonClickHandler:)
          forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
        [leftBtn release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label applyStyle:[AGJiPinStyle NavigationBarTitleStyle]];
        label.textAlignment = NSTextAlignmentCenter;  // ^-Use UITextAlignmentCenter for older SDKs.
        label.text = self.title;
        self.navigationItem.titleView = label;
        [label sizeToFit];
        [label release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, self.view.height)
                                              style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.sectionHeaderHeight = 32;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (void)leftButtonClickHandler:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 2;
        case 3:
            return 4;
        default:
            return 0;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier]
                autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:TABLE_CELL_CONTENT_FONT size:16.0];
        cell.textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        cell.backgroundColor = tableView.backgroundColor;
    }
    
    NSUInteger row = indexPath.row;
	NSUInteger section=indexPath.section;
    
	switch (section)
    {
        case 0:
            
			if (row == 0)
            {
                id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
                cell.textLabel.text = [[sinaApp currentUser] nickname];
                
                if ([[sinaApp currentUser].uid isEqualToString:USER_ID])
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
			}
			break;
		case 1:
            cell.textLabel.text = @"分享设置";
			break;
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"新浪微博";
                    break;
                case 1:
                    cell.textLabel.text = @"腾讯微博";
                    break;
                default:
                    break;
            }
            
			break;
        }
		case 3:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"将APP推荐给好友";
                    break;
                case 1:
                    cell.textLabel.text = @"到AppStore评分";
                    break;
                case 2:
                {
                    NSBundle *bundle = [NSBundle mainBundle];
                    cell.textLabel.text = [NSString stringWithFormat:
                                           @"当前版本%@",
                                           [[bundle infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
                    break;
                }
                default:
                    break;
            }

			break;
        }
		default:
			break;
	}
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = @[@"用户资料", @"系统设置", @"关注我们", @"关于我们"];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenRect.size.width, 44.0)] autorelease];
    //headerView.contentMode = UIViewContentModeScaleToFill;
    
    if (section < [titleArray count])
    {
        // Add the label
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, -5.0, screenRect.size.width, 44.0)];
        headerLabel.opaque = NO;
        headerLabel.text = titleArray[section];
        [headerLabel applyStyle:[AGJiPinStyle TableSectionHeaderTitleStyle]];
        //headerLabel.shadowColor = [UIColor clearColor];
        //headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        headerLabel.numberOfLines = 0;
        headerLabel.textAlignment = UITextAlignmentLeft;
        [headerView addSubview: headerLabel];
        [headerLabel release];
    }
    
    // Return the headerView
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
    
	NSUInteger row = indexPath.row;
	NSUInteger section=indexPath.section;
	switch (section)
    {
        case 0:
            
			if (row == 0)
            {
                if (![[sinaApp currentUser].uid isEqualToString:USER_ID])
                {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"取消"
                                                               destructiveButtonTitle:@"注销用户"
                                                                    otherButtonTitles:nil];
                    [actionSheet showInView:self.view];
                    [actionSheet release];
                }
			}
			break;
		case 1:
            
			if (row == 0)
            {
                
                AGAuthViewController *auth = [[[AGAuthViewController alloc] init] autorelease];
                [self.navigationController pushViewController:auth animated:YES];
			}
			break;
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    if ([[sinaApp currentUser].uid isEqualToString:USER_ID])
                    {
                        [ShareSDK authWithType:ShareTypeSinaWeibo
                                       options:appDelegate.authOptions
                                        result:^(SSAuthState state, id<ICMErrorInfo> error) {
                                            
                                            if (state == SSAuthStateSuccess)
                                            {
                                                //关注新浪微博
                                                [ShareSDK followUserWithType:ShareTypeSinaWeibo
                                                                       field:@"ShareSDK"
                                                                   fieldType:SSUserFieldTypeName
                                                                 authOptions:appDelegate.authOptions
                                                                viewDelegate:nil
                                                                      result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                                                          
                                                                          switch (state) {
                                                                              case SSResponseStateSuccess:
                                                                              {
                                                                                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                                                      message:@"关注成功"
                                                                                                                                     delegate:nil
                                                                                                                            cancelButtonTitle:@"知道了"
                                                                                                                            otherButtonTitles:nil];
                                                                                  [alertView show];
                                                                                  [alertView release];
                                                                                  break;
                                                                              }
                                                                              case SSResponseStateFail:
                                                                              {
                                                                                  if ([error errorCode] != -103)
                                                                                  {
                                                                                      
                                                                                      NSString *msgString = nil;
                                                                                      if ([error errorCode] == 20506)
                                                                                      {
                                                                                          msgString = @"您已关注过官方新浪微博!";
                                                                                      }
                                                                                      else
                                                                                      {
                                                                                          msgString = @"关注失败!";
                                                                                      }
                                                                                      
                                                                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                                                          message:msgString
                                                                                                                                         delegate:nil
                                                                                                                                cancelButtonTitle:@"知道了"
                                                                                                                                otherButtonTitles:nil];
                                                                                      [alertView show];
                                                                                      [alertView release];
                                                                                  }
                                                                                  break;
                                                                              }
                                                                              default:
                                                                                  break;
                                                                          }
                                                                      }];
                                            }
                                            
                                        }];
                        
                    }
                    break;
                }
                case 1:
                {

                    //关注腾讯微博
                    [ShareSDK followUserWithType:ShareTypeTencentWeibo
                                           field:@"ShareSDK"
                                       fieldType:SSUserFieldTypeName
                                     authOptions:appDelegate.authOptions
                                    viewDelegate:nil
                                          result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                              
                                              switch (state) {
                                                  case SSResponseStateSuccess:
                                                  {
                                                      
                                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                          message:@"关注成功"
                                                                                                         delegate:nil
                                                                                                cancelButtonTitle:@"知道了"
                                                                                                otherButtonTitles:nil];
                                                      [alertView show];
                                                      [alertView release];
                                                      
                                                      break;
                                                  }
                                                  case SSResponseStateFail:
                                                  {
                                                      if ([error errorCode] != -103)
                                                      {
                                                          NSString *msgString = nil;
                                                          
                                                          if ([error errorCode] == 80103)
                                                          {
                                                              msgString = @"您已关注官方腾讯微博";
                                                          }
                                                          else
                                                          {
                                                              msgString = @"关注失败";
                                                          }
                                                          
                                                          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                              message:msgString
                                                                                                             delegate:nil
                                                                                                    cancelButtonTitle:@"知道了"
                                                                                                    otherButtonTitles:nil];
                                                          [alertView show];
                                                          [alertView release];
                                                      }
                                                      
                                                      break;
                                                  }
                                                  default:
                                                      break;
                                              }
                                              
                                          }];
                    break;
                }
                default:
                    break;
            }
			break;
        }
		case 3:
        {
            switch (indexPath.row)
            {
                case 0:
                    
                    break;
                case 1:
                    [Appirater rateApp];
                    break;
                default:
                    break;
            }
            
            break;
        }
		default:
			break;
	}

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //注销用户
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        
        UINavigationController *navController = (UINavigationController *)self.viewDeckController.centerController;
        self.viewDeckController.enabled = NO;
        [navController setNavigationBarHidden:YES];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:navController.viewControllers];
        LoginViewController *vc = [[LoginViewController alloc] init];
        [viewControllers insertObject:vc atIndex:1];
        [vc release];
        navController.viewControllers = viewControllers;
        
        [navController popViewControllerAnimated:YES];
    }
}

@end
