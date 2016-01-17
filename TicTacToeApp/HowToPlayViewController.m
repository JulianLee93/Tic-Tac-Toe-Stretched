//
//  HowToPlayViewController.m
//  TicTacToeApp
//
//  Created by Julian Lee on 1/16/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "HowToPlayViewController.h"

@interface HowToPlayViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HowToPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://en.wikipedia.org/wiki/Tic-tac-toe"]]];
}




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
