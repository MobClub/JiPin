//
//  LeftSideItemCell.h
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSideItemCell : UITableViewCell
{
@private
    UIImageView *_lineImageView;
}

/**
 *	@brief	分隔线
 */
@property (nonatomic,readonly) UIImageView *lineImageView;


@end
