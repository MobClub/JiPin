//
//  LeftSideAppItemCell.h
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-5.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGCommon/CMImageCacheManager.h>

/**
 *	@brief	推荐应用项单元格
 */
@interface LeftSideAppItemCell : UITableViewCell
{
@private
    NSDictionary *_itemData;
    CMImageCacheManager *_imageCacheManager;
    CMImageLoader *_imageLoader;
}

/**
 *	@brief	应用数据
 */
@property (nonatomic,retain) NSDictionary *itemData;


@end
