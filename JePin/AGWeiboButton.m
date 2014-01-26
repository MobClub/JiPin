//
//  AGWeiboButton.m
//  JePin
//
//  Created by Nogard on 13-7-5.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "AGWeiboButton.h"
#import <AGCommon/NSString+Common.h>

@implementation AGWeiboButton

- (id)initWithImageNamed:(NSString *)name
                   style:(AGJiPinStyle *)style
              withBorder:(BOOL)withBorder
{
    self = [super initWithFrame:withBorder ?
            CGRectMake(0, 0, 72.0, 24.0) : CGRectMake(0, 0, 45, 24)];
    if (self)
    {
        if (name)
        {
            [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
            [self setTitleColor:style.foregroundColor forState:UIControlStateNormal];
            self.titleLabel.backgroundColor = style.backgroundColor;
            self.titleLabel.font = style.font;
            [self.titleLabel setTextAlignment:NSTextAlignmentRight];
        }

        if (withBorder)
        {
            UIImage *bgImg = nil;
            if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"6.0"] != NSOrderedAscending )
            {
                bgImg = [[UIImage imageNamed:@"CommonButtonBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2.0, 0, 2.0)
                                                                                   resizingMode:UIImageResizingModeStretch];
            }
            else
            {
                bgImg = [[UIImage imageNamed:@"CommonButtonBG.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:11];
            }
            
            [self setBackgroundImage:bgImg forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)sizeToFit
{
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 3.0, 0, 10.0);
    self.titleEdgeInsets = UIEdgeInsetsMake(3.0, 10.0, 0, 3.0);
}

@end
