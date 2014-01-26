//
//  AGWeiboButton.h
//  JePin
//
//  Created by Nogard on 13-7-5.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGJiPinStyle.h"

@interface AGWeiboButton : UIButton
{
@private
  NSString *_imageName;
}

- (id)initWithImageNamed:(NSString *)name
                   style:(AGJiPinStyle *)style
              withBorder:(BOOL)withBorder;

@end
