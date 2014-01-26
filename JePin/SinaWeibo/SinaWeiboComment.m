//
//  SinaWeiboComment.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "SinaWeiboComment.h"
#import <SinaWeiboConnection/SSSinaWeiboStatus.h>

@implementation SinaWeiboComment

@synthesize sourceData = _sourceData;
@synthesize createdAt;
@synthesize Id;
@synthesize text;
@synthesize source;
@synthesize mid;
@synthesize user;
@synthesize status;
@synthesize replyComment;

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
    
    id value = [sourceData objectForKey:@"created_at"];
    if (![value isKindOfClass:[NSString class]])
    {
        [_sourceData removeObjectForKey:@"created_at"];
    }
    
    value = [sourceData objectForKey:@"id"];
    if (![value isKindOfClass:[NSNumber class]])
    {
        [_sourceData removeObjectForKey:@"id"];
    }
    
    value = [sourceData objectForKey:@"text"];
    if (![value isKindOfClass:[NSString class]])
    {
        [_sourceData removeObjectForKey:@"text"];
    }
    
    value = [sourceData objectForKey:@"source"];
    if (![value isKindOfClass:[NSString class]])
    {
        [_sourceData removeObjectForKey:@"source"];
    }
    
    value = [sourceData objectForKey:@"user"];
    if (![value isKindOfClass:[NSDictionary class]])
    {
        [_sourceData removeObjectForKey:@"user"];
    }
    else
    {
        [_sourceData setObject:[SSSinaWeiboUserInfoReader readerWithSourceData:value] forKey:@"user"];
    }
    
    value = [sourceData objectForKey:@"mid"];
    if (![value isKindOfClass:[NSString class]])
    {
        [_sourceData removeObjectForKey:@"mid"];
    }
    
    value = [sourceData objectForKey:@"idstr"];
    if (![value isKindOfClass:[NSString class]])
    {
        [_sourceData removeObjectForKey:@"idstr"];
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
    
    value = [sourceData objectForKey:@"reply_comment"];
    if (![value isKindOfClass:[NSDictionary class]])
    {
        [_sourceData removeObjectForKey:@"reply_comment"];
    }
    else
    {
        [_sourceData setObject:[SinaWeiboComment commentWithResponse:value] forKey:@"reply_comment"];
    }
}

- (NSString *)createdAt
{
    return [_sourceData objectForKey:@"created_at"];
}

- (long long)Id
{
    return [[_sourceData objectForKey:@"id"] longLongValue];
}

- (NSString *)idStr
{
    return [_sourceData objectForKey:@"idstr"];
}

- (NSString *)text
{
    return [_sourceData objectForKey:@"text"];
}

- (NSString *)source
{
    return [_sourceData objectForKey:@"source"];
}

- (NSString *)mid
{
    return [_sourceData objectForKey:@"mid"];
}

- (SSSinaWeiboUser *)user
{
    return [_sourceData objectForKey:@"user"];
}

- (SSSinaWeiboStatus *)status
{
    return [_sourceData objectForKey:@"status"];
}

- (SinaWeiboComment *)replyComment
{
    return [_sourceData objectForKey:@"reply_comment"];
}

+ (SinaWeiboComment *)commentWithResponse:(NSDictionary *)response
{
    SinaWeiboComment *comment = [[[SinaWeiboComment alloc] init] autorelease];
    comment.sourceData = response;
    return comment;
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
