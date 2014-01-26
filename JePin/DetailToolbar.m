//
//  DetailToolbar.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-8.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "DetailToolbar.h"

#define ITEM_WIDTH 50
#define ITEM_HEIGHT 50

@implementation DetailToolbar

@synthesize commentItem = _commentItem;
@synthesize replyItem = _replyItem;
@synthesize favoriteItem = _favoriteItem;
@synthesize shareItem = _shareItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _commentItem = [[DetailToolbarItem alloc] initWithFrame:CGRectMake(0.0, 0.0, ITEM_WIDTH, ITEM_HEIGHT)];
        [_commentItem setImage:[UIImage imageNamed:@"DetailCommentIcon.png"] forState:UIControlStateNormal];
        [_commentItem setTitle:@"评论" forState:UIControlStateNormal];
        [self addSubview:_commentItem];
        [_commentItem release];
        
        _replyItem = [[DetailToolbarItem alloc] initWithFrame:CGRectMake(0.0, 0.0, ITEM_WIDTH, ITEM_HEIGHT)];
        [_replyItem setImage:[UIImage imageNamed:@"DetailReplyIcon.png"] forState:UIControlStateNormal];
        [_replyItem setTitle:@"转发" forState:UIControlStateNormal];
        [self addSubview:_replyItem];
        [_replyItem release];
        
        _favoriteItem = [[DetailToolbarItem alloc] initWithFrame:CGRectMake(0.0, 0.0, ITEM_WIDTH, ITEM_HEIGHT)];
        [_favoriteItem setImage:[UIImage imageNamed:@"DetailFavoriteIcon.png"] forState:UIControlStateNormal];
        [_favoriteItem setImage:[UIImage imageNamed:@"DetailFavoritedIcon.png"] forState:UIControlStateSelected];
        [_favoriteItem setTitle:@"收藏" forState:UIControlStateNormal];
        [self addSubview:_favoriteItem];
        [_favoriteItem release];
        
        _shareItem = [[DetailToolbarItem alloc] initWithFrame:CGRectMake(0.0, 0.0, ITEM_WIDTH, ITEM_HEIGHT)];
        [_shareItem setImage:[UIImage imageNamed:@"DetailShareIcon.png"] forState:UIControlStateNormal];
        [_shareItem setTitle:@"分享" forState:UIControlStateNormal];
        [self addSubview:_shareItem];
        [_shareItem release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat gap = (self.width - 4 * ITEM_WIDTH) / 5;
    
    _commentItem.frame = CGRectMake(gap, 0.0, ITEM_WIDTH, ITEM_HEIGHT);
    _replyItem.frame = CGRectMake(_commentItem.right + gap, 0.0, ITEM_WIDTH, ITEM_HEIGHT);
    _favoriteItem.frame = CGRectMake(_replyItem.right + gap, 0.0, ITEM_WIDTH, ITEM_HEIGHT);
    _shareItem.frame = CGRectMake(_favoriteItem.right + gap, 0.0, ITEM_WIDTH, ITEM_HEIGHT);
}

@end
