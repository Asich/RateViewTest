//
//  ViewController.m
//  RateViewTest
//
//  Created by Mustafin Askar on 17.04.13.
//  Copyright (c) 2013 askar. All rights reserved.
//

#import "ViewController.h"
#import "AppDevViewController.h"
#import "BlockAlertView.h"


@interface ViewController ()

@end

@implementation ViewController

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self.navigationItem setTitle:@"Alert View"];
    UIBarButtonItem *goToTable = [[UIBarButtonItem alloc]initWithTitle:@"Go to table" style:UIBarButtonItemStylePlain target:self action:@selector(goToTableAction)];
    self.navigationItem.rightBarButtonItem = goToTable;
    [goToTable release];
    
    
    BlockAlertView *alert = [BlockAlertView alertWithMessage:@"Like our app? Please, rate it on App Store!"];
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert addButtonWithTitle:@"Rate" block:^{
        [self showActionSheet:nil];
    }];
    [alert show];
    

    
    UIButton *openRateViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [openRateViewButton addTarget:self action:@selector(openView) forControlEvents:UIControlEventTouchUpInside];
    [openRateViewButton setFrame:CGRectMake((self.view.frame.size.width - openRateViewButton.frame.size.width )/2 - 25, 0, 20, 20)];
    [self.view addSubview:openRateViewButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"memory warning");
}
////////////////////////////////////////////////////////////////////////////////
#pragma mark - MyRateAlertViewDelegate

//

- (void)showActionSheet:(id)sender{

        NSString *theUrl = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=409954448&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}


////////////////////////////////////////////////////////////////////////////////
- (void)openView{
    BlockAlertView *alert = [BlockAlertView alertWithMessage:@"asdfadsfasdf"];
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert addButtonWithTitle:@"Rate" block:^{
        [self showActionSheet:nil];
    }];
    [alert show];
}

- (void)goToTableAction{
    AppDevViewController *appDevViewController = [[[AppDevViewController alloc] init]autorelease];
    [self.navigationController pushViewController:appDevViewController animated:YES];
    //[appDevViewController release];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    //[_rateView release];
    [super dealloc];
}

@end
