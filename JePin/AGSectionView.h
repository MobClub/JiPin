//
//  AGSectionView.h
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGSectionView : UIView
{
@private
    UILabel *_titleLabel;
}

@property (nonatomic,readonly) UILabel *titleLabel;

@end
