//
//  RegViewController.m
//  JePin
//
//  Created by 冯 鸿杰 on 13-8-20.
//  Copyright (c) 2013年 Chen GangQiang. All rights reserved.
//

#import "RegViewController.h"
#import <AGCommon/NSString+Common.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import <AGCommon/UINavigationBar+Common.h>

@implementation RegViewController

@synthesize delegate = _delegate;

- (id)initWithClientId:(NSString *)clientId
          clientSecret:(NSString *)clientSecret
           redirectUri:(NSString *)redirectUri
{
    if (self = [super init])
    {        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
        
        _clientId = [clientId copy];
        _clientSecret = [clientSecret copy];
        _redirectUri = [redirectUri copy];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[ShareSDKCoreService imageNamed:@"AuthView/CloseButton.png"] forState:UIControlStateNormal];
        [closeBtn sizeToFit];
        [closeBtn setFrame:CGRectMake(0.0, 0.0, 46.0, closeBtn.height)];
        [closeBtn addTarget:self action:@selector(closeBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:closeBtn] autorelease];
        
        self.title = @"注册用户";
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(_clientId);
    SAFE_RELEASE(_clientSecret);
    SAFE_RELEASE(_redirectUri);
    
    [super dealloc];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    ((UILabel *)self.navigationItem.titleView).text = title;
    [((UILabel *)self.navigationItem.titleView) sizeToFit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG.png"]];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_webView];
    _webView.delegate = self;
    [_webView release];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:
                           [NSURL URLWithString:@"http://m.weibo.cn/reg/index"]]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_isRegSuc)
    {
        if ([_delegate conformsToProtocol:@protocol(RegViewControllerDelegate)] &&
            [_delegate respondsToSelector:@selector(regSuccess)])
        {
            [_delegate regSuccess];
        }
    }
}

- (void)closeBtnClickHandler:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    id<ISSCParameters> params = [ShareSDKCoreService parametersWithQuery:request.URL.query];
    id act = [params parameterWithName:@"act"];
    if ([act isKindOfClass:[NSString class]] && [act isEqualToString:@"esuccess"])
    {
        _isRegSuc = YES;
        [self dismissModalViewControllerAnimated:YES];
    }
    
    return YES;
}

@end
