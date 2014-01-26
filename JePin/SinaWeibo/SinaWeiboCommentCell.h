//
//  SinaWeiboCommentCell.h
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboComment.h"
#import <AGCommon/CMImageView.h>
#import <AGCommon/CMImageCacheManager.h>

/**
 *	@brief	新浪微博评论单元格
 */
@interface SinaWeiboCommentCell : UITableViewCell
{
@private
    SinaWeiboComment *_comment;
    CMImageCacheManager *_imageCacheManager;
    CMImageLoader *_iconLoader;
    BOOL _needLayout;
    
    CMImageView *_iconImageView;
//    UIImageView *_vipImageView;
    UIImageView *_lineImageView;
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    UILabel *_dateLabel;
//    UILabel *_sourceLabel;
}

@property (nonatomic,retain) SinaWeiboComment *comment;

/**
 *	@brief	初始化单元格
 *
 *	@param 	style 	风格
 *	@param 	reuseIdentifier 	复用标识
 *	@param 	imageCacheManager 	图片缓存管理器
 *
 *	@return	单元格
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  imageCacheManager:(CMImageCacheManager *)imageCacheManager;

/**
 *	@brief	根据新浪状态信息排版
 *
 *	@param 	status 	状态信息
 *  @param  isCalCellHeight     是否计算高度标识，YES表示计算高度，将不对图片进行加载
 *
 *	@return	单元格高度
 */
- (CGFloat)layoutThatComment:(SinaWeiboComment *)comment isCalCellHeight:(BOOL)isCalCellHeight;

@end
