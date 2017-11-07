//
//  AppDelegate.m
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 10/22/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "NetworkAPISingleClient+FIDS.h"
#import "DataModels.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize drinkItems = _drinkItems;
@synthesize saladItems = _saladItems;
@synthesize soupItems  = _soupItems;
@synthesize entreeItems  = _entreeItems;
@synthesize dessertItems = _dessertItems;
@synthesize appItems = _appItems;
@synthesize currentOrderItems = _currentOrderItems;
@synthesize language = _language;
@synthesize isDynamic = _isDynamic;
@synthesize restaurantTable = _restaurantTable;
@synthesize restaurantName = _restaurantName;
@synthesize restaurantAddress = _restaurantAddress;
@synthesize restaurantCity = _restaurantCity;
@synthesize restaurantState = _restaurantState;
@synthesize restaurantZip = _restaurantZip;
@synthesize interval = _interval;
@synthesize isSent = _isSent;
@synthesize isPaid = _isPaid;
@synthesize isiPhone = _isiPhone;
@synthesize backgrounds = _backgrounds;
@synthesize flightbackgrounds = _flightbackgrounds;
@synthesize diningbackgrounds = _diningbackgrounds;
@synthesize foodcourtbackgrounds = _foodcourtbackgrounds;
@synthesize foodtogobackgrounds = _foodtogobackgrounds;
@synthesize shopsbackgrounds = _shopsbackgrounds;
@synthesize loungesbackgrounds = _loungesbackgrounds;
@synthesize clubsbackgrounds = _clubsbackgrounds;
@synthesize hotelbackgrounds = _hotelbackgrounds;
@synthesize groundbackgrounds = _groundbackgrounds;
@synthesize deptbackgrounds = _deptbackgrounds;
@synthesize electronicsbackgrounds = _electronicsbackgrounds;
@synthesize categoriesbackgrounds = _categoriesbackgrounds;
@synthesize beachbags = _beachbags;
@synthesize beachwear = _beachwear;
@synthesize designerhats = _designerhats;
@synthesize jewelrywatches = _jewelrywatches;
@synthesize tennisrackets = _tennisrackets;
@synthesize sunglasses = _sunglasses;
@synthesize surfboards = _surfboards;
@synthesize mensshoes = _mensshoes;
@synthesize mensclothing = _mensclothing;
@synthesize sportsstores = _sportsstores;
@synthesize childrenclothing = _childrenclothing;
@synthesize womensshoes = _womensshoes;
@synthesize screenHeight = _screenHeight;
@synthesize arrivals = _arrivals;
@synthesize departures = _departures;
@synthesize airlines = _airlines;
@synthesize selectedAirlineName = _selectedAirlineName;
@synthesize selectedAirlineLogo = _selectedAirlineLogo;
@synthesize locationManager = _locationManager;
@synthesize useAPI = _useAPI;
@synthesize  isMissingPerson = _isMissingPerson;
@synthesize  missingPersonImage = _missingPersonImage;
@synthesize currentBuildInfo = _currentBuildInfo;
@synthesize hostReachability = _hostReachability;
@synthesize internetReachability = _internetReachability;
@synthesize connectionImageName = _connectionImageName;
@synthesize storageClient = _storageClient;
@synthesize azureClient = _azureClient;
@synthesize userSettings = _userSettings;

+(AppDelegate *) currentDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)tabBarController:(UITabBarController *)tabBarControllerThis didSelectViewController:(UIViewController *)viewController
{
    [UIView transitionWithView:viewController.view
                      duration:0.1
                       options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void){
                    } completion:^(BOOL finished){
                        [UIView beginAnimations:@"animation" context:nil];
                        [UIView setAnimationDuration:0.7];
                        [UIView setAnimationBeginsFromCurrentState:YES];
                        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                                               forView:viewController.view
                                                 cache:NO];
                        [UIView commitAnimations];
                    }];
}


