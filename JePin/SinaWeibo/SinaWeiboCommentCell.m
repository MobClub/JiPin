//
//  SinaWeiboCommentCell.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "SinaWeiboCommentCell.h"
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/NSDate+Common.h>
#import <AGCommon/CMRegexKitLite.h>

#define ICON_WIDTH 40.0
#define ICON_HEIGHT 40.0
#define VIP_ICON_WIDTH 17.0
#define VIP_ICON_HEIGHT 17.0

#define LEFT_PADDING 8.0
#define RIGHT_PADDING 8.0
#define TOP_PADDING 7.0
#define BOTTOM_PADDING 5.0
#define HORIZONTAL_GAP 10.0
#define VERTICAL_GAP 8.0

@implementation SinaWeiboCommentCell

@synthesize comment = _comment;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  imageCacheManager:(CMImageCacheManager *)imageCacheManager
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _imageCacheManager = imageCacheManager;
        
        _iconImageView = [[CMImageView alloc] initWithFrame:CGRectMake(LEFT_PADDING,
                                                                       TOP_PADDING,
                                                                       ICON_WIDTH,
                                                                       ICON_HEIGHT)];
        _iconImageView.defaultImage = [UIImage imageNamed:@"defaultAvatar.png"];
        [self.contentView addSubview:_iconImageView];
        [_iconImageView release];
        
//        _vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_iconImageView.right - VIP_ICON_WIDTH * 2 / 3,
//                                                                      _iconImageView.bottom - VIP_ICON_HEIGHT * 2 / 3,
//                                                                      VIP_ICON_WIDTH,
//                                                                      VIP_ICON_HEIGHT)];
//        [self addSubview:_vipImageView];
//        [_vipImageView release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
        [_nameLabel release];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        [_contentLabel release];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:9];
        _dateLabel.textColor = [UIColor colorWithRGB:0xb1b1b1];
        [self addSubview:_dateLabel];
        [_dateLabel release];
        
//        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _sourceLabel.backgroundColor = [UIColor clearColor];
//        _sourceLabel.font = [UIFont systemFontOfSize:10];
//        _sourceLabel.textColor = [UIColor colorWithRGB:0x999999];
//        [self addSubview:_sourceLabel];
//        [_sourceLabel release];
        
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SinaWeiboLine.jpg"]];
        [self.contentView addSubview:_lineImageView];
        [_lineImageView release];
    }
    return self;
}

- (void)dealloc
{
    _imageCacheManager = nil;
    _contentLabel = nil;
    _dateLabel = nil;
//    _sourceLabel = nil;
    _iconImageView = nil;
//    _vipImageView = nil;
    
    [_iconLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_iconLoader);
    SAFE_RELEASE(_comment);
    
    [super dealloc];
}

- (void)setComment:(SinaWeiboComment *)comment
{
    [comment retain];
    SAFE_RELEASE(_comment);
    _comment = comment;
    
    _needLayout = YES;
    [self setNeedsLayout];
}

