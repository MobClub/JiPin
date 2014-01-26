//
//  LeftSideViewController.h
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideSectionView.h"
#import "LeftSideAppItemCell.h"

@interface LeftSideViewController : UIViewController <UITableViewDataSource,
                                                      UITableViewDelegate>
{
@private
    LeftSideSectionView *_sectionView;
}

@end
