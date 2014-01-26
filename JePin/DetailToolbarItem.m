//
//  DetailToolbarItem.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-7-8.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "DetailToolbarItem.h"
#import <AGCommon/UIColor+Common.h>

#define TITLE_HEIGHT 12.0
#define VERTICAL_GAP 6.0

@implementation DetailToolbarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.font = [UIFont systemFontOfSize:9];
        [self setTitleColor:[UIColor colorWithRGB:0x000000] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    _imageWidth=image.size.width;
	_imageHeight=image.size.height;
    
	[super setImage:image forState:state];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
	CGRect rect = CGRectZero;
    rect.origin.x = (contentRect.size.width - _imageWidth) / 2;
    rect.origin.y = (contentRect.size.height - _imageHeight - TITLE_HEIGHT - VERTICAL_GAP) / 2;
    rect.size.width = _imageWidth;
    rect.size.height = _imageHeight;
    
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super titleRectForContentRect:contentRect];
    rect.origin.x = (contentRect.size.width - rect.size.width) / 2;
    rect.origin.y = (contentRect.size.height - _imageHeight - TITLE_HEIGHT - VERTICAL_GAP) / 2 + _imageHeight + VERTICAL_GAP;
    
	return rect;
}

@end
