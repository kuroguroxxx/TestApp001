//
//  tfSecondViewController.m
//  TestApp001
//
//  Created by 高橋 聖二 on 12/07/24.
//  Copyright (c) 2012年 trifeed inc. All rights reserved.
//

#import "tfSecondViewController.h"

@interface tfSecondViewController ()

@end

@implementation tfSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)returnMain:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
