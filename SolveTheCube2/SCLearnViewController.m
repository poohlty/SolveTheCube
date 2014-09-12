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

@synthesize docView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

@end
