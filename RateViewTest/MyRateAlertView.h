//
//  MyRateAlertView.h
//  RateViewTest
//
//  Created by Mustafin Askar on 17.04.13.
//  Copyright (c) 2013 Crystal Spring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonProtocolDelegate;

@interface MyRateAlertView : UIView{

@private
    id <ButtonProtocolDelegate> _delegate;
}

@property CGFloat mainHeight;
@property (nonatomic, copy) NSString *textMessage;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, retain) UIFont *messageFont;
@property (nonatomic, retain) UIColor *textColor;

- (id)initWithMessage:(NSString *)message delegate:(id)delegate AppId:(NSString*)appId
    cancelButtonTitle:(NSString*)cancelbuttonTitle otherButtonTitles:(NSArray*)buttonTitles;
- (void)closeAnimationInView:(UIView*)view;
- (void)openAnimationInView:(UIView*)view;

@end

@protocol ButtonProtocolDelegate <NSObject>

- (void)closeButtonAciton;
- (void)aditionalButtonWith:(NSString*)title;

@end
