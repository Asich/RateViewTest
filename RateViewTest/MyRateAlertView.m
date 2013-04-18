//
//  MyRateAlertView.m
//  RateViewTest
//
//  Created by Mustafin Askar on 17.04.13.
//  Copyright (c) 2013 Crystal Spring. All rights reserved.
//

#import "MyRateAlertView.h"
#import <QuartzCore/QuartzCore.h>

#define kViewWidth 250 // do not change!
#define kViewHeight 200
#define kTopIndent 30
#define kFootIndent 30
#define kMiddleIndent 5

#define kAlertViewMessageFont           [UIFont systemFontOfSize:18]
#define kAlertViewMessageTextColor      [UIColor colorWithWhite:244.0/255.0 alpha:1.0]
#define kAlertViewMessageShadowColor    [UIColor blackColor]
#define kAlertViewMessageShadowOffset   CGSizeMake(0, -1)

#define NeedsLandscapePhoneTweaks (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)

#define kAlertViewBorder         
#define kAlertViewImageBorder    (NeedsLandscapePhoneTweaks ? 5 : 68)
#define kAlertButtonHeight       (NeedsLandscapePhoneTweaks ? 35 : 44)
#define kViewLeftBorder ([UIScreen mainScreen].bounds.size.width - kViewWidth)/2

#define kTransitionDuration 2

#pragma mark -
#pragma mark -

@interface MyRateAlertView(){
    BOOL isViewClosed;
}

@property (nonatomic, copy) NSString* cancelButtonTitle;
@property UIImageView *iconView;
@property UIImageView *viewBackgroundImage;

@end

@implementation MyRateAlertView

- (id)initWithMessage:(NSString *)message
             delegate:(id)delegate
                AppId:(NSString*)appId
    cancelButtonTitle:(NSString*)cancelbuttonTitle
    otherButtonTitles:(NSArray*)buttonTitles{
    
    self = [super init];
    if(self){
        [self setFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        _appId = appId;
        _textColor = kAlertViewMessageTextColor;
        _textMessage = message;
        _cancelButtonTitle = cancelbuttonTitle;
        _delegate = delegate;
        _buttonTitles = buttonTitles;
        _viewBackgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                    kViewWidth, kViewHeight)];
        isViewClosed = YES;
        [self addSubview:_viewBackgroundImage];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self addComponents];
    [self openAnimationInView:self];
}

