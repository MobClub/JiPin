//
//  SinaWeiboComment.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
#import <SinaWeiboConnection/SSSinaWeiboStatusInfoReader.h>
#import <SinaWeiboConnection/SSSinaWeiboUserInfoReader.h>

/**
 *	@brief	评论信息
 */
@interface SinaWeiboComment : NSObject <NSCoding>
{
@private
    NSMutableDictionary *_sourceData;
}

/**
 *	@brief	源数据
 */
@property (nonatomic,retain) NSDictionary *sourceData;

/**
 *	@brief	创建时间
 */
@property (nonatomic,readonly) NSString *createdAt;

/**
 *	@brief	评论ID
 */
@property (nonatomic,readonly) long long Id;

/**
 *	@brief	评论ID字符串
 */
@property (nonatomic,readonly) NSString *idStr;

/**
 *	@brief	评论内容
 */
@property (nonatomic,readonly) NSString *text;

/**
 *	@brief	来源
 */
@property (nonatomic,readonly) NSString *source;

/**
 *	@brief	评论的MID
 */
@property (nonatomic,readonly) NSString *mid;

/**
 *	@brief	评论作者用户
 */
@property (nonatomic,readonly) SSSinaWeiboUserInfoReader *user;

/**
 *	@brief	评论的微博信息
 */
@property (nonatomic,readonly) SSSinaWeiboStatusInfoReader *status;

/**
 *	@brief	来源评论
 */
@property (nonatomic,readonly) SinaWeiboComment *replyComment;

/**
 *	@brief	创建评论信息
 *
 *	@param 	response 	回复数据
 *
 *	@return	评论信息
 */
+ (SinaWeiboComment *)commentWithResponse:(NSDictionary *)response;

@end
