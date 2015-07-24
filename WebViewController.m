//
//  WebViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 4/1/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.webView loadRequest:[NSURLRequest requestWithURL:_URL]];
 
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
