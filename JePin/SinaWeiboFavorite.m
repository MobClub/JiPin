//
//  SinaWeiboFavorite.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "SinaWeiboFavorite.h"
#import "SinaWeiboTag.h"

@implementation SinaWeiboFavorite

@synthesize sourceData = _sourceData;
@synthesize favoritedTime;
@synthesize status;
@synthesize tags;

- (id)init
{
    if (self = [super init])
    {
        _sourceData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(_sourceData);
    [super dealloc];
}

- (void)setSourceData:(NSDictionary *)sourceData
{
    [_sourceData removeAllObjects];
    [_sourceData addEntriesFromDictionary:sourceData];
    
    id value = [sourceData objectForKey:@"favorited_time"];
    if (![value isKindOfClass:[NSString class]])
    {
        [_sourceData removeObjectForKey:@"favorited_time"];
    }
    
    value = [sourceData objectForKey:@"tags"];
    if (![value isKindOfClass:[NSArray class]])
    {
        [_sourceData removeObjectForKey:@"tags"];
    }
    else
    {
        NSMutableArray *tagsArr = [NSMutableArray array];
        for (int i = 0; i < [value count]; i++)
        {
            id item = [value objectAtIndex:i];
            if ([item isKindOfClass:[NSDictionary class]])
            {
                [tagsArr addObject:[SinaWeiboTag tagWithResponse:item]];
            }
        }
        
        [_sourceData setObject:tagsArr forKey:@"tags"];
    }
        
    value = [sourceData objectForKey:@"status"];
    if (![value isKindOfClass:[NSDictionary class]])
    {
        [_sourceData removeObjectForKey:@"status"];
    }
    else
    {
        [_sourceData setObject:[SSSinaWeiboStatusInfoReader readerWithSourceData:value] forKey:@"status"];
    }
}

- (NSString *)favoritedTime
{
    return [_sourceData objectForKey:@"favorited_time"];
}

- (NSArray *)tags
{
    return [_sourceData objectForKey:@"tags"];
}

- (SSSinaWeiboStatusInfoReader *)status
{
    return [_sourceData objectForKey:@"status"];
}

+ (SinaWeiboFavorite *)favoriteWithResponse:(NSDictionary *)response
{
    SinaWeiboFavorite *favorite = [[[SinaWeiboFavorite alloc] init] autorelease];
    favorite.sourceData = response;
    return favorite;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_sourceData forKey:@"source"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        id value = [aDecoder decodeObjectForKey:@"source"];
        if ([value isKindOfClass:[NSDictionary class]])
        {
            
            _sourceData = [[NSMutableDictionary alloc] initWithDictionary:value];
        }
        else
        {
            _sourceData = [[NSMutableDictionary alloc] init];
        }
    }
    
    return self;
}

@end
