//
//  AppDelegate.h
//  RateViewTest
//
//  Created by Mustafin Askar on 17.04.13.
//  Copyright (c) 2013 askar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class AppDevViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) AppDevViewController *appDevViewController;

@end
