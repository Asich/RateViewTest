//
//  Test.m
//  RateViewTest
//
//  Created by Mustafin Askar on 18.04.13.
//  Copyright (c) 2013 askar. All rights reserved.
//

#import "Test.h"
#import <QuartzCore/QuartzCore.h>

@implementation Test

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;

}

- (void)drawRect:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [view setBackgroundColor:[UIColor redColor]];
    
    [self addSubview:view];
    [self animationWithView:view];
    NSLog(@"view retain count %lu",(unsigned long)view.retainCount);
    [view release];
    
    NSLog(@"view retain count %lu",(unsigned long)view.retainCount);
}

-(void)animationWithView:(UIView*)view{
    CGPoint centerPoint = CGPointMake(50 + view.frame.size.width / 2, 400);
    CGFloat alpha = 1;
    view.alpha = 0;
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         view.center = centerPoint;
                         view.alpha = alpha;
                     }
                     completion:^(BOOL finished){
                         
                         
                         NSLog(@"animation done");
                     }];
}

-(void)dealloc{
    [super dealloc];
}

@end
