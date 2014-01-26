//
//  UILabel+AGJiPinConfig.h
//  JePin
//
//  Created by Nogard on 13-7-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGJiPinStyle.h"

@interface UILabel(AGJiPinConfig)

- (void)applyStyle:(const AGJiPinStyle *)style;

@end


@interface UIButton(AGJiPinConfig)

- (void)applyStyle:(const AGJiPinStyle *)style;

@end
