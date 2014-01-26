//
//  MoreViewController.h
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>

@interface MoreViewController : UIViewController <UITableViewDataSource,
                                                  UITableViewDelegate,
                                                  UIActionSheetDelegate,
                                                  MBProgressHUDDelegate>
{
    UITableView *_tableView;
    NSTimer *timer;
    MBProgressHUD *HUD;
    
    NSMutableArray *_shareTypeArray;
}

@end
