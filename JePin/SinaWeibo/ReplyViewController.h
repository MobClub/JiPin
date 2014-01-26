//
//  ReplyViewController.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SinaWeiboConnection/SSSinaWeiboStatus.h>
#import <SinaWeiboConnection/SSSinaWeiboStatusInfoReader.h>

/**
 *	@brief	回复视图控制器类型
 */
typedef enum
{
	ReplyViewControllerTypeReply = 1, /**< 转发 */
	ReplyViewControllerTypeComment = 2 /**< 评论 */
}
ReplyViewControllerType;


/**
 *	@brief	回复对话框
 */
@interface ReplyViewController : UIViewController
{
@private
    SSSinaWeiboStatusInfoReader *_status;
    ReplyViewControllerType _type;
    id _commentComplete;
    
    UITextView *_textView;
}

/**
 *	@brief	初始化视图控制器
 *
 *	@param 	status 	状态
 *	@param 	type 	类型
 *  @param  commentComplete 评论完成回调
 *
 *	@return	视图控制器
 */
- (id)initWithStatus:(SSSinaWeiboStatusInfoReader *)status
                type:(ReplyViewControllerType)type
     commentComplete:(void(^)())commentComplete;


@end
