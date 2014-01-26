//
//  SinaWeiboTag.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "SinaWeiboTag.h"

@implementation SinaWeiboTag

@synthesize sourceData = _sourceData;
@synthesize Id;
@synthesize tag;

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
    
    id value = [sourceData objectForKey:@"id"];
    if (![value isKindOfClass:[NSNumber class]])
    {
        [_sourceData removeObjectForKey:@"id"];
    }
    
    value = [sourceData objectForKey:@"tag"];
    if (![value isKindOfClass:[NSString class]])
    {
        [_sourceData removeObjectForKey:@"tag"];
    }
}

- (long long)Id
{
    return [[_sourceData objectForKey:@"id"] longLongValue];
}

- (NSString *)tag
{
    return [_sourceData objectForKey:@"tag"];
}

+ (SinaWeiboTag *)tagWithResponse:(NSDictionary *)response
{
    SinaWeiboTag *tag = [[[SinaWeiboTag alloc] init] autorelease];
    tag.sourceData = response;
    return tag;
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
