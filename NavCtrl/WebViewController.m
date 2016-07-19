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
@property (retain, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) WKWebViewConfiguration *webConfig;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webConfig = [[WKWebViewConfiguration alloc]init];
    self.webView = [[WKWebView alloc]initWithFrame:[[UIScreen mainScreen]bounds] configuration:self.webConfig];
    
    self.view = self.webView;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)return:(id)sender {//doesnt work yet
//    
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
@end
