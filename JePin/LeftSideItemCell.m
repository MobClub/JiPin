//
//  LeftSideItemCell.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-3.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "LeftSideItemCell.h"

#define PADDING_LEFT 14.0
#define HORIZONTAL_GAP 10.0

@implementation LeftSideItemCell

@synthesize lineImageView = _lineImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSepeatorLine.png"]];
        _lineImageView.frame = CGRectMake(0.0,
                                          self.contentView.height - _lineImageView.height,
                                          self.contentView.width,
                                          _lineImageView.height);
        _lineImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_lineImageView];
        [_lineImageView release];
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:18];
        self.textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(PADDING_LEFT, self.imageView.top, self.imageView.width, self.imageView.height);
    self.textLabel.frame = CGRectMake(self.imageView.right + HORIZONTAL_GAP, self.textLabel.top, self.textLabel.width, self.textLabel.height);
}

@end
