//
//  AGLeftSideTableCell.m
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "AGLeftSideTableCell.h"

@implementation AGLeftSideTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AccessoryView.png"]] autorelease];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.accessoryView.frame = CGRectMake(250.0, self.accessoryView.top, self.accessoryView.width, self.accessoryView.height);
}

@end