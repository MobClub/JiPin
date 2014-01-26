//
//  LeftSideSectionView.h
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	@brief	单元视图
 */
@interface LeftSideSectionView : UIView
{
@private
    UILabel *_titleLabel;
}

/**
 *	@brief	标题
 */
@property (nonatomic,copy) NSString *title;


@end
