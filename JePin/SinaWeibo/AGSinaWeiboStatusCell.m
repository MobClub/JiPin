//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import "AGSinaWeiboStatusCell.h"
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/NSDate+Common.h>
#import <AGCommon/CMRegexKitLite.h>
#import "UILabel+AGJiPinConfig.h"
#import "AGJiPinStyle.h"
#import "AGWeiboButton.h"

#define ICON_WIDTH 35.0
#define ICON_HEIGHT 35.0
#define IMAGE_WIDTH 75.0
#define IMaGE_HEIGHT 75.0
#define VIP_ICON_WIDTH 17.0
#define VIP_ICON_HEIGHT 17.0

#define LEFT_PADDING 16.0
#define RIGHT_PADDING 16.0
#define TOP_PADDING 8.0
#define BOTTOM_PADDING 8.0
#define HORIZONTAL_GAP 10.0
#define VERTICAL_GAP 8.0

@implementation AGSinaWeiboStatusCell

@synthesize status = _status;
@synthesize delegate = _delegate;
@synthesize cellHeight = _cellHeight;
@synthesize showControlBar = _showControlBar;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  imageCacheManager:(CMImageCacheManager *)imageCacheManager
{
    return [self initWithStyle:style
               reuseIdentifier:reuseIdentifier
             imageCacheManager:imageCacheManager
            showControlButtons:YES];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  imageCacheManager:(CMImageCacheManager *)imageCacheManager
 showControlButtons:(BOOL)shouldShowControlButton
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.showControlBar = shouldShowControlButton;

        _imageCacheManager = imageCacheManager;

        //        _iconImageView = [[CMImageView alloc] initWithFrame:CGRectMake(LEFT_PADDING, TOP_PADDING, ICON_WIDTH, ICON_HEIGHT)];
        //        _iconImageView.defaultImage = [UIImage imageNamed:@"defaultAvatar.png"];
        //        [self.contentView addSubview:_iconImageView];
        //        [_iconImageView release];
        //
        //        _vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_iconImageView.right - VIP_ICON_WIDTH * 2 /3,
        //                                                                      _iconImageView.bottom - VIP_ICON_HEIGHT * 2 / 3,
        //                                                                      VIP_ICON_WIDTH,
        //                                                                      VIP_ICON_HEIGHT)];
        //        [self addSubview:_vipImageView];
        //        [_vipImageView release];
        //
        //        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //        _nameLabel.backgroundColor = [UIColor clearColor];
        //        _nameLabel.font = [UIFont systemFontOfSize:15];
        //        [self.contentView addSubview:_nameLabel];
        //        [_nameLabel release];

        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel applyStyle:[AGJiPinStyle WeiboContentStyle]];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        [_contentLabel release];

        // 发表日期 logo
        _timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Time.png"]];
        [self.contentView addSubview:_timeImageView];
        [_timeImageView release];

        // 发表日期 label
        _pubDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_pubDateLabel applyStyle:[AGJiPinStyle WeiboPublishTimeTextStyle]];
        [self.contentView addSubview:_pubDateLabel];
        [_pubDateLabel release];


        if (_showControlBar) {
            AGJiPinStyle *style = [AGJiPinStyle WeiboInfoTextStyle];
            
            // “评论” label
            _commentButton = [[AGWeiboButton alloc] initWithImageNamed:@"Comment.png"
                                                                 style:style
                                                            withBorder:YES];
            [self.contentView addSubview:_commentButton];
            [_commentButton release];

            // “转发” label
            _replyButton = [[AGWeiboButton alloc] initWithImageNamed:@"Retweet.png"
                                                               style:style
                                                          withBorder:YES];
            [self.contentView addSubview:_replyButton];
            [_replyButton release];

            _favorButton = [[AGWeiboButton alloc] initWithImageNamed:nil
                                                               style:style
                                                          withBorder:YES];
            [self.contentView addSubview:_favorButton];
            [_favorButton release];

            _shareButton = [[AGWeiboButton alloc] initWithImageNamed:nil
                                                               style:style
                                                          withBorder:YES];
            [self.contentView addSubview:_shareButton];
            [_shareButton release];
        }
        else {
            AGJiPinStyle *style = [AGJiPinStyle WeiboButtonNoBorderTextStyle];
            
            _commentButton = [[AGWeiboButton alloc] initWithImageNamed:@"Comment.png"
                                                                 style:style
                                                            withBorder:NO];
            [self.contentView addSubview:_commentButton];
            [_commentButton release];

            _replyButton = [[AGWeiboButton alloc] initWithImageNamed:@"Retweet.png"
                                                               style:style
                                                          withBorder:NO];
            [self.contentView addSubview:_replyButton];
            [_replyButton release];
        }

        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SinaWeiboLine.jpg"]];
        [self.contentView addSubview:_lineImageView];
        [_lineImageView release];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    _imageCacheManager = nil;
    _contentLabel = nil;
    _pubDateLabel = nil;
    _commentButton= nil;
    _replyButton  = nil;
    _favorButton  = nil;
    _shareButton  = nil;
    _picImageView = nil;
    _refContentView = nil;
    _nameLabel = nil;
    _lineImageView = nil;

    [_iconLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_iconLoader);
    [_picLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_picLoader);
    SAFE_RELEASE(_status);

    [super dealloc];
}

