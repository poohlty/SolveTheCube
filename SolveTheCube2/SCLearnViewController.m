//
//  SCLearnViewController.m
//  SolveTheCube2
//
//  Created by Tianyu Liu on 2/14/13.
//  Copyright (c) 2013 Tianyu Liu. All rights reserved.
//

#import "SCLearnViewController.h"

@interface SCLearnViewController ()

@end

@implementation SCLearnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.docView.backgroundColor = [UIColor whiteColor];
    [self loadTutorial];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadTutorial
{
    [self loadView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tutorial.pdf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.docView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Hacky solution from http://stackoverflow.com/questions/25813551/rendering-pdf-in-uiwebview-ios-8-causes-a-black-border-around-pdf
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Assuming self.webView is our UIWebView
    // We go though all sub views of the UIWebView and set their backgroundColor to white
    UIView *v = self.docView;
    while (v) {
        v.backgroundColor = [UIColor whiteColor];
        v = [v.subviews firstObject];
    }
}

@end
