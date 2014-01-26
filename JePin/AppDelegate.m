//
//  AppDelegate.m
//  JePin
//
//  Created by Chen GangQiang on 13-4-28.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"

#import "RootViewController.h"
#import "LeftSideViewController.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <AGCommon/NSString+Common.h>
#import "WeiboApi.h"

@implementation AppDelegate

@synthesize authOptions = _authOptions;
@synthesize imageCacheManager = _imageCacheManager;
@synthesize viewController;

- (void)dealloc
{
    [_imageCacheManager release];
    [_window release];
    [_authOptions release];
    SAFE_RELEASE(_viewDelegate);
    [super dealloc];
}

- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"474962333"
                               appSecret:@"26522c6ed236057fd4ff5005449f98e9"
                             redirectUri:@"http://www.sharesdk.cn"];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801384905"
                                  appSecret:@"70a51f4413b732e07fae2c0049816716"
                                redirectUri:@"https://itunes.apple.com/cn/app/id673022694"
                                   wbApiCls:[WeiboApi class]];
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100483086"
                           appSecret:@"013e980d304f99c9f61d1e96c53b98db"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    /**
     连接网易微博应用以使用相关功能，此应用需要引用T163WeiboConnection.framework
     http://open.t.163.com上注册网易微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    /**
     连接搜狐微博应用以使用相关功能，此应用需要引用SohuWeiboConnection.framework
     http://open.t.sohu.com上注册搜狐微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuWeiboWithConsumerKey:@"RNAo8NhLqZApnGIglYIT"
                               consumerSecret:@"5Q%R)ZLLND5TiQ=w3yVNxJfCT7otxD!RXTHhO0HW"
                                  redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接豆瓣应用以使用相关功能，此应用需要引用DouBanConnection.framework
     http://developers.douban.com上注册豆瓣社区应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
                            appSecret:@"9f1e7b4f71304f2f"
                          redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     //     **/
    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                            appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
    
    /**
     连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
     http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
                            appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    /**
     连接Instapaper应用以使用相关功能，此应用需要引用InstapaperConnection.framework
     http://www.instapaper.com/main/request_oauth_consumer_token上注册Instapaper应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    /**
     连接有道云笔记应用以使用相关功能，此应用需要引用YouDaoNoteConnection.framework
     http://note.youdao.com/open/developguide.html#app上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
    /**
     连接Facebook应用以使用相关功能，此应用需要引用FacebookConnection.framework
     https://developers.facebook.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    /**
     连接Twitter应用以使用相关功能，此应用需要引用TwitterConnection.framework
     https://dev.twitter.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接搜狐随身看应用以使用相关功能，此应用需要引用SohuConnection.framework
     https://open.sohu.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
                             appSecret:@"b8eec53707c3976efc91614dd16ef81c"
                           redirectUri:@"http://sharesdk.cn"];
    
    /**
     连接Pocket应用以使用相关功能，此应用需要引用PocketConnection.framework
     http://getpocket.com/developer/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectPocketWithConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
                               redirectUri:@"pocketapp1234"];
    
    /**
     连接印象笔记应用以使用相关功能，此应用需要引用EverNoteConnection.framework
     http://dev.yinxiang.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"sharesdk-7807"
                       consumerSecret:@"d05bf86993836004"];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100483086"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxc43c2c004120810f" wechatCls:[WXApi class]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //ShareSDK
    [ShareSDK registerApp:@"5872bee16b6"];
    [self initializePlat];
    
    //设置预设
    if (![ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
    {
        id<ISSPlatformCredential> cred = [ShareSDK credentialWithType:ShareTypeSinaWeibo
                                                                  uid:USER_ID
                                                                token:@"2.00n5FpTD0n5tIW0a097e8f46rSXoEC"
                                                               secret:nil
                                                              expired:[NSDate dateWithTimeIntervalSince1970:1389466799]
                                                              extInfo:nil];
        [ShareSDK setCredential:cred type:ShareTypeSinaWeibo];
    }
    
    //APPSTORE评分
    [Appirater setAppId:APPID];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];

    _viewDelegate = [[AGViewDelegate alloc] init];
    _authOptions = [[ShareSDK authOptionsWithAutoAuth:YES
                                       allowCallback:NO
                                       authViewStyle:SSAuthViewStyleModal
                                        viewDelegate:_viewDelegate
                             authManagerViewDelegate:_viewDelegate]
                    retain];
    
    //在授权页面中添加关注官方微博
    [_authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [ShareSDK userFieldWithType:SSUserFieldTypeName value:TARGET_USER_NAME],
                                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                     nil]];
    
    //监听用户信息变更
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
    

    _imageCacheManager = [[CMImageCacheManager alloc] init];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    RootViewController *rootVC = [[[RootViewController alloc] init] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:rootVC] autorelease];
    
    
    //左视图
    LeftSideViewController *leftVC = [[[LeftSideViewController alloc] init] autorelease];
    
    IIViewDeckController *vc = [[[IIViewDeckController alloc] initWithCenterViewController:navController leftViewController:leftVC] autorelease];
    vc.enabled = NO;
    vc.delegate = self;
    self.viewController = vc;
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        //iOS 7.0
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGSize size = self.window.bounds.size;
    size.height -= statusHeight;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}

- (void)shareStatus:(SSSinaWeiboStatusInfoReader *)status
{
    id<ISSContent> content = nil;
    if (status.originalPic)
    {
        
        content = [ShareSDK content:status.text
                     defaultContent:nil
                              image:[ShareSDK imageWithUrl:status.originalPic]
                              title:@"分享"
                                url:@"http://weibo.com/2588520?topnav=1&wvr=5&topsug=1"
                        description:@"【人生在世，总会遇到让你爆表的极品前任！！私信我！晒出那些贱人吧！！】极品霏合作电影《我的前任是极品》，很多大明星会参演哦。（≧∇≦）"
                          mediaType:SSPublishContentMediaTypeText];
        
        
    }
    else
    {
        content = [ShareSDK content:status.text
                     defaultContent:nil
                              image:nil
                              title:@"分享"
                                url:@"http://weibo.com/2588520?topnav=1&wvr=5&topsug=1"
                        description:@"【人生在世，总会遇到让你爆表的极品前任！！私信我！晒出那些贱人吧！！】极品霏合作电影《我的前任是极品》，很多大明星会参演哦。（≧∇≦）"
                          mediaType:SSPublishContentMediaTypeText];
    }
    
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          [ShareSDK shareContent:content
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:_authOptions
                                                                                   statusBarTips:YES
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                             
                                                                                              if (state == SSResponseStateSuccess)
                                                                                              {
                                                                                                  NSLog(@"分享成功");
                                                                                              }
                                                                                              else if (state == SSResponseStateFail)
                                                                                              {
                                                                                                  NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    //自定义腾讯微博分享菜单项
    id<ISSShareActionSheetItem> tencentItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                                                 icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                                         clickHandler:^{
                                                                             [ShareSDK shareContent:content
                                                                                               type:ShareTypeTencentWeibo
                                                                                        authOptions:_authOptions
                                                                                      statusBarTips:YES
                                                                                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                 
                                                                                                 if (state == SSResponseStateSuccess)
                                                                                                 {
                                                                                                     NSLog(@"分享成功");
                                                                                                 }
                                                                                                 else if (state == SSResponseStateFail)
                                                                                                 {
                                                                                                     NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                                 }
                                                                                             }];
                                                                         }];
    //自定义QQ空间分享菜单项
    id<ISSShareActionSheetItem> qzoneItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]
                                                                               icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]
                                                                       clickHandler:^{
                                                                           [ShareSDK shareContent:content
                                                                                             type:ShareTypeQQSpace
                                                                                      authOptions:_authOptions
                                                                                    statusBarTips:YES
                                                                                           result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                               
                                                                                               if (state == SSResponseStateSuccess)
                                                                                               {
                                                                                                   NSLog(@"分享成功");
                                                                                               }
                                                                                               else if (state == SSResponseStateFail)
                                                                                               {
                                                                                                   NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                               }
                                                                                           }];
                                                                       }];
    
    //自定义Facebook分享菜单项
    id<ISSShareActionSheetItem> fbItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeFacebook]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeFacebook]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeFacebook
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义Twitter分享菜单项
    id<ISSShareActionSheetItem> twItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTwitter]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeTwitter]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeTwitter
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义人人网分享菜单项
    id<ISSShareActionSheetItem> rrItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeRenren]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeRenren]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeRenren
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义开心网分享菜单项
    id<ISSShareActionSheetItem> kxItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeKaixin]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeKaixin]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeKaixin
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义搜狐微博分享菜单项
    id<ISSShareActionSheetItem> shItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSohuWeibo]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeSohuWeibo]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeSohuWeibo
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义网易微博分享菜单项
    id<ISSShareActionSheetItem> wyItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareType163Weibo]
                                                                            icon:[ShareSDK getClientIconWithType:ShareType163Weibo]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareType163Weibo
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义豆瓣分享菜单项
    id<ISSShareActionSheetItem> dbItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeDouBan]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeDouBan]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeDouBan
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义Instapaper分享菜单项
    id<ISSShareActionSheetItem> ipItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeInstapaper]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeInstapaper]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeInstapaper
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    //自定义有道云笔记分享菜单项
    id<ISSShareActionSheetItem> ydItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeYouDaoNote]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeYouDaoNote]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypeYouDaoNote
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //自定义搜狐随身看分享菜单项
    id<ISSShareActionSheetItem> shkItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSohuKan]
                                                                             icon:[ShareSDK getClientIconWithType:ShareTypeSohuKan]
                                                                     clickHandler:^{
                                                                         [ShareSDK shareContent:content
                                                                                           type:ShareTypeSohuKan
                                                                                    authOptions:_authOptions
                                                                                  statusBarTips:YES
                                                                                         result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                             
                                                                                             if (state == SSResponseStateSuccess)
                                                                                             {
                                                                                                 NSLog(@"分享成功");
                                                                                             }
                                                                                             else if (state == SSResponseStateFail)
                                                                                             {
                                                                                                 NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                             }
                                                                                         }];
                                                                     }];
    
    //自定义印象笔记分享菜单项
    id<ISSShareActionSheetItem> evnItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeEvernote]
                                                                             icon:[ShareSDK getClientIconWithType:ShareTypeEvernote]
                                                                     clickHandler:^{
                                                                         [ShareSDK shareContent:content
                                                                                           type:ShareTypeEvernote
                                                                                    authOptions:_authOptions
                                                                                  statusBarTips:YES
                                                                                         result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                             
                                                                                             if (state == SSResponseStateSuccess)
                                                                                             {
                                                                                                 NSLog(@"分享成功");
                                                                                             }
                                                                                             else if (state == SSResponseStateFail)
                                                                                             {
                                                                                                 NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                             }
                                                                                         }];
                                                                     }];
    
    //自定义Pocket分享菜单项
    id<ISSShareActionSheetItem> pkItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypePocket]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypePocket]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:content
                                                                                          type:ShareTypePocket
                                                                                   authOptions:_authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSResponseStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSResponseStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          sinaItem,
                          tencentItem,
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          qzoneItem,
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          fbItem,
                          twItem,
                          rrItem,
                          kxItem,
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          SHARE_TYPE_NUMBER(ShareTypeAirPrint),
                          SHARE_TYPE_NUMBER(ShareTypeCopy),
                          shItem,
                          wyItem,
                          dbItem,
                          evnItem,
                          pkItem,
                          ipItem,
                          ydItem,
                          shkItem,
                          nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:content
                     statusBarTips:YES
                       authOptions:_authOptions
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"发表成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark - Private

- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    platName = [ShareSDK getClientNameWithType:plat];
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

#pragma mark - IIViewDeckControllerDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    viewDeckController.centerController.view.userInteractionEnabled = NO;
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    viewDeckController.centerController.view.userInteractionEnabled = YES;
}

@end
