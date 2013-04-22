//
//  AppDevViewController.h
//  RateViewTest
//
//  Created by Mustafin Askar on 19.04.13.
//  Copyright (c) 2013 askar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDevViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>{
    
}

@end

@interface TableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *cellImageView;
@property (nonatomic, assign) UILabel *cellLabel;

@end