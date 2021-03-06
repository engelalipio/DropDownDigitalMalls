//
//  HomeViewController.h
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 10/24/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDataSource,UIAlertViewDelegate,ADBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *btnLight;
@property (strong, nonatomic) IBOutlet UIButton *btnAds;
@property (weak, nonatomic) IBOutlet UILabel *imageBorderLabel;

@property (strong,nonatomic)  NSArray *pageTitles;
@property (strong,nonatomic)  NSArray *pageImages;

@property (nonatomic, assign) NSUInteger currentPageIndex;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (nonatomic,strong) NSTimer   *timer;
@property (nonatomic,strong) NSRunLoop *loop;
@property (strong, nonatomic) IBOutlet UIImageView *imageLanguage;

-(void) startTimer;
-(void) stopTimer;
- (IBAction)actionLight:(UIButton *)sender;
- (IBAction)actionAdClicked:(UIButton *)sender;
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;
@end
