//
//  LeftSideViewController.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "LeftSideViewController.h"
#import <AGCommon/UIColor+Common.h>
#import "LeftSideUserInfoCell.h"
#import "LeftSideItemCell.h"
#import "IIViewDeckController.h"
#import "RootViewController.h"
#import <AGCommon/NSString+Common.h>

#define PADDING_TOP 10.0
#define TITLE_HEIGHT 40.0
#define ITEM_CELL @"itemCell"
#define USER_INFO_CELL @"userInfoCell"
#define APP_RECOMMEND_CELL @"appRecommendCell"
#define APP_ITEM_CELL @"appItemCell"

@implementation LeftSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGB:0x2a2a2a];
    
    CGFloat top = 0.0;
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        top = 20;
    }
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.0, top, self.view.width, self.view.height - top)
                               
                                                           style:UITableViewStylePlain]
                                 autorelease];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 27;
    [self.view addSubview:tableView];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return 3;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:USER_INFO_CELL];
            if (cell == nil)
            {
                cell = [[[LeftSideUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:USER_INFO_CELL] autorelease];
                cell.backgroundColor = [UIColor clearColor];
            }
            break;
        }
        case 1:
        {

            cell = [tableView dequeueReusableCellWithIdentifier:ITEM_CELL];
            
            if (cell == nil)
            {
                cell = [[[LeftSideItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:ITEM_CELL]
                        autorelease];
                cell.backgroundColor = [UIColor clearColor];
            }
            
            switch (indexPath.row)
            {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"indexIcon.png"];
                    cell.textLabel.text = NSLocalizedString(@"TITLE_INDEX", @"首页");
                    break;
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"favoriteIcon.png"];
                    cell.textLabel.text = NSLocalizedString(@"TITLE_FAVORITE", @"收藏");
                    break;
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"settingIcon.png"];
                    cell.textLabel.text = NSLocalizedString(@"TITLE_SETTING", @"设置");
                    break;
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"appRecommendIcon.png"];
                    cell.textLabel.text = NSLocalizedString(@"TITLE_APP_RECOMMEND", @"推荐应用");
                    break;
                default:
                    break;
            }
            
            break;
        }
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:ITEM_CELL];
            
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ITEM_CELL] autorelease];
                cell.backgroundColor = [UIColor clearColor];
            }
            break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return nil;
        default:
            return @"";
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return 74.0;
        case 1:
            return tableView.rowHeight;
        case 2:
            return 69.0;
        default:
            break;
    }
    
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 2:
            return 0;
        default:
            return tableView.sectionHeaderHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
        case 1:
        {
            if (_sectionView == nil)
            {
                _sectionView = [[LeftSideSectionView alloc] initWithFrame:CGRectZero];
                _sectionView.title = NSLocalizedString(@"TITLE_FUN_SECTION", @"功能");
            }
            return _sectionView;
        }
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                case 1:
                case 2:
                    
                    self.view.userInteractionEnabled = NO;
                    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                        
                        self.view.userInteractionEnabled = YES;
                        NSArray *array = [(UINavigationController *)self.viewDeckController.centerController viewControllers];
                        RootViewController *rootVC = [array objectAtIndex:0];
                        [rootVC showViewWithType:indexPath.row animated:NO];
                        
                    }];
                    
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

@end
