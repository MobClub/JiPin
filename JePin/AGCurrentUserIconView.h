//
//  AGCurrentUserIconView.h
//  JePin
//
//  Created by vimfung on 13-7-6.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import <AGCommon/CMImageView.h>
#import <AGCommon/CMImageCacheManager.h>

@interface AGCurrentUserIconView : UIView
{
@private
    CMImageLoader *_imageLoader;
    CMImageView *_imageView;
}

@end