- (void)setStatus:(SSSinaWeiboStatusInfoReader *)status
{
    [status retain];
    SAFE_RELEASE(_status);
    _status = status;

    _needLayout = YES;
    [self setNeedsLayout];
}

- (void)setShowControlBar:(BOOL)showControlBar
{
    _showControlBar = showControlBar;

    //_commentButton.hidden = !_showControlBar;
    //_replyButton.hidden = !_showControlBar;
    _favorButton.hidden = !_showControlBar;
    _shareButton.hidden = !_showControlBar;
}

- (CGFloat)layoutThatStaus:(SSSinaWeiboStatusInfoReader *)status isCalCellHeight:(BOOL)isCalCellHeight
{
    CGFloat height = 0;

    //    [_iconLoader removeAllNotificationWithTarget:self];
    //    SAFE_RELEASE(_iconLoader);
    [_picLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_picLoader);

    //头像
    //    _iconLoader = [[_imageCacheManager getImage:status.user.avatarLarge cornerRadius:5.0 size:_iconImageView.frame.size] retain];
    //    if (_iconLoader.state == ImageLoaderStateReady)
    //    {
    //        _iconImageView.image = _iconLoader.content;
    //    }
    //    else
    //    {
    //        [_iconLoader addNotificationWithName:NOTIF_IMAGE_LOAD_COMPLETE
    //                                      target:self
    //                                      action:@selector(iconLoadCompleteHandler:)];
    //        [_iconLoader addNotificationWithName:NOTIF_IMAGE_LOAD_ERROR
    //                                      target:self
    //                                      action:@selector(iconLoadErrorHandler:)];
    //    }

    //认证类型
    //    if (status.user.verified)
    //    {
    //
    //        switch (status.user.verifiedType)
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
    //        if (status.user.verifiedType == 220)
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



    CGFloat left = LEFT_PADDING;

    //发布人名称
    //    _nameLabel.text = status.user.name;
    //    [_nameLabel sizeToFit];
    //    CGFloat nameLabelWidth = _nameLabel.width;
    //    if (nameLabelWidth > _pubDateLabel.left - left)
    //    {
    //        nameLabelWidth = _pubDateLabel.left - left;
    //    }
    //    _nameLabel.frame = CGRectMake(left, TOP_PADDING, nameLabelWidth, _nameLabel.height);

    _contentLabel.text = status.text;
    _contentLabel.frame = [_contentLabel textRectForBounds:CGRectMake(left, TOP_PADDING, self.width - left - RIGHT_PADDING, MAXFLOAT)
                                    limitedToNumberOfLines:0];

    if (_iconImageView.bottom > _contentLabel.bottom)
    {
        height = _iconImageView.bottom;
    }
    else
    {
        height = _contentLabel.bottom;
    }

    //判断是否转发
    if (status.retweetedStatus)
    {
        _picImageView.hidden = YES;

        if (_refContentView == nil)
        {
            _refContentView = [[AGSinaWeiboRefContentView alloc] initWithFrame:CGRectMake(left, height + VERTICAL_GAP, self.width - left - RIGHT_PADDING, 0) imageCacheManager:_imageCacheManager];
            _refContentView.delegate = self;
            [self.contentView addSubview:_refContentView];
            [_refContentView release];
        }
        _refContentView.frame = CGRectMake(left, height + VERTICAL_GAP, self.width - left - RIGHT_PADDING, 0);
        _refContentView.hidden = NO;
        _refContentView.status = status.retweetedStatus;

        height = _refContentView.bottom;
    }
    else
    {
        _refContentView.hidden = YES;

        //判断是否有图片
        if (status.thumbnailPic)
        {
            //获取图片显示
            if (_picImageView == nil)
            {
                _picImageView = [[CMImageView alloc] initWithFrame:CGRectMake(left, height + VERTICAL_GAP, IMAGE_WIDTH, IMaGE_HEIGHT)];
                [self.contentView addSubview:_picImageView];
                [_picImageView release];
                [_picImageView addTarget:self action:@selector(picClickHandler:) forControlEvents:UIControlEventTouchUpInside];
            }
            _picImageView.hidden = NO;
            _picImageView.frame = CGRectMake(left, height + VERTICAL_GAP, IMAGE_WIDTH, IMaGE_HEIGHT);

            _picLoader = [[_imageCacheManager getImage:status.thumbnailPic] retain];
            if (_picLoader.state == ImageLoaderStateReady)
            {
                _picImageView.image = _picLoader.content;
            }
            else
            {
                [_picLoader addNotificationWithName:NOTIF_IMAGE_LOAD_COMPLETE
                                             target:self
                                             action:@selector(picLoadCompleteHandler:)];
                [_picLoader addNotificationWithName:NOTIF_IMAGE_LOAD_ERROR
                                             target:self
                                             action:@selector(picLoadErrorHandler:)];
            }

            height = _picImageView.bottom;
        }
        else
        {
            _picImageView.hidden = YES;
        }
    }

    CGSize imgSize = _timeImageView.image.size;
    _timeImageView.frame = CGRectMake(left, height + VERTICAL_GAP, imgSize.width, imgSize.height);

    // 发布时间
    NSDate *date = [NSDate dateByStringFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"
                                   dateString:status.createdAt
                                       locale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    _pubDateLabel.text = [NSDate stringByStringFormat:@"MM-dd HH:mm" data:date];
    [_pubDateLabel sizeToFit];
    _pubDateLabel.frame = CGRectMake(left + imgSize.width + 3.0, height + VERTICAL_GAP, 100, _pubDateLabel.height);

    if (_showControlBar)
    {
        height = _timeImageView.bottom;
        
        // 评论
        [_commentButton setTitle:[NSString stringWithFormat:@"%d", status.commentsCount]
                        forState:UIControlStateNormal];
        [_commentButton addTarget:self
                           action:@selector(didClickCommentButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_commentButton sizeToFit];
        _commentButton.frame = CGRectMake(left, height + VERTICAL_GAP, _commentButton.width, _commentButton.height);

        // 转发
        [_replyButton setTitle:[NSString stringWithFormat:@"%d", status.repostsCount]
                      forState:UIControlStateNormal];
        [_replyButton addTarget:self
                         action:@selector(didClickReplyButton:)
               forControlEvents:UIControlEventTouchUpInside];
        [_replyButton sizeToFit];
        _replyButton.frame = CGRectMake(left + _commentButton.width + 9.0, height + VERTICAL_GAP, _replyButton.width, _replyButton.height);

        NSString *imageFileName = [[self status] favorited] ? @"FavHighLighted.png" : @"FavNormal.png";
        [_favorButton setImage:[UIImage imageNamed:imageFileName]
                      forState:UIControlStateNormal];
        [_favorButton addTarget:self
                         action:@selector(didClickFavorButton:)
               forControlEvents:UIControlEventTouchUpInside];
        _favorButton.frame = CGRectMake(_replyButton.left + _replyButton.width + 9.0, height + VERTICAL_GAP, 28.0, _favorButton.height);

        [_shareButton setImage:[UIImage imageNamed:@"ShareButtonIcon.png"]
                      forState:UIControlStateNormal];
        [_shareButton addTarget:self
                         action:@selector(didClickShareButton:)
               forControlEvents:UIControlEventTouchUpInside];
        _shareButton.frame = CGRectMake(self.width - 28.0 - LEFT_PADDING, height + VERTICAL_GAP, 28.0, _favorButton.height);

        height = _commentButton.bottom;
    }
    else
    {
        [_replyButton setTitle:[NSString stringWithFormat:@"%d", status.repostsCount]
                      forState:UIControlStateNormal];
        [_replyButton addTarget:nil
                         action:@selector(didClickReplyButton:)
               forControlEvents:UIControlEventTouchUpInside];
        [_replyButton sizeToFit];
        _replyButton.frame = CGRectMake(self.width - LEFT_PADDING -_replyButton.width, height, _replyButton.width, _replyButton.height);

        [_commentButton setTitle:[NSString stringWithFormat:@"%d", status.commentsCount]
                        forState:UIControlStateNormal];
        [_commentButton addTarget:nil
                         action:@selector(didClickReplyButton:)
               forControlEvents:UIControlEventTouchUpInside];
        [_commentButton sizeToFit];
        _commentButton.frame = CGRectMake(_replyButton.left - 9.0 - _commentButton.width, height, _commentButton.width, _commentButton.height);

        height = _commentButton.bottom;
    }

    // 水平分隔线
    _lineImageView.frame = CGRectMake((self.width - _lineImageView.width) / 2, height + BOTTOM_PADDING, _lineImageView.width, _lineImageView.height);
    height = _lineImageView.bottom;

    _cellHeight = height;

    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_needLayout)
    {
        _needLayout = NO;

        _cellHeight = [self layoutThatStaus:_status isCalCellHeight:NO];
    }
}

#pragma mark - Private

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

- (void)picLoadCompleteHandler:(NSNotification *)notif
{
    _picImageView.image = _picLoader.content;

    [_iconLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_iconLoader);
}

- (void)picLoadErrorHandler:(NSNotification *)notif
{
    [_iconLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_iconLoader);
}

- (void)picClickHandler:(id)sender
{
    if ([_delegate conformsToProtocol:@protocol(AGSinaWeiboStatusCellDelegate)] &&
        [_delegate respondsToSelector:@selector(cell:onShowPic:)])
    {
        [_delegate cell:self onShowPic:_status.originalPic];
    }
}

- (void)didClickCommentButton:(id)sender
{
    id<AGSinaWeiboStatusCellDelegate> delegate = self.delegate;
    [delegate cell:self onOperation:AGSinaWeiboComment forStatus:self.status];
}

- (void)didClickReplyButton:(id)sender
{
    id<AGSinaWeiboStatusCellDelegate> delegate = self.delegate;
    [delegate cell:self onOperation:AGSinaWeiboReply forStatus:self.status];
}

- (void)didClickFavorButton:(id)sender
{
    id<AGSinaWeiboStatusCellDelegate> delegate = self.delegate;
    [delegate cell:self onOperation:AGSinaWeiboAddFavor forStatus:self.status];
}

- (void)didClickShareButton:(id)sender
{
    id<AGSinaWeiboStatusCellDelegate> delegate = self.delegate;
    [delegate cell:self onOperation:AGSinaWeiboShare forStatus:self.status];
}


#pragma mark - AGSinaWeiboRefContentViewDelegate

- (void)contentView:(AGSinaWeiboRefContentView *)contentView showPic:(NSString *)imageUrl
{
    if ([_delegate conformsToProtocol:@protocol(AGSinaWeiboStatusCellDelegate)] &&
        [_delegate respondsToSelector:@selector(cell:onShowPic:)])
    {
        [_delegate cell:self onShowPic:imageUrl];
    }
}

@end
