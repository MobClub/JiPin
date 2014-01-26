//
//  LeftSideSectionView.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "LeftSideSectionView.h"
#import <AGCommon/UIColor+Common.h>

#define PADDING_LEFT 14.0
#define PADDING_RIGHT 14.0

@implementation LeftSideSectionView

@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBG.png"]];
        bgImageView.frame = self.bounds;
        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview: bgImageView];
        [bgImageView release];
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor colorWithRGB:0x7b7b7b];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.frame = CGRectMake(PADDING_LEFT,
                                       (self.height - _titleLabel.height) / 2,
                                       self.width - PADDING_LEFT - PADDING_RIGHT,
                                       _titleLabel.height);
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_titleLabel];
        [_titleLabel release];
    }
    return self;
}

- (void)setTitle:(NSString *)aTitle
{
    _titleLabel.text = aTitle;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(PADDING_LEFT,
                                   (self.height - _titleLabel.height) / 2,
                                   self.width - PADDING_LEFT - PADDING_RIGHT,
                                   _titleLabel.height);
}

- (NSString *)title
{
    return _titleLabel.text;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(PADDING_LEFT,
                                   (self.height - _titleLabel.height) / 2,
                                   self.width - PADDING_LEFT - PADDING_RIGHT,
                                   _titleLabel.height);
}

@end
