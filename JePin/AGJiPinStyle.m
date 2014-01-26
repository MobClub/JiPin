//
//  AGJiPinStyle.m
//  JePin
//
//  Created by Nogard on 13-7-5.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "AGJiPinStyle.h"


@implementation AGJiPinStyle

@synthesize font = _font;
@synthesize foregroundColor = _foregroundColor;
@synthesize backgroundColor = _backgroundColor;

+ (AGJiPinStyle *)styleWithFont:(UIFont  *)theFont
                foregroundColor:(UIColor *)foregroundColor
                backgroundColor:(UIColor *)backgroundColor
{
    AGJiPinStyle *style = [[[self alloc] init] autorelease];
    style.font = theFont;
    style.foregroundColor = foregroundColor;
    style.backgroundColor = backgroundColor;
    return style;
}

+ (AGJiPinStyle *)NavigationBarTitleStyle
{
    static AGJiPinStyle *navigationBarTitleStyle = nil;
    
    if (navigationBarTitleStyle == nil)
    {
        navigationBarTitleStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Medium"
                                                                               size:18.0]
                                               foregroundColor:[UIColor colorWithRed:89.0/255.0
                                                                               green:89.0/255.0
                                                                                blue:89.0/255.0
                                                                               alpha:1.0]
                                               backgroundColor:[UIColor clearColor]]
                                   retain];
    }
    return navigationBarTitleStyle;
}

+ (AGJiPinStyle *)NavigationBarItemStyle
{
    static AGJiPinStyle *navigationBarTitleStyle = nil;

    if (navigationBarTitleStyle == nil)
    {
        navigationBarTitleStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Medium"
                                                                               size:14.0]
                                               foregroundColor:[UIColor colorWithRed:144.0/255.0
                                                                               green:139.0/255.0
                                                                                blue:133.0/255.0
                                                                               alpha:1.0]
                                               backgroundColor:[UIColor clearColor]]
                                   retain];
    }
    return navigationBarTitleStyle;
}

+ (AGJiPinStyle *)TableSectionHeaderTitleStyle
{
    static AGJiPinStyle *tableSectionHeaderTitleStyle = nil;
    
    if (tableSectionHeaderTitleStyle == nil)
    {
        tableSectionHeaderTitleStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Medium"
                                                                                    size:16.0]
                                                    foregroundColor:[UIColor colorWithRed:135.0/255.0
                                                                                    green:135.0/255.0
                                                                                     blue:126.0/255.0
                                                                                    alpha:1.0]
                                                    backgroundColor:[UIColor clearColor]]
                                        retain];
    }
    return tableSectionHeaderTitleStyle;
}

+ (AGJiPinStyle *)WeiboContentStyle
{
    static AGJiPinStyle *weiboContentStyle = nil;
    
    if (weiboContentStyle == nil)
    {
        weiboContentStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Medium"
                                                                         size:16.0]
                                         foregroundColor:[UIColor colorWithRed:51.0/255.0
                                                                         green:51.0/255.0
                                                                          blue:51.0/255.0
                                                                         alpha:1.0]
                                         backgroundColor:[UIColor clearColor]]
                             retain];
    }
    return weiboContentStyle;
}

+ (AGJiPinStyle *)WeiboRefContentStyle
{
    static AGJiPinStyle *weiboRefContentStyle = nil;
    
    if (weiboRefContentStyle == nil)
    {
        weiboRefContentStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Medium"
                                                                            size:16.0]
                                            foregroundColor:[UIColor colorWithRed:51.0/255.0
                                                                            green:51.0/255.0
                                                                             blue:51.0/255.0
                                                                            alpha:1.0]
                                            backgroundColor:[UIColor clearColor]]
                                retain];
    }
    return weiboRefContentStyle;
}

+ (AGJiPinStyle *)WeiboInfoTextStyle
{
    static AGJiPinStyle *weiboInfoTextStyle = nil;
    
    if (weiboInfoTextStyle == nil)
    {
        weiboInfoTextStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Light"
                                                                          size:12.0]
                                          foregroundColor:[UIColor colorWithRed:144.0/255.0
                                                                          green:139.0/255.0
                                                                           blue:133.0/255.0
                                                                          alpha:1.0]
                                          backgroundColor:[UIColor clearColor]]
                              retain];
    }
    return weiboInfoTextStyle;
}

+ (AGJiPinStyle *)WeiboButtonNoBorderTextStyle
{
    static AGJiPinStyle *weiboInfoTextStyle = nil;

    if (weiboInfoTextStyle == nil)
    {
        weiboInfoTextStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Light"
                                                                          size:10.0]
                                          foregroundColor:[UIColor colorWithRed:144.0/255.0
                                                                          green:139.0/255.0
                                                                           blue:133.0/255.0
                                                                          alpha:1.0]
                                          backgroundColor:[UIColor clearColor]]
                              retain];
    }
    return weiboInfoTextStyle;
}

+ (AGJiPinStyle *)WeiboButtonNoBorderSmallTextStyle
{
    static AGJiPinStyle *weiboInfoTextStyle = nil;

    if (weiboInfoTextStyle == nil)
    {
        weiboInfoTextStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Light"
                                                                          size:9.0]
                                          foregroundColor:[UIColor colorWithRed:144.0/255.0
                                                                          green:139.0/255.0
                                                                           blue:133.0/255.0
                                                                          alpha:1.0]
                                          backgroundColor:[UIColor clearColor]]
                              retain];
    }
    return weiboInfoTextStyle;
}

+ (AGJiPinStyle *)WeiboPublishTimeTextStyle
{
    static AGJiPinStyle *weiboInfoTextStyle = nil;
    
    if (weiboInfoTextStyle == nil)
    {
        weiboInfoTextStyle = [[AGJiPinStyle styleWithFont:[UIFont fontWithName:@"STHeitiSC-Light"
                                                                          size:10.0]
                                          foregroundColor:[UIColor colorWithRed:252.0/255.0
                                                                          green:124.0/255.0
                                                                           blue:8.0/255.0
                                                                          alpha:1.0]
                                          backgroundColor:[UIColor clearColor]]
                              retain];
    }
    return weiboInfoTextStyle;
}

@end