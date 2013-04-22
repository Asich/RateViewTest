//
//  AppDevViewController.m
//  RateViewTest
//
//  Created by Mustafin Askar on 19.04.13.
//  Copyright (c) 2013 askar. All rights reserved.
//

#import "AppDevViewController.h"
#import "JSONKit.h"

#define kurl @"http://itunes.apple.com/lookup?id=524731580"

@interface AppDevViewController (){
    BOOL _pageControlIsChangingPage;
}

@property (nonatomic) UIPageControl *pageControll;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSMutableData *data;
@property (nonatomic, copy) NSMutableDictionary *dictionary;
@property NSURLConnection *urlConnection;
@property (nonatomic, copy) NSMutableArray *arrayOfImages;
@property (nonatomic, copy) NSMutableArray *arrayOfLabels;

@end

@implementation AppDevViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:kurl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _urlConnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
    [_urlConnection start];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    _scrollView.delegate = self;
    [_scrollView setBackgroundColor:[UIColor blackColor]];
    [_scrollView setCanCancelContentTouches:NO];
    _scrollView.clipsToBounds = YES;
	_scrollView.scrollEnabled = YES;
	_scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [_pageControll setFrame:CGRectMake((_scrollView.frame.size.width - _pageControll.frame.size.width)/2,
                                      _scrollView.frame.size.height - _pageControll.frame.size.height, 100, 20)];
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
        imageView.clipsToBounds = YES;
		CGRect rect = imageView.frame;
		rect.size.height = image.size.height;
		rect.size.width = image.size.width;
		rect.origin.x = ((_scrollView.frame.size.width - image.size.width) / 2) + cx;
		rect.origin.y = ((_scrollView.frame.size.height - image.size.height) / 2);
        
		imageView.frame = rect;
        
		[_scrollView addSubview:imageView];
        
		cx += _scrollView.frame.size.width;
        
        [imageView release];
	}
	
	_pageControll.numberOfPages = nimages;
    _pageControll.currentPage = 0;
    //[_pageControll setBackgroundColor:[UIColor redColor]];
    
	[_scrollView setContentSize:CGSizeMake(cx, [_scrollView bounds].size.height)];

    //tableview
    _tableView = [[UITableView alloc]initWithFrame:
                                                               CGRectMake(0,
                                              _scrollView.frame.size.height,
                                                 self.view.frame.size.width,
                self.view.frame.size.height - _scrollView.frame.size.height)
                                               style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControll];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_pageControlIsChangingPage) {
        return;
    }
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControll.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    _pageControlIsChangingPage = NO;
}

#pragma mark - pagecontroll target

- (void)changePage:(id)sender{
    
    /*
	 *	Change the scroll view
	 */
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _pageControll.currentPage;
    frame.origin.y = 0;
	
    [_scrollView scrollRectToVisible:frame animated:YES];
    
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    _pageControlIsChangingPage = YES;
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _data = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{
    [_data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    JSONDecoder *decoder = [[JSONDecoder alloc]init];
    _dictionary = [decoder objectWithData:_data];
    NSLog(@"dict: %@", _dictionary);
    
//    //filter by keys
//    arrayOfNames = [[NSMutableArray alloc]init];
//    arrayOfImages = [[NSMutableArray alloc]init];
//    arrayOfCategoryIndexes = [[NSMutableArray alloc]init];
//    for (id key in dictionary) {
//        id anObject = [dictionary objectForKey:key];
//        [arrayOfNames addObject:[anObject objectForKey:@"name"]];
//        NSString *str = [NSString stringWithFormat:@"http://floral.kz/%@",[anObject objectForKey:@"image_url"]];
//        [arrayOfCategoryIndexes addObject:[anObject objectForKey:@"id"]];
//        [arrayOfImages addObject:str];
//    }
    [_tableView reloadData];
    [decoder release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"Пожалуйста, убедитесь что Вы подключены к 3G или Wi-Fi" delegate:nil cancelButtonTitle:@"Отклонить" otherButtonTitles:nil];
    [alertView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [alertView release];
}


#pragma mark -
-(void)dealloc{
     _scrollView.delegate = nil;
    [_scrollView release];
    [_pageControll release];
    
    _tableView.delegate = nil;
    [_tableView release];
    
    [_data release];
    [_urlConnection release];
    
    [super dealloc];
}

@end

//#pragma mark - table viewcell
//
//@implementation TableViewCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self setFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
//        _cellImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)]autorelease];
//        
//        
//        _cellImageView.contentMode = UIViewContentModeScaleToFill;
//    }
//    return self;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
//
//@end