- (UIStoryboard *)grabStoryboard {
    
    // determine screen size
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIStoryboard *storyboard;
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    switch (screenHeight) {
            
            // iPhone 4s
        case 480:
            //   storyboard = [UIStoryboard storyboardWithName:@"Main-4s" bundle:nil];
            break;
            
            // iPhone 5s
        case 568:
            //storyboard = [UIStoryboard storyboardWithName:@"Main-5s" bundle:nil];
            break;
            
            // iPhone 6
        case 667:
            // storyboard = [UIStoryboard storyboardWithName:@"Main-6" bundle:nil];
            break;
            
            // iPhone 6 Plus
        case 736:
            storyboard = [UIStoryboard storyboardWithName:@"Main_6Plus" bundle:nil];
            break;
            
        default:
            // storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
    }
    
    return storyboard;
}


-(void) initReachabilityCheck{
    
    NSString *remoteHostName =  @"";
    
    @try {
        
        /*
         Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
         */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        //Change the host name here to change the server you want to monitor.
        remoteHostName = kDDDM;
        
        
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        [self updateInterfaceWithReachability:self.hostReachability];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Error ->%@",exception.description);
    } @finally {
        remoteHostName = @"";
    }
    
    
    
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    
    if (reachability == self.internetReachability)
    {
        [self reachableTest:reachability];
    }
    
}


- (void)reachableTest:(Reachability *) reachObject{
    
    UIAlertController *alert = nil;
    UIAlertAction *okAction = nil;
    NSString *statusString = @"",
    *imageName = @"";
    
    @try {
        
        
        NetworkStatus netStatus = [reachObject currentReachabilityStatus];
        BOOL connectionRequired = [reachObject connectionRequired];
        
        
        
        switch (netStatus)
        {
            case NotReachable:
            {
                statusString = NSLocalizedString(@"Internet Access Not Available",@"");
                
                /*
                 Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
                 */
                connectionRequired = NO;
                imageName = @"stop-32.png";
                
                break;
            }
                
            case ReachableViaWWAN:        {
                statusString = NSLocalizedString(@"Reachable via WWAN", @"");
                imageName = @"WWAN5.png";
                
                break;
            }
            case ReachableViaWiFi:        {
                statusString= NSLocalizedString(@"Reachable via WiFi", @"");
                imageName = @"Airport.png";
                break;
            }
        }
        
        
        alert = [UIAlertController alertControllerWithTitle:@"Internet Connectivity Status"
                                                    message:statusString
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        okAction = [UIAlertAction actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                          handler:nil];
        
        [alert addAction:okAction];
        _connectionImageName = imageName;
        /* if (! _connectionImageName){
         
         [self.window.rootViewController presentViewController:alert animated:YES completion:^(void){
         
         }];
         }*/
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"notReachableAction:Error->%@",exception.description);
    } @finally {
        alert = nil;
        okAction = nil;
    }
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _language = @"English";
    _isDynamic = YES;
    _isSent   = NO;
    _isiPhone = NO;
    _useAPI = NO;
    _restaurantTable   = @"Welcome To DigitalWorldInternational.Com\n Proudly Serving All Malls";
    _restaurantName    = @"Sample Mall ®";
    _restaurantAddress = @"2100 North West 42nd Avenue";
    _restaurantCity    = @"Miami";
    _restaurantState   = @"FL";
    _restaurantZip     = @"33142";
    _interval          = 4;
    
    
    _userSettings = [NSUserDefaults standardUserDefaults];
    
    [self initReachabilityCheck];
    [self extractCurrentBuildInformation];
    [self initLocationServices];
    [self initAzureStorage];
    [self registerAzureLoadedNotications];
    [self prepareMallBackgrounds];
 
    
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        _isiPhone = YES;
        // grab correct storyboard depending on screen height
        UIStoryboard *storyboard = [self grabStoryboard];
        
        // display storyboard
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
        
    }
    
    
    NSLog(@"Screen Height -> %ld",(long)_screenHeight);
    
    return YES;
}

