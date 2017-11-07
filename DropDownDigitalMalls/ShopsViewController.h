//
//  SoupsViewController.h
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 11/20/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopsViewController : UITableViewController
@property (assign,nonatomic) BOOL isRetail;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSString *catName;
@property (nonatomic,strong) NSString *catLogo;
@end
