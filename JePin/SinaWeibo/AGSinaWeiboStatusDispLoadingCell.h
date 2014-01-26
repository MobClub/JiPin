//
//  AGSinaWeiboStatusDispLoadingCell.h
//  JePin
//
//  Created by Nogard on 13-7-10.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGSinaWeiboStatusDispLoadingCell : UITableViewCell
{
@private
    UIActivityIndicatorView *_indicator;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              title:(NSString *)title;

@end
