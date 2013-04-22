//
//  AppDevViewController.m
//  RateViewTest
//
//  Created by Mustafin Askar on 19.04.13.
//  Copyright (c) 2013 askar. All rights reserved.
//

#import "AppDevViewController.h"

@interface AppDevViewController (){
    BOOL _pageControlIsChangingPage;
}

@property UIPageControl *pageControll;

@end

@implementation AppDevViewController

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

- (void)viewDidAppear:(BOOL)animated{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    scroll.delegate = self;
    [scroll setBackgroundColor:[UIColor blackColor]];
    [scroll setCanCancelContentTouches:NO];
    scroll.clipsToBounds = YES;
	scroll.scrollEnabled = YES;
	scroll.pagingEnabled = YES;
    
    _pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [_pageControll setFrame:CGRectMake((scroll.frame.size.width - _pageControll.frame.size.width)/2,
                                      scroll.frame.size.width - _pageControll.frame.size.width, 100, 20)];
    [_pageControll addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    
    NSUInteger nimages = 0;
	CGFloat cx = 0;
	for (; ; nimages++) {
		NSString *imageName = [NSString stringWithFormat:@"image%d.png", (nimages + 1)];
		UIImage *image = [UIImage imageNamed:imageName];
		if (image == nil) {
			break;
		}
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		CGRect rect = imageView.frame;
		rect.size.height = image.size.height;
		rect.size.width = image.size.width;
		rect.origin.x = ((scroll.frame.size.width - image.size.width) / 2) + cx;
		rect.origin.y = ((scroll.frame.size.height - image.size.height) / 2);
        
		imageView.frame = rect;
        
		[scroll addSubview:imageView];
        
		cx += scroll.frame.size.width;
        
        [imageView release];
	}
	
	_pageControll.numberOfPages = nimages;
	[scroll setContentSize:CGSizeMake(cx, [scroll bounds].size.height)];

    
    
    scroll.delegate = nil;
    [scroll release];
    [_pageControll release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (_pageControlIsChangingPage) {
        return;
    }
    
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControll.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    _pageControlIsChangingPage = NO;
}

#pragma mark - pagecontroll target

-(void)changePage:(id)sender{
    NSLog(@"value changed");
}

#pragma mark -
-(void)dealloc{
    [super dealloc];
}

@end
