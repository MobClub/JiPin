//
//  AGSinaWeiboStatusNoCommentCell.h
//  JePin
//
//  Created by Nogard on 13-7-10.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGSinaWeiboStatusNoCommentCell : UITableViewCell
{
    UIImageView *_myCellImageView;
}

+ (CGFloat)minCellHeightWithImage:(UIImage *)image;
- (id)initWithStyle:(UITableViewCellStyle)style
              image:(UIImage *)image
    reuseIdentifier:(NSString *)reuseIdentifier;

@end
