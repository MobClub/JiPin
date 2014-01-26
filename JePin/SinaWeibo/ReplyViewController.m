//
//  ReplyViewController.m
//  JePin
//
//  Created by vimfung on 13-5-4.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "ReplyViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <SinaWeiboConnection/SinaWeiboConnection.h>
#import <AGCommon/UINavigationBar+Common.h>
#import "UILabel+AGJiPinConfig.h"
#import "AGJiPinStyle.h"
#import "AppDelegate.h"

@implementation ReplyViewController

- (id)initWithStatus:(SSSinaWeiboStatusInfoReader *)status
                type:(ReplyViewControllerType)type
     commentComplete:(void (^)())commentComplete
{
    self = [super init];
    if (self)
    {
        _status = [status retain];
        _type = type;
        _commentComplete = [commentComplete copy];
        
        switch (_type)
        {
            case ReplyViewControllerTypeComment:
                self.title = @"评论";
                break;
            case ReplyViewControllerTypeReply:
                self.title = @"转发";
                break;
            default:
                break;
        }

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label applyStyle:[AGJiPinStyle NavigationBarTitleStyle]];
        label.textAlignment = NSTextAlignmentCenter; // ^-Use UITextAlignmentCenter for older SDKs.
        label.text = self.title;
        self.navigationItem.titleView = label;
        [label sizeToFit];
        [label release];

        AGJiPinStyle *style = [AGJiPinStyle NavigationBarItemStyle];
        UIBarButtonItem *leftBarItem, *rightBarItem;
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"BackButtonBG.png"] forState:UIControlStateNormal];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
        [leftButton setTitleColor:style.foregroundColor forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:style.font];
        [leftButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [leftButton addTarget:self action:@selector(cancelButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        [leftButton sizeToFit];
        [leftButton release];

        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"PublishButtonBG.png"] forState:UIControlStateNormal];
        [rightButton setTitle:@"发表" forState:UIControlStateNormal];
        [rightButton setTitleColor:style.foregroundColor forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:style.font];
        [leftButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [rightButton addTarget:self action:@selector(publishButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        [rightButton sizeToFit];
        [rightButton release];
        
        self.navigationItem.leftBarButtonItem = leftBarItem;
        self.navigationItem.rightBarButtonItem = rightBarItem;
        [leftBarItem release];
        [rightBarItem release];
                
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowHandler:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideHandler:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SAFE_RELEASE(_status);
    SAFE_RELEASE(_commentComplete);
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];

    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_textView];
    [_textView release];
    
    [_textView becomeFirstResponder];
}

#pragma mark - Private

- (void)keyboardWillShowHandler:(NSNotification *)notif
{
    CGRect keyboardFrame;
    NSValue *value =[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    [value getValue:&keyboardFrame];
    
    _textView.frame = CGRectMake(0.0, 0.0, self.view.width, self.view.height - keyboardFrame.size.height);
}

- (void)keyboardWillHideHandler:(NSNotification *)notif
{
    _textView.frame = self.view.bounds;
}

- (void)cancelButtonClickHandler:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doPublish
{
    switch (_type)
    {
        case ReplyViewControllerTypeComment:
        {
            id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
            id<ISSCParameters> params = [ShareSDKCoreService parameters];
            [params addParameter:@"id" value:_status.idstr];
            [params addParameter:@"comment" value:_textView.text];
            
            [sinaApp api:@"https://api.weibo.com/2/comments/create.json"
                  method:SSSinaWeiboRequestMethodPost
                  params:params
                    user:nil
                  result:^(id responder) {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                          message:@"评论成功!"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"知道了"
                                                                otherButtonTitles:nil];
                      [alertView show];
                      [alertView release];
                      
                      if (_commentComplete)
                      {
                          ((void(^)())_commentComplete)();
                      }
                      
                      [self dismissModalViewControllerAnimated:YES];
                  }
                   fault:^(CMErrorInfo *error) {
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                           message:@"评论失败!"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"知道了"
                                                                 otherButtonTitles:nil];
                       [alertView show];
                       [alertView release];
                   }];
            
            break;
        }
        case ReplyViewControllerTypeReply:
        {
            id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
            id<ISSCParameters> params = [ShareSDKCoreService parameters];
            [params addParameter:@"id" value:_status.idstr];
            if (![_textView.text isEqualToString:@""])
            {
                [params addParameter:@"status" value:_textView.text];
            }
            
            [sinaApp api:@"https://api.weibo.com/2/statuses/repost.json"
                  method:SSSinaWeiboRequestMethodPost
                  params:params
                    user:nil
                  result:^(id responder) {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                          message:@"转发成功!"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"知道了"
                                                                otherButtonTitles:nil];
                      [alertView show];
                      [alertView release];
                      
                      [self dismissModalViewControllerAnimated:YES];
                  }
                   fault:^(CMErrorInfo *error) {
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                           message:@"转发失败!"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"知道了"
                                                                 otherButtonTitles:nil];
                       [alertView show];
                       [alertView release];
                   }];
            break;
        }
        default:
            [self dismissModalViewControllerAnimated:YES];
            break;
    }
}

- (void)publishButtonClickHandler:(id)sender
{
    if (_type == ReplyViewControllerTypeComment && [_textView.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入内容"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if ([[(id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo] currentUser].uid isEqualToString:USER_ID])
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [ShareSDK authWithType:ShareTypeSinaWeibo
                       options:appDelegate.authOptions
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {
                            
                            if (state == SSAuthStateSuccess)
                            {
                                [self doPublish];
                            }
                            
                        }];
    }
    else
    {
        [self doPublish];
    }
}

@end
