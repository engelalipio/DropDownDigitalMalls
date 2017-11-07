//
//  AppDelegate.h
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 10/22/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

enum OrderType {
     OrderTypeDrinks	= 1,
     OrderTypeSalads	= 2,
     OrderTypeMeats		= 3,
     OrderTypeDesserts	= 4
};

typedef int OrderTypeSelection;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign,nonatomic) Boolean isDynamic;
@property (strong, nonatomic) NSUserDefaults *userSettings;
@property (assign,nonatomic) Boolean isSent;
@property (assign,nonatomic) Boolean isPaid;
@property (assign,nonatomic) Boolean isiPhone;
@property (assign,nonatomic) Boolean useAPI;
@property (assign,nonatomic) Boolean isMissingPerson;
@property (assign,nonatomic) NSInteger screenHeight;
@property (assign,nonatomic) NSInteger interval;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *connectionImageName;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *selectedAirlineName;
@property (strong, nonatomic) NSString *selectedAirlineLogo;

@property (strong, nonatomic) NSString *restaurantTable;
@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *restaurantAddress;
@property (strong, nonatomic) NSString *restaurantCity;
@property (strong, nonatomic) NSString *restaurantState;
@property (strong, nonatomic) NSString *restaurantZip;
@property (strong, nonatomic) NSString *currentBuildInfo;
@property (nonatomic, assign) NSInteger currentOrderItems;
@property (strong, nonatomic) NSMutableDictionary *arrivals;
@property (strong, nonatomic) NSMutableDictionary *departures;
@property (strong, nonatomic) NSMutableDictionary  *airlines;

@property (strong, nonatomic) NSMutableDictionary *drinkItems;
@property (strong, nonatomic) NSMutableDictionary *appItems;
@property (strong, nonatomic) NSMutableDictionary *soupItems;
@property (strong, nonatomic) NSMutableDictionary *saladItems;
@property (strong, nonatomic) NSMutableDictionary *dessertItems;
@property (strong, nonatomic) NSMutableDictionary *entreeItems;
@property (strong, nonatomic) NSArray *backgrounds;
@property (strong, nonatomic) NSArray *flightbackgrounds;
@property (strong, nonatomic) NSArray *diningbackgrounds;
@property (strong, nonatomic) NSArray *foodcourtbackgrounds;
@property (strong, nonatomic) NSArray *foodtogobackgrounds;
@property (strong, nonatomic) NSArray *shopsbackgrounds;
@property (strong, nonatomic) NSArray  *loungesbackgrounds;
@property (strong, nonatomic) NSArray  *clubsbackgrounds;
@property (strong, nonatomic) NSArray  *hotelbackgrounds;
@property (strong, nonatomic) NSArray  *groundbackgrounds;
@property (strong,nonatomic)  NSArray  *electronicsbackgrounds;
@property (strong, nonatomic) NSArray  *deptbackgrounds;
@property (strong, nonatomic) NSArray  *categoriesbackgrounds;
@property (strong, nonatomic) NSArray  *beachbags;
@property (strong, nonatomic) NSArray  *beachwear;
@property (strong, nonatomic) NSArray  *designerhats;
@property (strong, nonatomic) NSArray  *jewelrywatches;
@property (strong, nonatomic) NSArray  *tennisrackets;
@property (strong, nonatomic) NSArray  *sunglasses;
@property (strong, nonatomic) NSArray  *surfboards;
@property (strong, nonatomic) NSArray  *mensshoes;
@property (strong, nonatomic) NSArray  *womensshoes;
@property (strong, nonatomic) NSArray  *mensclothing;
@property (strong, nonatomic) NSArray  *sportsstores;
@property (strong, nonatomic) NSArray  *childrenclothing;
@property (strong, nonatomic)  UIImage *missingPersonImage;


@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@property (strong, nonatomic) AZSCloudBlobClient *storageClient;
@property (strong, nonatomic) MSClient *azureClient;

+(AppDelegate *) currentDelegate;

@end


