//
//  UILabel+AGJiPinConfig.m
//  JePin
//
//  Created by Nogard on 13-7-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "UILabel+AGJiPinConfig.h"
#import <AGCommon/UIColor+Common.h>

@implementation UILabel(AGJiPinConfig)

- (void)applyStyle:(AGJiPinStyle *)style
{
  self.font = style.font;
  self.textColor = style.foregroundColor;
  self.backgroundColor = style.backgroundColor;
}

@end


@implementation UIButton(AGJiPinConfig)

- (void)applyStyle:(AGJiPinStyle *)style
{
    [self setTitleColor:style.foregroundColor forState:UIControlStateNormal];
    self.titleLabel.font = style.font;
    self.titleLabel.backgroundColor = style.backgroundColor;
    [self.titleLabel setTextAlignment:NSTextAlignmentRight];
}

@end