-(void) extractCurrentBuildInformation{
    
    NSString *appVersionString = @"",
    *appBuildString = @"",
    *versionBuildString = @"";
    
    @try {
        
        appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        
        versionBuildString = [NSString stringWithFormat:@"Version: %@ (%@)", appVersionString, appBuildString];
        
        if (versionBuildString){
            _currentBuildInfo = versionBuildString;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        
    } @finally {
        appVersionString = @"";
        appBuildString = @"";
        versionBuildString = @"";
    }
}

-(void) initLocationServices{
    
    _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager setDelegate:self];
    
}


- (void) electronicsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _electronicsbackgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu electronicsDownloaded loaded from Cache",(unsigned long)_electronicsbackgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _electronicsbackgrounds = queryResult.items;
            if (_electronicsbackgrounds){
                NSLog(@"Total of %lu electronicsDownloaded loaded",(unsigned long)_electronicsbackgrounds.count);
                [self saveCustomObject:_electronicsbackgrounds key:kAzureMallElectronicsBackgroundsTableName];
               // [_userSettings setObject:_electronicsbackgrounds forKey:kAzureMallElectronicsBackgroundsTableName];
            }
        }
    }
    
}

- (void)deptsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _deptbackgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu Dept Stores loaded from Cache",(unsigned long)_deptbackgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _deptbackgrounds = queryResult.items;
            if (_deptbackgrounds){
                NSLog(@"Total of %lu Dept Stores loaded",(unsigned long)_deptbackgrounds.count);
                [self saveCustomObject:_deptbackgrounds key:kAzureMallDeptStoresTableName];
                //[_userSettings setObject:_deptbackgrounds forKey:kAzureMallDeptStoresTableName];
            }
        }
    }
    
}

- (void)diningDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _diningbackgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu Dining loaded from Cache",(unsigned long)_diningbackgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _diningbackgrounds = queryResult.items;
            if (_diningbackgrounds){
                NSLog(@"Total of %lu Dining loaded",(unsigned long)_diningbackgrounds.count);
                [self saveCustomObject:_diningbackgrounds key:kAzureAirportDiningBackgroundsTableName];
             }
        }
    }
}

- (void)foodCourtDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _foodcourtbackgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu Food Court loaded from Cache",(unsigned long)_foodcourtbackgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _foodcourtbackgrounds = queryResult.items;
            if (_foodcourtbackgrounds){
                NSLog(@"Total of %lu Food Court loaded",(unsigned long)_foodcourtbackgrounds.count);
                [self saveCustomObject:_foodcourtbackgrounds key:kAzureAirportFoodCourtBackgroundsTableName];
            }
        }
    }
}

- (void)foodToGoDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _foodtogobackgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu Food ToGo loaded from Cache",(unsigned long)_foodtogobackgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _foodtogobackgrounds = queryResult.items;
            if (_foodtogobackgrounds){
                NSLog(@"Total of %lu Food ToGo loaded",(unsigned long)_foodtogobackgrounds.count);
                [self saveCustomObject:_foodtogobackgrounds key:kAzureAirportFoodToGoBackgroundsTableName];
            }
        }
    }
}

- (void)shopsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _shopsbackgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu Shops loaded from Cache",(unsigned long)_shopsbackgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _shopsbackgrounds = queryResult.items;
            if (_shopsbackgrounds){
                NSLog(@"Total of %lu Shops loaded",(unsigned long)_shopsbackgrounds.count);
                [self saveCustomObject:_shopsbackgrounds key:kAzureAirportShopsBackgroundsTableName];
            }
        }
    }
}

- (void) mallsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _backgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu Mall Backgrounds loaded from Cache",(unsigned long)_backgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _backgrounds = queryResult.items;
            if (_backgrounds){
                NSLog(@"Total of %lu Mall Backgrounds loaded",(unsigned long)_backgrounds.count);
                [self saveCustomObject:_backgrounds key:kAzureMallBackgroundsTableName];
            }
        }
    }
}

