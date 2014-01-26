//
//  SinaWeiboFavorite.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SinaWeiboConnection/SSSinaWeiboStatus.h>
#import <SinaWeiboConnection/SSSinaWeiboStatusInfoReader.h>

/**
 *	@brief	收藏信息
 */
@interface SinaWeiboFavorite : NSObject <NSCoding>
{
@private
    NSMutableDictionary *_sourceData;
}

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;

/**
 *	@brief	收藏时间
 */
@property (nonatomic,readonly) NSString *favoritedTime;

/**
 *	@brief	微博信息
 */
@property (nonatomic,readonly) SSSinaWeiboStatusInfoReader *status;

/**
 *	@brief	标签列表
 */
@property (nonatomic,readonly) NSArray *tags;

/**
 *	@brief	创建收藏信息
 *
 *	@param 	response 	返回数据
 *
 *	@return	收藏信息
 */
+ (SinaWeiboFavorite *)favoriteWithResponse:(NSDictionary *)response;


@end
