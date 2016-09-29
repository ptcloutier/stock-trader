//
//  WebViewController.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/14/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    // if no internet , display alertcontroller with error report
    //[UIAlertController
    
//    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration  alloc]init];
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = self.view.bounds;
//                          WithFrame:self.view.bounds configuration:webConfig];
//    [webConfig release];
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.view addSubview:webView];

  
    [webView release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [_url release];
    [super dealloc];
}
@end