- (void) categoriesDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _categoriesbackgrounds = (NSArray*) [notif object];
        NSLog(@"Total of %lu Categories loaded from Cache",(unsigned long)_categoriesbackgrounds.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _categoriesbackgrounds = queryResult.items;
            if (_categoriesbackgrounds){
                NSLog(@"Total of %lu Categories loaded",(unsigned long)_categoriesbackgrounds.count);
                [self saveCustomObject:_categoriesbackgrounds key:kAzureMallCategoriesTableName];
            }
        }
    }
}

- (void) beachBagsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _beachbags = (NSArray*) [notif object];
        NSLog(@"Total of %lu Beach Bags loaded from Cache",(unsigned long)_beachbags.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _beachbags = queryResult.items;
            if (_beachbags){
                NSLog(@"Total of %lu Beach Bags loaded",(unsigned long)_beachbags.count);
                [self saveCustomObject:_beachbags key:kAzureMallBeachBeachBagsTableName];
            }
        }
    }
}

- (void) beachWearDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _beachwear = (NSArray*) [notif object];
        NSLog(@"Total of %lu Beach Wear loaded from Cache",(unsigned long)_beachwear.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _beachwear = queryResult.items;
            if (_beachwear){
                NSLog(@"Total of %lu Beach Wear loaded",(unsigned long)_beachwear.count);
                [self saveCustomObject:_beachwear key:kAzureMallBeachWearTableName];
            }
        }
    }
}


- (void) jewelryDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _jewelrywatches = (NSArray*) [notif object];
        NSLog(@"Total of %lu Jewelry loaded from Cache",(unsigned long)_jewelrywatches.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _jewelrywatches = queryResult.items;
            if (_jewelrywatches){
                NSLog(@"Total of %lu Jewelry loaded",(unsigned long)_jewelrywatches.count);
                [self saveCustomObject:_jewelrywatches key:kAzureMallJewelryTableName];
            }
        }
    }
}

- (void) sunglassesDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _sunglasses = (NSArray*) [notif object];
        NSLog(@"Total of %lu Sunglasses loaded from Cache",(unsigned long)_sunglasses.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _sunglasses = queryResult.items;
            if (_sunglasses){
                NSLog(@"Total of %lu Sunglasses loaded",(unsigned long)_sunglasses.count);
                [self saveCustomObject:_sunglasses key:kAzureMallSunglassesTableName];
            }
        }
    }
}

- (void) hatsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _designerhats = (NSArray*) [notif object];
        NSLog(@"Total of %lu Designer Hats loaded from Cache",(unsigned long)_designerhats.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _designerhats = queryResult.items;
            if (_designerhats){
                NSLog(@"Total of %lu Designer Hats loaded",(unsigned long)_designerhats.count);
                [self saveCustomObject:_designerhats key:kAzureMallDesignerHatsTableName];
            }
        }
    }
}

- (void) racketsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _tennisrackets = (NSArray*) [notif object];
        NSLog(@"Total of %lu Tennis Rackets loaded from Cache",(unsigned long)_tennisrackets.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _tennisrackets = queryResult.items;
            if (_tennisrackets){
                NSLog(@"Total of %lu Tennis Rackets loaded",(unsigned long)_tennisrackets.count);
                [self saveCustomObject:_tennisrackets key:kAzureMallTennisRacketsTableName];
            }
        }
    }
}

- (void) surfBoardsDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _surfboards = (NSArray*) [notif object];
        NSLog(@"Total of %lu Surfboards loaded from Cache",(unsigned long)_surfboards.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _surfboards = queryResult.items;
            if (_surfboards){
                NSLog(@"Total of %lu SurfBoards loaded",(unsigned long)_surfboards.count);
                [self saveCustomObject:_surfboards key:kAzureMallSurfBoardsTableName];
            }
        }
    }
}



