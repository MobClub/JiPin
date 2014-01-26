//
//  SinaWeiboTag.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief	标签
 */
@interface SinaWeiboTag : NSObject <NSCoding>
{
@private
    NSMutableDictionary *_sourceData;
}

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;

/**
 *	@brief	标签ID
 */
@property (nonatomic,readonly) long long Id;

/**
 *	@brief	标签名称
 */
@property (nonatomic,readonly) NSString *tag;

/**
 *	@brief	创建标签对象
 *
 *	@param 	response 	回复数据
 *
 *	@return	标签对象
 */
+ (SinaWeiboTag *)tagWithResponse:(NSDictionary *)response;


@end
