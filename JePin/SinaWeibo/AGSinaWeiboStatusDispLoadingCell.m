//
//  AGSinaWeiboStatusDispLoadingCell.m
//  JePin
//
//  Created by Nogard on 13-7-10.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "AGSinaWeiboStatusDispLoadingCell.h"
#import "UILabel+AGJiPinConfig.h"

@implementation AGSinaWeiboStatusDispLoadingCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              title:(NSString *)title
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.text = title;
        [self.textLabel applyStyle:[AGJiPinStyle WeiboInfoTextStyle]];
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicator];
        [_indicator release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.textLabel sizeToFit];
    CGFloat spacing = 3.0;
    CGFloat maxHeight = self.textLabel.height >= _indicator.height ? self.textLabel.height : _indicator.height;
    [self setFrame:CGRectMake(self.left, self.top, self.width, maxHeight + spacing * 2)];
    CGFloat totalWidth = _indicator.width + self.textLabel.width + spacing;
    self.textLabel.frame = CGRectMake(
            (self.width - totalWidth) / 2.0 + _indicator.width + spacing,
            (maxHeight - self.textLabel.height) /2.0 + spacing,
            self.textLabel.width,
            self.textLabel.height);
    
    _indicator.frame = CGRectMake(
            (self.width - totalWidth) / 2.0,
            (maxHeight - _indicator.height)/2.0 + spacing,
            _indicator.width,
            _indicator.height);

    if (![_indicator isAnimating])
    {
        [_indicator startAnimating];
    }
}

- (void)dealloc
{
    _indicator = nil;
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