- (void) womensShoesDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _womensshoes = (NSArray*) [notif object];
        NSLog(@"Total of %lu Womens Shoes loaded from Cache",(unsigned long)_womensshoes.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _womensshoes = queryResult.items;
            if (_womensshoes){
                NSLog(@"Total of %lu Womens Shoes loaded",(unsigned long)_womensshoes.count);
                [self saveCustomObject:_womensshoes key:kAzureMallWomensShoesTableName];
            }
        }
    }
}

- (void) mensShoesDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _mensshoes = (NSArray*) [notif object];
        NSLog(@"Total of %lu Mens Shoes loaded from Cache",(unsigned long)_mensshoes.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _mensshoes = queryResult.items;
            if (_mensshoes){
                NSLog(@"Total of %lu Mens Shoes loaded",(unsigned long)_mensshoes.count);
                [self saveCustomObject:_mensshoes key:kAzureMallMensShoesTableName];
            }
        }
    }
}

- (void) mensClothingDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _mensclothing = (NSArray*) [notif object];
        NSLog(@"Total of %lu Mens Clothing loaded from Cache",(unsigned long)_mensclothing.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _mensclothing = queryResult.items;
            if (_mensclothing){
                NSLog(@"Total of %lu Mens Clothing loaded",(unsigned long)_mensclothing.count);
                [self saveCustomObject:_mensclothing key:kAzureMallMensClothingTableName];
            }
        }
    }
}

- (void) sportsStoreDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _sportsstores = (NSArray*) [notif object];
        NSLog(@"Total of %lu Food Court loaded from Cache",(unsigned long)_sportsstores.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _sportsstores = queryResult.items;
            if (_sportsstores){
                NSLog(@"Total of %lu Sports Store loaded",(unsigned long)_sportsstores.count);
                [self saveCustomObject:_sportsstores key:kAzureMallSportsStoreTableName];
            }
        }
    }
}


- (void) childStoreDownloaded:(NSNotification *)notif {
    MSQueryResult *queryResult = nil;
    if(! [notif.object isKindOfClass:[MSQueryResult class]]){
        _childrenclothing = (NSArray*) [notif object];
        NSLog(@"Total of %lu Childs Clothing loaded from Cache",(unsigned long)_childrenclothing.count);
    }else{
        queryResult = (MSQueryResult*) [notif object];
        if (queryResult){
            _childrenclothing = queryResult.items;
            if (_childrenclothing){
                NSLog(@"Total of %lu Child Clothing loaded",(unsigned long)_childrenclothing.count);
                [self saveCustomObject:_childrenclothing key:kAzureMallChildClothingTableName];
            }
        }
    }
}