- (CGFloat)layoutThatComment:(SinaWeiboComment *)comment isCalCellHeight:(BOOL)isCalCellHeight
{
    CGFloat height = 0;

    //头像
    if (!isCalCellHeight)
    {
        [_iconLoader removeAllNotificationWithTarget:self];
        SAFE_RELEASE(_iconLoader);
        
        _iconLoader = [[_imageCacheManager getImage:comment.user.avatarLarge
                                       cornerRadius:20
                                               size:_iconImageView.frame.size]
                       retain];
        if (_iconLoader.state == ImageLoaderStateReady)
        {
            _iconImageView.image = _iconLoader.content;
        }
        else
        {
            _iconImageView.image = nil;
            [_iconLoader addNotificationWithName:NOTIF_IMAGE_LOAD_COMPLETE
                                          target:self
                                          action:@selector(iconLoadCompleteHandler:)];
            [_iconLoader addNotificationWithName:NOTIF_IMAGE_LOAD_ERROR
                                          target:self
                                          action:@selector(iconLoadErrorHandler:)];
        }
    }
    
//    //认证类型
//    if (comment.user.verified)
//    {
//
//        switch (comment.user.verifiedType)
//        {
//            case 0:
//                //个人认证
//                _vipImageView.image = [UIImage imageNamed:@"Vip.png"];
//                _vipImageView.hidden = NO;
//                break;
//            case 5:
//            case 2:
//            case 3:
//                //企业认证
//                _vipImageView.image = [UIImage imageNamed:@"EnterpriseVip.png"];
//                _vipImageView.hidden = NO;
//                break;
//            default:
//                _vipImageView.hidden = YES;
//                break;
//        }
//    }
//    else
//    {
//        if (comment.user.verifiedType == 220)
//        {
//            //达人
//            _vipImageView.image = [UIImage imageNamed:@"Grassroot.png"];
//            _vipImageView.hidden = NO;
//        }
//        else
//        {
//            _vipImageView.hidden = YES;
//        }
//    }
    
    CGFloat left = _iconImageView.right + HORIZONTAL_GAP;
    
    //发布日期
    _dateLabel.text = [self createDateString:comment.createdAt];
    [_dateLabel sizeToFit];
    
    //发布用户名称
    _nameLabel.text = [NSString stringWithFormat:@"%@:", comment.user.name];
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(left,
                                  TOP_PADDING,
                                  self.width - left - RIGHT_PADDING - _dateLabel.width,
                                  _nameLabel.height);
    
    _dateLabel.frame = CGRectMake(self.width - RIGHT_PADDING - _dateLabel.width,
                                  _nameLabel.bottom - _dateLabel.height,
                                  _dateLabel.width,
                                  _dateLabel.height);

    //评论内容
    _contentLabel.text = comment.text;
    _contentLabel.frame = [_contentLabel textRectForBounds:CGRectMake(left,
                                                                      _nameLabel.bottom,
                                                                      self.width - left - RIGHT_PADDING,
                                                                      MAXFLOAT)
                                    limitedToNumberOfLines:0];
    if (_iconImageView.bottom > _contentLabel.bottom)
    {
        height = _iconImageView.bottom;
    }
    else
    {
        height = _contentLabel.bottom;
    }
    
    height += VERTICAL_GAP;
    
    //分隔线
    _lineImageView.frame = CGRectMake((self.width - _lineImageView.width) / 2,
                                      height,
                                      _lineImageView.width,
                                      _lineImageView.height);
    
    height = _lineImageView.bottom;
    
    
    
    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needLayout)
    {
        _needLayout = NO;
        
        [self layoutThatComment:_comment isCalCellHeight:NO];
    }
}

#pragma mark - Privare

- (void)iconLoadCompleteHandler:(NSNotification *)notif
{
    _iconImageView.image = _iconLoader.content;
    
    [_iconLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_iconLoader);
}

- (void)iconLoadErrorHandler:(NSNotification *)notif
{
    [_iconLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_iconLoader);
}

/**
 *	@brief	返回创建时间描述字符串
 *
 *	@param 	createAt 	创建时间
 *
 *	@return	字符串
 */
- (NSString *)createDateString:(NSString *)createAt
{
    NSDate *date = [NSDate dateByStringFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"
                                   dateString:createAt
                                       locale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970];
    if (timeInterval > 86400)
    {
        NSInteger day = ceil(timeInterval / 86400.0);
        if (day > 30)
        {
            day = 30;
        }
        return [NSString stringWithFormat:@"%d天前", day];
    }
    else if (timeInterval > 3600)
    {
        NSInteger hour = ceil(timeInterval / 3600.0);
        
        return [NSString stringWithFormat:@"%d小时前", hour];
    }
    else if (timeInterval > 60)
    {
        NSInteger minute = ceil(timeInterval / 60.0);
        
        return [NSString stringWithFormat:@"%d分钟前", minute];
    }
    else
    {
        return [NSString stringWithFormat:@"%.0f秒前", timeInterval];
    }
}

@end
