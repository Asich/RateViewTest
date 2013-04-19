//
//  ViewController.m
//  RateViewTest
//
//  Created by Mustafin Askar on 17.04.13.
//  Copyright (c) 2013 askar. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"


@interface ViewController (){
    MyRateAlertView *rateView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
     rateView = [[MyRateAlertView alloc]initWithMessage:@"Like our App, please rate it on AppStore" delegate:self AppId:@"kAppId" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Rate"]];
    [self.view addSubview:rateView];
    [rateView release];

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

#pragma mark - MyRateAlertViewDelegate

-(void)aditionalButtonWith:(NSString *)title{
    NSLog(@"Button title: %@", title);
    
    if ([title isEqualToString:@"Rate"]){
        NSString *theUrl = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=409954448&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
    }
}

-(void)closeButtonAciton{
    NSLog(@"Close button");
    [rateView closeAnimationInView:rateView];
}

-(void)openView{
    [rateView openAnimationInView:rateView];
}

- (void)dealloc {
    [super dealloc];
}

@end