-(void) registerAzureLoadedNotications{
    
    NSLog(@"Adding Observer for %@",kAzureMallBackgroundsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallBackgroundsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self mallsDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallCategoriesTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallCategoriesTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self categoriesDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallDeptStoresTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallDeptStoresTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self deptsDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureAirportDiningBackgroundsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureAirportDiningBackgroundsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self diningDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureAirportFoodCourtBackgroundsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureAirportFoodCourtBackgroundsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self foodCourtDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureAirportFoodToGoBackgroundsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureAirportFoodToGoBackgroundsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self foodToGoDownloaded:objNot];
                                                          
                                                      }];
    
    
    NSLog(@"Adding Observer for %@",kAzureAirportShopsBackgroundsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureAirportShopsBackgroundsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self shopsDownloaded:objNot];
                                                          
                                                      }];
    
    
    
    NSLog(@"Adding Observer for %@",kAzureMallElectronicsBackgroundsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallElectronicsBackgroundsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self electronicsDownloaded:objNot];
                                                          
                                                      }];

    

    NSLog(@"Adding Observer for %@",kAzureMallBeachBeachBagsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallBeachBeachBagsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self beachBagsDownloaded:objNot];
                                                          
                                                      }];

    NSLog(@"Adding Observer for %@",kAzureMallBeachWearTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallBeachWearTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self beachWearDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallJewelryTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallJewelryTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self jewelryDownloaded:objNot];
                                                          
                                                      }];

    NSLog(@"Adding Observer for %@",kAzureMallDesignerHatsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallDesignerHatsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self hatsDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallTennisRacketsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallTennisRacketsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self racketsDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallSunglassesTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallSunglassesTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self sunglassesDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallSurfBoardsTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallSurfBoardsTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self surfBoardsDownloaded:objNot];
                                                          
                                                      }];
    
    
    NSLog(@"Adding Observer for %@",kAzureMallMensShoesTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallMensShoesTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self mensShoesDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallWomensShoesTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallWomensShoesTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self womensShoesDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallMensClothingTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallMensClothingTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self mensClothingDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallSportsStoreTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallSportsStoreTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self sportsStoreDownloaded:objNot];
                                                          
                                                      }];
    
    NSLog(@"Adding Observer for %@",kAzureMallChildClothingTableName);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kAzureMallChildClothingTableName
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *objNot){
                                                          
                                                          [self childStoreDownloaded:objNot];
                                                          
                                                      }];
    
    
    
    
}

