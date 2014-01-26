//
//  AGSinaWeiboStatusNoCommentCell.m
//  JePin
//
//  Created by Nogard on 13-7-10.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "AGSinaWeiboStatusNoCommentCell.h"

@implementation AGSinaWeiboStatusNoCommentCell

+ (CGFloat)minCellHeightWithImage:(UIImage *)image
{
    UIImageView *v = [[UIImageView alloc] initWithImage:image];
    [v sizeToFit];
    CGFloat h = v.height;
    [v release];
    return h;
}

- (id)initWithStyle:(UITableViewCellStyle)style
              image:(UIImage *)image
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _myCellImageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_myCellImageView];
        [_myCellImageView release];
    }
    return self;
}

- (void)dealloc
{
    _myCellImageView = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_myCellImageView sizeToFit];
    _myCellImageView.frame = CGRectMake(
            (self.width - _myCellImageView.width) / 2.0,
            self.height - _myCellImageView.height,
            _myCellImageView.width,
            _myCellImageView.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