- (void)addComponents {
    //Add iconImage
    UIImage *appIconImage = [UIImage imageNamed:@"Icon@2x.png"];
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake
                 ((_viewBackgroundImage.frame.size.width - appIconImage.size.width)/2,
                                                                 kTopIndent,
                                                                 114.0, 114.0)];
    _iconView.image = appIconImage;
    //rounded corners using QuartzCore frameword
    CALayer * caLayer = [_iconView layer];
    [caLayer setMasksToBounds:YES];
    [caLayer setCornerRadius:10.0];
    
    //calc mainHeight after iconImage
    _mainHeight += _iconView.frame.size.height + kTopIndent + kMiddleIndent;
    
    //Add TextMessage label
    //perform lineBreaks and calc size of label
    CGSize size = [_textMessage sizeWithFont:kAlertViewMessageFont
                               constrainedToSize:CGSizeMake(self.frame.size.width-10*2, 1000)
                                   lineBreakMode:NSLineBreakByWordWrapping];

    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                   _mainHeight,
                                                                   self.frame.size.width-10*2,
                                                                   size.height)];
    labelView.font = _messageFont;
    labelView.numberOfLines = 0;
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.textColor = _textColor;
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.shadowColor = kAlertViewMessageShadowColor;
    labelView.shadowOffset = kAlertViewMessageShadowOffset;
    labelView.text = _textMessage;
    
    //calc mainHeight after uiLabel
    _mainHeight += size.height + kMiddleIndent;
    
    //Add Buttons
    UIImage *blackBtnBackImageStateNormal = [[UIImage imageNamed:@"action-black-button.png"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(37, 22, 10, 22)];
    
    if (_cancelButtonTitle){
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton addTarget:self
                         action:@selector(closeButtonAction)
               forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:kAlertViewMessageTextColor forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:blackBtnBackImageStateNormal forState:UIControlStateNormal];
        
        if([self.buttonTitles count] == 1){
            cancelButton.frame = CGRectMake(10, _mainHeight, 220/2, 44.0);
        }else{
            cancelButton.frame = CGRectMake(10, _mainHeight, 230, 44.0);
            _mainHeight += cancelButton.frame.size.height + kMiddleIndent;
        }
        [self addSubview:cancelButton];
    }
    
    NSLog(@"button number: %lu", (unsigned long)[_buttonTitles count]);
    
    for(int i = 0; i < [_buttonTitles count]; i++){
        UIButton *aditionalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [aditionalButton addTarget:self action:@selector(passButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
        [aditionalButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [aditionalButton setTitleColor:kAlertViewMessageTextColor forState:UIControlStateNormal];
        [aditionalButton setBackgroundImage:blackBtnBackImageStateNormal forState:UIControlStateNormal];
        
        if ([_buttonTitles count] < 2){
            aditionalButton.frame = CGRectMake(5 + 120 + 2.6, _mainHeight, 220/2, 44.0);
            _mainHeight += aditionalButton.frame.size.height + kMiddleIndent;
            
        }else{
            aditionalButton.frame = CGRectMake(10, _mainHeight, 230, 44.0);
            _mainHeight += aditionalButton.frame.size.height + kMiddleIndent;
        }
        [self addSubview:aditionalButton];
    }
    
    _mainHeight += kMiddleIndent;
    [self setFrame:CGRectMake(kViewLeftBorder, -300, kViewWidth, _mainHeight)];
    UIImage *backgroundImage = [UIImage imageNamed:@"alert-window.png"];
    [_viewBackgroundImage setImage:[backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 140, 10, 140)]];
    CGRect gameArea = CGRectMake(0, 0, kViewWidth, _mainHeight);
    [_viewBackgroundImage setFrame:gameArea];
    [self addSubview:_iconView];
    [self addSubview:labelView];
    
    [labelView release];
}

#pragma mark - button actions
- (void)passButtonTitle:(id)sender
{
    UIButton *clicked = (UIButton *) sender;
    [_delegate aditionalButtonWith:clicked.currentTitle];
}

- (void)closeButtonAction {
	[_delegate closeButtonAciton];
}

- (void)dealloc{
    [_viewBackgroundImage release];
    [super dealloc];
}

#pragma mark - view open/close animation

- (void)closeAnimationInView:(UIView*)view{
    if(isViewClosed == NO){
        CGPoint centerPoint = CGPointMake(kViewLeftBorder + view.frame.size.width / 2, -300 + view.frame.size.height / 2);
        CGFloat alpha = 0;
        view.alpha = 1;
        [UIView animateWithDuration:.4
                              delay:0
                            options: UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                             view.center = centerPoint;
                             view.alpha = alpha;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"close animation done");
                         }];
        isViewClosed = YES;
    }else{
        return;
    }
}

- (void)openAnimationInView:(UIView*)view{
    if(isViewClosed == YES){
        CGFloat startyPosition = view.frame.origin.y + view.frame.size.height;
        CGFloat endyPosition = 100 + view.frame.origin.y + view.frame.size.height;
        CGFloat offset = .2*(endyPosition - startyPosition);
        CGFloat alpha = 1;
        view.alpha = 0;
        [UIView animateWithDuration:.4 animations:^{
            CGRect frame = view.frame;
            frame.origin.y = endyPosition + offset;
            view.frame = frame;
            view.alpha = alpha;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:.1 animations:^{
                CGRect frame = view.frame;
                frame.origin.y = endyPosition;
                view.frame = frame;
            }];
        }];
        isViewClosed = NO;
    }else{
        return;
    }
}
@end