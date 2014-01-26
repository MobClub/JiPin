//
//  LeftSideAppItemCell.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-5.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "LeftSideAppItemCell.h"
#import <AGCommon/UIColor+Common.h>
#import "AppDelegate.h"

#define PADDING_LEFT 14.0
#define PADDING_RIGHT 14.0
#define HORIZONTAL_GAP 10
#define IMAGE_WIDTH 44.0
#define IMAGE_HEIGHT 44.0

@implementation LeftSideAppItemCell

@synthesize itemData = _itemData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _imageCacheManager = appDelegate.imageCacheManager;
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.detailTextLabel.textColor = [UIColor colorWithRGB:0x7e7e7e];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appRecommendLine.png"]];
        lineImageView.frame = CGRectMake(0.0, self.contentView.height - lineImageView.height, lineImageView.width, lineImageView.height);
        lineImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:lineImageView];
        [lineImageView release];
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(_itemData);
    [self releaseLoader];
    
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.imageView.frame = CGRectMake(PADDING_LEFT, (self.contentView.height - IMAGE_WIDTH) / 2, IMAGE_WIDTH, IMAGE_HEIGHT);
    self.textLabel.frame = CGRectMake(self.imageView.right + HORIZONTAL_GAP,
                                      self.textLabel.top,
                                      appDelegate.viewController.leftViewSize - PADDING_LEFT - HORIZONTAL_GAP - IMAGE_WIDTH - PADDING_RIGHT,
                                      self.textLabel.height);
    self.detailTextLabel.frame = CGRectMake(self.imageView.right + HORIZONTAL_GAP,
                                            self.detailTextLabel.top,
                                            appDelegate.viewController.leftViewSize- PADDING_LEFT - HORIZONTAL_GAP - IMAGE_WIDTH - PADDING_RIGHT,
                                            self.detailTextLabel.height);
}

- (void)setItemData:(NSDictionary *)itemData
{
    [itemData retain];
    SAFE_RELEASE(_itemData);
    _itemData = itemData;
    
    self.textLabel.text = [_itemData valueForKey:@"title"];
    self.detailTextLabel.text = [_itemData valueForKey:@"ad_words"];
    self.imageView.image = nil;
    
    NSString *icon = [_itemData valueForKey:@"icon"];
    if (icon)
    {
        [self releaseLoader];
        
        _imageLoader = [[_imageCacheManager getImage:icon cornerRadius:5 size:CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT)] retain];
        if (_imageLoader.state == ImageLoaderStateReady)
        {
            self.imageView.image = _imageLoader.content;
        }
        else
        {
            [_imageLoader addNotificationWithName:NOTIF_IMAGE_LOAD_COMPLETE target:self action:@selector(loadIconCompleteHandler:)];
            [_imageLoader addNotificationWithName:NOTIF_IMAGE_LOAD_ERROR target:self action:@selector(loadIconErrorHandler:)];
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark - Private

/**
 *	@brief	释放图片加载器
 */
- (void)releaseLoader
{
    [_imageLoader removeAllNotificationWithTarget:self];
    SAFE_RELEASE(_imageLoader);
}

/**
 *	@brief	图片加载成功
 *
 *	@param 	notif 	通知
 */
- (void)loadIconCompleteHandler:(NSNotification *)notif
{
    self.imageView.image = _imageLoader.content;
    [self setNeedsLayout];
    
    [self releaseLoader];
}

/**
 *	@brief	图片加载失败
 *
 *	@param 	notif 	通知
 */
- (void)loadIconErrorHandler:(NSNotification *)notif
{
    [self releaseLoader];
}

@end