- (void)saveCustomObject:(NSArray *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (NSArray *)loadCustomObjectWithKey:(NSString *)key {
    if (! _userSettings){
        _userSettings = [NSUserDefaults standardUserDefaults];
    }
    NSData *encodedObject = [_userSettings objectForKey:key];
    NSArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


-(void) initAzureStorage{
    
    NSString *message  = @"",
             *appKey   = kParseAppId,
             *clientKey = kParseKey;
    
    AZSCloudStorageAccount *account = nil;
    
    AZSStorageCredentials *credentials = nil;
    
    NSError *err = nil;
    
    @try {
        
        
        message =  [NSString stringWithFormat:@"DefaultEndpointsProtocol=https;AccountName=%@;AccountKey=%@",kAzureStorageName,kAzureStorageKey1];
        
        
        /** AZSStorageCredentials is used to store credentials used to authenticate Storage Requests.
         
         AZSStorageCredentials can be created with a Storage account name and account key for Shared Key access,
         or with a SAS token (forthcoming.)  Sample usage with SharedKey authentication:
         
         AZSStorageCredentials *storageCredentials = [[AZSStorageCredentials alloc] initWithAccountName:<name> accountKey:<key>];
         AZSCloudStorageAccount *storageAccount = [[AZSCloudStorageAccount alloc] initWithCredentials:storageCredentials useHttps:YES];
         AZSCloudBlobClient *blobClient = [storageAccount getBlobClient];
         
         */
        
        credentials = [[AZSStorageCredentials alloc] initWithAccountName:kAzureSharedKey accountKey:kAzureStorageKey1];
        
        
        account =  [[AZSCloudStorageAccount alloc] initWithCredentials:credentials useHttps:YES error:&err];
        
        
        if (account){
            _storageClient = [account getBlobClient];
            message = [NSString  stringWithFormat:@"Successfully connected Azure Storage for %@",message];
            NSLog(@"initAzureStorage:Message->%@",message);
            
        }
        
        message = [NSString stringWithFormat:@"%@%@",kAzureTableRootURL,kAzureSharedKey];
        
        
        
        
        
    }
    @catch (NSException *exception) {
        message = [NSString stringWithFormat:@"initAzureStorage:Error->%@", exception.debugDescription];
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        appKey = @"";
        clientKey = @"";
    }
    
}

-(void) prepareMallBackgrounds{
    
    
    NSString *message = @"";
    
    NSPredicate *tableFilter = nil;
    
    MSTable *menuTable = nil;
    MSQuery *query = nil;
    
    NSString *filterFormat = @"PartitionKey == '%@'";
    
    NSArray *parseItems = nil;
    
    @try {
        
        
        message = kAzureMenuTable;
        
        _azureClient = [MSClient clientWithApplicationURLString:message];
        

        parseItems = [[NSArray alloc] initWithObjects:kAzureMallBackgroundsTableName,kAzureAirportDiningBackgroundsTableName,
                      kAzureAirportFoodCourtBackgroundsTableName,kAzureAirportFoodToGoBackgroundsTableName,
                      kAzureAirportShopsBackgroundsTableName,kAzureAirportLoungesBackgroundsTableName,
                      kAzureMallCategoriesTableName,kAzureAirportHotelsBackgroundsTableName,kAzureMallCategoriesTableName,
                      kAzureMallDeptStoresTableName,kAzureMallElectronicsBackgroundsTableName,kAzureMallBeachBeachBagsTableName,
                      kAzureMallBeachWearTableName,kAzureMallJewelryTableName,kAzureMallDesignerHatsTableName,
                      kAzureMallSunglassesTableName,kAzureMallTennisRacketsTableName,kAzureMallSurfBoardsTableName,
                      kAzureMallMensShoesTableName,kAzureMallWomensShoesTableName,kAzureMallSportsStoreTableName,
                      kAzureMallMensClothingTableName,kAzureMallChildClothingTableName,nil];
        
        
        if (_azureClient){
            message = [NSString  stringWithFormat:@"Successfully connected Azure Table for %@",message];
            NSLog(@"loadAzureStorageData:Message->%@",message);
        }
        
        
        if (_azureClient){
            menuTable =    [_azureClient tableWithName:kAzureMallBackgroundsTableName];
            
            query = [menuTable query];
            
            
        }
        
 
 
        for (int idx = 0; idx < parseItems.count; idx++) {
            
            NSString *categoryName = [parseItems objectAtIndex:idx];
            
            if (categoryName){
                
                
                NSArray *cachedTable =  [self loadCustomObjectWithKey:categoryName];
                
                
                if (cachedTable) {
                    NSLog(@"Sucessfully Retrieved %@ Table from Cache", cachedTable);
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:categoryName
                     object:cachedTable];
                    
                    continue;
                }
                
                
                @try {
                    message = [NSString stringWithFormat:@"Attempting to connect to Azure TableName->%@",categoryName];
                    NSLog(@"%@",message);
                    menuTable =  [_azureClient tableWithName:categoryName];
                    
                    if (! menuTable){
                        message = [NSString stringWithFormat:@"Azure TableName->%@ not found",categoryName];
                        NSLog(@"%@",message);
                        continue;
                    }else{
                        
                        
                        query = [menuTable query];
                        
                        tableFilter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:filterFormat,categoryName]];
                        
                        query = [menuTable queryWithPredicate:tableFilter];
                        
                        [query orderByAscending:@"PartitionKey"];
                        [query orderByAscending:@"Order"];
                        
                        
                        [query readWithCompletion:^(MSQueryResult *result, NSError *error){
                            
                            NSString *queryMessage = @"";
                            
                            if (error){
                                queryMessage = [NSString stringWithFormat: @"loadAzureStorageData:Error->%@",error.description];
                                NSLog(@"readWithCompletionError::%@",queryMessage);
                            }else{
                                
                                
                                if (result){
                                    //Raise the notification
                                    [[NSNotificationCenter defaultCenter]
                                     postNotificationName:categoryName
                                     object:result];
                                }
                                
                                
                                
                            }
                            
                        }];
                        
                        
                    }
                    
                } @catch (NSException *exception) {
                    message = [NSString stringWithFormat:@"Azure tablewithNameError::%@", exception.debugDescription];
                    NSLog(@"%@",message);
                    
                } @finally {
                    
                    message = @"";
                    
                }
                
                
                
            }
        }
        
        
     
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        
        query = nil;
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
