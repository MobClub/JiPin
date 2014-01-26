//
//  AGStyle.h
//  JePin
//
//  Created by Nogard on 13-7-5.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGJiPinStyle : NSObject
{
  UIFont  *_font;
  UIColor *_foregroundColor;
  UIColor *_backgroundColor;
}

+ (AGJiPinStyle *)styleWithFont:(UIFont  *)theFont
           foregroundColor:(UIColor *)foregroundColor
           backgroundColor:(UIColor *)backgroundColor;

+ (AGJiPinStyle *)NavigationBarTitleStyle;
+ (AGJiPinStyle *)NavigationBarItemStyle;
+ (AGJiPinStyle *)TableSectionHeaderTitleStyle;
+ (AGJiPinStyle *)WeiboRefContentStyle;
+ (AGJiPinStyle *)WeiboContentStyle;
+ (AGJiPinStyle *)WeiboInfoTextStyle;
+ (AGJiPinStyle *)WeiboButtonNoBorderTextStyle;
+ (AGJiPinStyle *)WeiboButtonNoBorderSmallTextStyle;
+ (AGJiPinStyle *)WeiboPublishTimeTextStyle;

@property (retain, readwrite, nonatomic) UIFont  *font;
@property (retain, readwrite, nonatomic) UIColor *foregroundColor;
@property (retain, readwrite, nonatomic) UIColor *backgroundColor;

@end
