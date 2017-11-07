//
//  SoupsViewController.m
//  DropDownDigitalMalls
//
//  Created by Engel Alipio on 11/20/14.
//  Copyright (c) 2014 Digital World International. All rights reserved.
//

#import "ShopsViewController.h"
#import "Constants.h"
#import "ItemViewController.h"
#import "AppDelegate.h"

@interface ShopsViewController() {
    AppDelegate *appDelegate;
    UIImageView *selectedImageView;
    NSString *selectedShop;
    
        NSArray *shops,
                *gifts,
                *electronics,
                *retail;
    
    NSMutableArray  *beachBags,
                    *beachWear,
                    *jewelry,
                    *sunglasses,
                    *hats,
                    *surfboards,
                    *menShoes,
                    *womenShoes,
                    *rackets,
                    *sportsStores,
                    *mensClothing,
                    *childClothing;
    
    NSInteger retailId;
}
-(void) checkOrderCount;
-(void) initTableView;
@end

@implementation ShopsViewController
@synthesize isRetail = _isRetail;
@synthesize categoryName = _categoryName;
@synthesize catName = _catName;

- (CGRect)approximateFrameForTabBarItemAtIndex:(NSUInteger)barItemIndex inTabBar:(UITabBar *)tabBar {
    
    CGRect tabBarRect;
    
    NSArray *barItems = nil;
    
    NSString *message = @"";
    
    CGFloat barMidX = 0.0f,
            distanceBetweenBarItems = 0.0f,
            totalBarItemsWidth = 0.0f,
            barItemX = 0.0f;
    
    CGSize  barItemSize;
    
    @try {
        
        barItems = tabBar.items;
        
        barMidX = CGRectGetMidX([tabBar frame]);
        
        barItemSize = CGSizeMake(80.0, 45.0);
        
        distanceBetweenBarItems = 110.0;
        
        barItemX = barItemIndex * distanceBetweenBarItems + barItemSize.width * 0.5;
        
        totalBarItemsWidth = ([barItems count]-1) * distanceBetweenBarItems + barItemSize.width;
        
        barItemX += barMidX - round(totalBarItemsWidth * 0.5);
        
        tabBarRect =  CGRectMake(barItemX, CGRectGetMinY([tabBar frame]), 30.0, barItemSize.height);
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
        
        barItems = nil;
        
        message = @"";
        
        barMidX = 0.0f;
        distanceBetweenBarItems = 0.0f;
        totalBarItemsWidth = 0.0f;
        barItemX = 0.0f;
        
    }
    
    return tabBarRect;
}

- (void) initiateAddToCart:(NSInteger) orderItems{
    
    
    static float const curvingIntoCartAnimationDuration = kAnimationSpeed;
    
    CALayer *layerToAnimate = nil;
    
    CAKeyframeAnimation *itemViewCurvingIntoCartAnimation = nil;
    
    CABasicAnimation    *itemViewShrinkingAnimation = nil,
                        *itemAlphaFadeAnimation     = nil;
    
    CAAnimationGroup    *shrinkFadeAndCurveAnimation = nil;
    
    NSString *message = @"";
    
    @try {
        
        
        //Obtaining the Image Layer to animate
        
        layerToAnimate = selectedImageView.layer;
        
        itemViewCurvingIntoCartAnimation = [self itemViewCurvingIntoCartAnimation];
        
        
        
        itemViewShrinkingAnimation =  [CABasicAnimation animationWithKeyPath:@"bounds"];
        
        itemViewShrinkingAnimation.toValue = [NSValue valueWithCGRect:
                                              CGRectMake(0.0,0.0, selectedImageView.bounds.size.width/2.5,
                                                         selectedImageView.bounds.size.height/2.5)];
        
        itemAlphaFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        itemAlphaFadeAnimation.toValue = [NSNumber numberWithFloat:0.5];
        
        shrinkFadeAndCurveAnimation = [CAAnimationGroup animation];
        
        [shrinkFadeAndCurveAnimation setAnimations:[NSArray arrayWithObjects:
                                                    itemViewCurvingIntoCartAnimation,
                                                    itemViewShrinkingAnimation,
                                                    itemAlphaFadeAnimation,
                                                    nil]];
        
        [shrinkFadeAndCurveAnimation setRepeatCount:orderItems];
        [shrinkFadeAndCurveAnimation setDuration:curvingIntoCartAnimationDuration];
        [shrinkFadeAndCurveAnimation setDelegate:self];
        [shrinkFadeAndCurveAnimation setRemovedOnCompletion:NO];
        [shrinkFadeAndCurveAnimation setValue:@"shrinkAndCurveToAddToOrderAnimation" forKey:@"name"];
        
        [layerToAnimate addAnimation:shrinkFadeAndCurveAnimation forKey:nil];
        
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
}

- (CAKeyframeAnimation *) itemViewCurvingIntoCartAnimation {
    
    NSString *message =@"";
    
    float riseAbovePoint = 300.0f;
    
    CGRect positionOfItemViewInView,
           orderTableItemRect;
    
    CGPoint beginningPointOfQuadCurve,
            endPointOfQuadCurve,
            controlPointOfQuadCurve;
    
    UIBezierPath * quadBezierPathOfAnimation = nil;
    
    CAKeyframeAnimation * itemViewCurvingIntoCartAnimation ;
    
    UITabBarItem *orderTabItem = nil;
    
    @try {
        
        //Originating Image
        positionOfItemViewInView = selectedImageView.frame;
        
        orderTabItem = (UITabBarItem*)  [[[self.tabBarController tabBar] items] objectAtIndex:kOrderTabItemIndex];
        
        orderTableItemRect = [self approximateFrameForTabBarItemAtIndex:kOrderTabItemIndex inTabBar:self.tabBarController.tabBar];
        
        UIImageView *orderImage = [[UIImageView alloc ] initWithFrame:orderTableItemRect];
        
        if (orderImage){
            [orderImage setImage:orderTabItem.image];
        }
        
        beginningPointOfQuadCurve = positionOfItemViewInView.origin;
        
        endPointOfQuadCurve = CGPointMake(orderImage.frame.origin.x + orderImage.frame.size.width/2,
                                          orderImage.frame.origin.y + orderImage.frame.size.height/2) ;
        
        controlPointOfQuadCurve = CGPointMake((beginningPointOfQuadCurve.x + endPointOfQuadCurve.x *2)/2,
                                              beginningPointOfQuadCurve.y -riseAbovePoint);
        
        quadBezierPathOfAnimation = [UIBezierPath bezierPath];
        
        [quadBezierPathOfAnimation moveToPoint:beginningPointOfQuadCurve];
        
        [quadBezierPathOfAnimation addQuadCurveToPoint:endPointOfQuadCurve controlPoint:controlPointOfQuadCurve];
        
        itemViewCurvingIntoCartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        itemViewCurvingIntoCartAnimation.path = quadBezierPathOfAnimation.CGPath;
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message = @"";
    }
    
    
    return itemViewCurvingIntoCartAnimation;
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSString *message   = @"",
    *orderItem = @"";
    
    NSInteger orderItems        = 0,
              currentOrderCount = 0,
              itemsCount        = 0;
    
    @try {
        
        itemsCount = kOrderTabItemIndex;
    
        currentOrderCount = [appDelegate currentOrderItems];
        if (! currentOrderCount){
            currentOrderCount = 0;
            [appDelegate setCurrentOrderItems:currentOrderCount];
        }
        orderItem = [NSString stringWithFormat:@"%d",currentOrderCount];
        [[[[self.tabBarController tabBar] items] objectAtIndex:itemsCount] setBadgeValue:orderItem];
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message   = @"";
        orderItem = @"";
        
        orderItems = 0;
        itemsCount = 0;
    }
    
}

-(void)checkOrderCount{
    
    NSString *message   = @"",
             *orderItem = @"";
    
    NSInteger orderItems      = 0,
              currentOrderCount = 0,
              soupsCount        = 0,
              itemsCount       = 0;
    
    @try {
        
        itemsCount = kOrderTabItemIndex;
        
        if (! appDelegate){
            appDelegate = [AppDelegate currentDelegate];
        }
        
        currentOrderCount = [appDelegate currentOrderItems];
        if (! currentOrderCount){
            currentOrderCount = 0;
            [appDelegate setCurrentOrderItems:currentOrderCount];
        }
        
        orderItem =  [[[[self.tabBarController tabBar] items] objectAtIndex:itemsCount] badgeValue];
        if (! orderItem){
            orderItem = @"0";
        }
        if (orderItem){
            
            orderItems = [orderItem intValue];
            if (orderItems < currentOrderCount){
                
                orderItems = currentOrderCount;
                
                if (selectedImageView != nil){
                    if (appDelegate.soupItems){
                        soupsCount = [[appDelegate.soupItems objectForKey:@"Quantity"] integerValue];
                        
                        [self initiateAddToCart:soupsCount];
                    }
                }
                
            }
        }
        
        
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message   = @"";
        orderItem = @"";
        
        orderItems = 0;
        itemsCount = 0;
    }
    
}


-(void) initTableView{
    
    NSString *message = @"";
    
    @try{
        
        retail = nil;
        
        if (! shops){
            shops = [[NSArray alloc] initWithObjects: @"Burberry",@"Chanel",@"Coach", @"Emporio Armani",@"Gucci",
                                                      @"LongChamp",@"Louis Vuitton", @"Michael Kors",  @"Prada", nil];
 
        }


        if (! gifts){
            gifts = [[NSArray alloc] initWithObjects: @"Chocolate La Maison - Chocolates",@"Hudson News - News & Events",
                                                      @"La Relay - Magazines", @"Loccitane - Skin Care",@"Brookstone - Gadgets",
                                                      @"News CNBC - Smart Shop", nil];
            
        }
    
        
        if (! electronics){
            electronics = [[NSArray alloc] initWithObjects: @"Apple Store", @"Best Buy",@"Cannon",@"Game Stop", @"Jacky’s Express",
                                                            @"Microsoft", @"Samsung",@"Sony", @"Think Geek", nil];
            
        }
        
        if ([self.categoryName isEqualToString:@"Womens Clothing"] ||  [self.categoryName isEqualToString:@"Formal Clothing"]){
            retail = shops;
            retailId = 0;
        }
        
        if ( [self.categoryName isEqualToString:@"MenShoes"]){
            

            
            menShoes = [[NSMutableArray alloc] initWithCapacity:appDelegate.mensshoes.count];
            
            for (int idx = 0; idx < appDelegate.mensshoes.count; idx++){
                NSDictionary *bag = [appDelegate.mensshoes objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [menShoes addObject:storeName];
                    }
                }
            }
            
            retail = menShoes;
            retailId  = 2;
        }
        
        
        if ([self.categoryName isEqualToString:@"Electronics & Technology"] ){
            retail = electronics;
            retailId  = 1 ;
        }
        

        
        if ([self.categoryName isEqualToString:@"Beach Bags"] ){
            
            beachBags = [[NSMutableArray alloc] initWithCapacity:appDelegate.beachbags.count];
            
            for (int idx = 0; idx < appDelegate.beachbags.count; idx++){
                NSDictionary *bag = [appDelegate.beachbags objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [beachBags addObject:storeName];
                    }
                }
            }
            
            retail = beachBags;
            retailId  = 3;
        }
        
        if ([self.categoryName isEqualToString:@"WomensShoes"] ){
            
            womenShoes = [[NSMutableArray alloc] initWithCapacity:appDelegate.womensshoes.count];
            
            for (int idx = 0; idx < appDelegate.womensshoes.count; idx++){
                NSDictionary *bag = [appDelegate.womensshoes objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [womenShoes addObject:storeName];
                    }
                }
            }
            
            retail = womenShoes;
            retailId  = 4 ;
        }
        
        if ([self.categoryName isEqualToString:@"Jewelry & Watches"] ){
            
            jewelry = [[NSMutableArray alloc] initWithCapacity:appDelegate.jewelrywatches.count];
            
            for (int idx = 0; idx < appDelegate.jewelrywatches.count; idx++){
                NSDictionary *bag = [appDelegate.jewelrywatches objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [jewelry addObject:storeName];
                    }
                }
            }
            
            retail = jewelry;
            retailId  = 5 ;
        }
        
        
        
        if ([self.categoryName isEqualToString:@"Sunglasses & Eye Wear"] ){
            
            sunglasses = [[NSMutableArray alloc] initWithCapacity:appDelegate.sunglasses.count];
            
            for (int idx = 0; idx < appDelegate.sunglasses.count; idx++){
                NSDictionary *bag = [appDelegate.sunglasses objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [sunglasses addObject:storeName];
                    }
                }
            }
            
            retail = sunglasses;
            retailId  = 6 ;
        }
        
        if ([self.categoryName isEqualToString:@"Mens Clothing"] ){
            
            mensClothing = [[NSMutableArray alloc] initWithCapacity:appDelegate.mensclothing.count];
            
            for (int idx = 0; idx < appDelegate.mensclothing.count; idx++){
                NSDictionary *bag = [appDelegate.mensclothing objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [mensClothing addObject:storeName];
                    }
                }
            }
            
            retail = mensClothing;
            retailId  = 7 ;
        }
        
        
        if ([self.categoryName isEqualToString:@"Child Clothing"] ){
            
            childClothing = [[NSMutableArray alloc] initWithCapacity:appDelegate.childrenclothing.count];
            
            for (int idx = 0; idx < appDelegate.childrenclothing.count; idx++){
                NSDictionary *bag = [appDelegate.childrenclothing objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [childClothing addObject:storeName];
                    }
                }
            }
            
            retail = childClothing;
            retailId  = 8 ;
        }
        
        if ([self.categoryName isEqualToString:@"Sports Stores"] ){
            
            sportsStores = [[NSMutableArray alloc] initWithCapacity:appDelegate.sportsstores.count];
            
            for (int idx = 0; idx < appDelegate.sportsstores.count; idx++){
                NSDictionary *bag = [appDelegate.sportsstores objectAtIndex:idx];
                if (bag){
                    NSString *storeName = [bag objectForKey:@"StoreName"];
                    if (storeName){
                        [sportsStores addObject:storeName];
                    }
                }
            }
            
            retail = sportsStores;
            retailId  = 9 ;
        }
        
        
        if (! self.tableView){
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, kTableYStart, kTabletWidth, kTableHeight)];
        }
        
        
        self.tableView.backgroundColor =  kVerticalTableBackgroundColor;
        
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        
        
    }
    @catch(NSException *error){
        message = [error description];
    }
    @finally{
        if ([message length] > 0){
            NSLog(@"%@",message);
        }
    }
    
}


-(NSString*) randomCalories{
    NSString *cal  =  @"%d calories";
    
    NSInteger calories =  arc4random_uniform(350);
    
    cal = [NSString stringWithFormat:cal,calories];
    
    return cal;
    
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSString *cellID = @"cellShopping",
    *restaurantName = @"",
    *locationFormat = @"Located Near %@" ,
    *restaurantImageNameFormat = @"AirportShops_%d.jpg",
    *restaurantImageName = @"",
    *terminal = @"",
    *finalLocation = @"";
    
    NSArray *Terminals = [[NSArray alloc] initWithObjects: @"The Dolphin Entrance",@"The Main Entrance", @"The North Entrance",
                                                           @"The South Entrance", @"The West Entrance", @"The East Entrance" , nil];
    
    NSInteger terminalId = 0,
                     gateId = arc4random_uniform(50),
                     imageId = 0;

    BOOL isParse = NO;
    
    if (gateId == 0){
        gateId = 1;
    }
    
    cell =  [tableView  dequeueReusableCellWithIdentifier:cellID];
    
    if (! cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
    }

    
   imageId = indexPath.row;
    
    NSArray *splitName  = nil;
    
        terminal = [NSString stringWithFormat:@"%@",terminal];
    
    switch (retailId) {

        case 0:

            restaurantName = [shops objectAtIndex:indexPath.row];
           
            terminal =   [Terminals objectAtIndex:terminalId];  //[Utilities getParseColumnValue:appDelegate.shopsbackgrounds anyIndex:indexPath.row anyColumn:@"Location"];

            isParse = YES;
            
            if (isParse) {
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.shopsbackgrounds anyIndex:indexPath.row];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
        case 2:

            //restaurantImageNameFormat = @"GiftStore_%d.jpg";
            
            restaurantName = [menShoes objectAtIndex:indexPath.row];
            
            terminal =   [Terminals objectAtIndex:terminalId];

            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.mensshoes anyIndex:indexPath.row anyColumn:@"Location"];
            
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.mensshoes anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 1:
            
            restaurantName = [electronics objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.electronicsbackgrounds anyIndex:indexPath.row anyColumn:@"Location"];


            isParse = YES;
            
            if (isParse) {
                locationFormat = @"";
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.electronicsbackgrounds anyIndex:indexPath.row];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 3:
            
            restaurantName = [retail objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.beachbags anyIndex:indexPath.row anyColumn:@"Location"];
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.beachbags anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 4:
            
            restaurantName = [retail objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.womensshoes anyIndex:indexPath.row anyColumn:@"Location"];
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.womensshoes anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 5:
            
            restaurantName = [retail objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.jewelrywatches anyIndex:indexPath.row anyColumn:@"Location"];
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.jewelrywatches anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 6:
            
            restaurantName = [retail objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.sunglasses anyIndex:indexPath.row anyColumn:@"Location"];
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.sunglasses anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 7:
            
            restaurantName = [retail objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.mensclothing anyIndex:indexPath.row anyColumn:@"Location"];
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.mensclothing anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 8:
            
            restaurantName = [retail objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.childrenclothing anyIndex:indexPath.row anyColumn:@"Location"];
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.childrenclothing anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
            
        case 9:
            
            restaurantName = [retail objectAtIndex:indexPath.row];
            
            finalLocation =   [Utilities getAzureMetaDataValue:appDelegate.sportsstores anyIndex:indexPath.row anyColumn:@"Location"];
            
            isParse = YES;
            
            if (isParse) {
                
                
                if (finalLocation){
                    locationFormat = @"";
                }
                
                UIImage *cellImage = [Utilities getAzureStorageImage:appDelegate.sportsstores anyIndex:indexPath.row];
                
                cellImage = [Utilities imageResize:cellImage andResizeTo:CGSizeMake(1000.0f, 600.0f)];
                
                [cell.imageView setImage:cellImage];
            }
            
            
            break;
 
            default:
            
            restaurantName = [Utilities getParseColumnValue:retail anyIndex:indexPath.row anyColumn:@"ImageName"];
            isParse = YES;
            
            if (isParse) {
                
                UIImage *cellImage = [Utilities getAzureStorageImage:retail anyIndex:indexPath.row];
                
                [cell.imageView setImage:cellImage];
            }
            
             terminal =   [Terminals objectAtIndex:terminalId];

            
            break;
            
    
    }
    
    restaurantImageName = [NSString stringWithFormat:restaurantImageNameFormat,imageId];
    
   
    if ([locationFormat length] > 0){
        finalLocation = [NSString stringWithFormat:locationFormat, terminal];
    }
    
    [cell.textLabel setText:restaurantName];
    
    [cell.detailTextLabel setText:finalLocation];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.accessoryView.tintColor = [UIColor whiteColor];
    if (! isParse){
        [cell.imageView setImage:[UIImage imageNamed:restaurantImageName]];
    }
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *message   = @"";
    @try {
        
        if (cell){
            //This will set the background of all of the views within the tablecell
            cell.contentView.superview.backgroundColor = kVerticalTableBackgroundColor;
            
            UIImage *cellImage = nil;
            
            if (appDelegate.isiPhone){
                cellImage = cell.imageView.image;
                if (cellImage){
                    cellImage = [ItemViewController imageResize:cellImage andResizeTo:CGSizeMake(90, 45)];
                }
                /*    [cell.imageView setImage:cellImage];
                 [cell.textLabel setFont:[UIFont fontWithName: @"Avenir Next Medium" size:14.0f]];
                 [cell.detailTextLabel setFont:[UIFont fontWithName: @"Avenir Next" size:12.0f]];*/
            }
            
 
        }
        
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        message = @"";
    }
    
}



-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = nil;
    header = [[UILabel alloc] init];
    [header setFont:[UIFont fontWithName:@"Avenir Medium" size:20]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setTextColor:[UIColor whiteColor]];
    [header setBackgroundColor:[UIColor blackColor]];
    switch (section) {
        case 0:
            [header setText:self.catName];
            break;

        }
    return header;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemViewController *item = [[ItemViewController alloc] init];
    [item setFoodType:Shops];
    
    NSString *price = @"$0.00",
                    *title = @"",
                    *data  = @"",
                    *desc  = @"";
    
    UIImage *image = nil;
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell){
        UIView *contentView = selectedCell.contentView;
        
        if (contentView){
            NSArray *subViews =  [contentView subviews];
            
            for (int viewCounter = 0; viewCounter < subViews.count; viewCounter++) {
                
                UIView *subView = [subViews objectAtIndex:viewCounter];
                
                if ([subView isKindOfClass:[UILabel class]]){
                    
                    UILabel *label = (UILabel*) subView;
                    
                    NSRange range = [label.text rangeOfString:@"$"];
                    
                    if ( range.location != NSNotFound){
                        price = [label.text substringFromIndex:1];
                        
                    }else{
                        
                        data = label.text;
                        
                        if ([title length] == 0){
                            title  = data;
                        }else{
                            if (data.length > 0){
                                desc = data;
                            }
                            
                            if ([title length] > 0 && [desc length] > [title length]){
                                if (data.length > 0){
                                    desc = data;
                                }
                            }
                        }
                        
                    }
                    
                }
                
                if ([subView isKindOfClass:[UIImageView class]]){
                    
                    UIImageView *imageV = (UIImageView*) subView;
                    
                    image = [imageV image];
                    
                }
                
            }
            
        }
    }
    
    if (item){
        [item.FlightLabel setText:@""];
        [item.TerminalLabel setText:@""];
        [item.StatusLabel setText:@""];
        [item.AircraftLabel setText:@""];
    }
    
    if (selectedCell.imageView){
        selectedImageView = selectedCell.imageView;
    }
    
    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:item animated:YES completion:^(void) {
        
        [item.imageView setImage:image];
        
    
        NSString *rndFoodImgFormat          = @"AirportShops_%d_%d.jpg",
                        *rndFoodImgFormatToo    = @"AirportShops_X_%d.jpg",
                        *rndFoodImgName            = @"",
                        *shopTypeImageName       = @"";
        
        NSInteger rndFoodImgId = arc4random_uniform(10);
        

        [item.TempIMGView  setImage:[UIImage imageNamed:@"pos_terminal-100.png"]];
        
        [item.ArrDepIMGView setImage:[UIImage imageNamed:@"multiple_devices_filled-100.png"]];
        
        [item setFoodType:Shops];

        /*
            @"Burberry",@"Chanel",@"Coach", @"Emporio Armani",@"Gucci", @"LongChamp",@"Louis Vuitton", @"Michael Kors",  @"Prada"
         
         1.      Burberry – pls indicate – Fashionable Accessories and Clothing
         2.      Coach – pls indicate – Fashionable Accessories and Clothing
         3.      Gucci – pls indicate – Fashionable Accessories and Clothing
         4.      Longchamp – not sure; however, even if it is accessories, pls change up the icon that we are using for accessories to a picture of a purse for example.
         5.      Long champ – the pictures are not changing by the way on Longchamp.
         6.      Louis Vuitton – Fashionable Accessories
         7.      Michael Kors – Women’s Accessories
         8.      Prada – Designer Fashion – pls change the icon to a purse perhaps.
         
         */
        
        NSArray *cuisines = [[NSArray alloc] initWithObjects:@"Fashionable Accessories\n & Clothing", @"Fragrances",
                                                                                              @"Fashionable Accessories\n & Clothing",
                                                                                              @"Fashionable Accessories\n & Clothing" , @"Luxury Leather\n Accessories",
                                                                                              @"Fashionable Accessories", @"Women’s Accessories", @"Designer Fashion",  nil],
        
                *cuisinesImages = [[NSArray alloc] initWithObjects:@"coat-50.png", @"perfume_bottle-100.png", @"wallet_filled-50.png",
                                                                                                @"glasses_filled-50.png" ,@"shopping_bag-100.png",
                                                                                                          @"womens_shoe-100.png",@"shopping_bag_filled-100.png", @"market_square_filled-100.png",nil],
        
                *clothes = [[NSArray alloc] initWithObjects:@"Neck Ties", @"Jackets", @"T-Shirts", @"Trousers", @"Hats" , nil],
        
                *clothesImages = [[NSArray alloc] initWithObjects:@"tie_filled-100.png",@"jacket-100.png", @"t_shirt-100.png",
                                                                                                          @"trousers-100.png",@"baseball_cap-100.png",nil],
        
                *skin = [[NSArray alloc] initWithObjects:@"Make Up", @"Moisturizers", @"Beauty", @"Perfumes",  nil],
        
                *skinImages = [[NSArray alloc] initWithObjects:@"cosmetic_brush-100.png" @"cream_tube-100.png",
                                                                                                          @"mirror-100.png",@"perfum_bottle_filled-100.png",nil],
        
                *giftTypes =[[NSArray alloc] initWithObjects:@"Chocolates", @"News & Events", @"Magazines",@"Skin Care" ,@"Gadgets", @"Smart Shop",nil],
        
               *giftImages = [[NSArray alloc] initWithObjects:@"macaron-100.png", @"news-100.png", @"news-100.png",
                                                                                                @"cosmetic_brush-100.png" ,@"electro_devices_filled-100.png",@"idea-100.png",nil],
        
               *elecTypes =[[NSArray alloc] initWithObjects:@"Digital Cameras", @"Video Cameras", @"Video Games",@"Laptops" ,@"Desktops", @"Batteries",nil],
        
               *elecImages = [[NSArray alloc] initWithObjects:@"camera_filled.png", @"camcorder_pro_filled.png", @"controller_filled.png",
                                        @"laptop_filled.png" ,@"server_filled.png",@"medium_battery_filled.png",nil],
        
               *bagTypes =[[NSArray alloc] initWithObjects:@"Beach Bags",nil],
        
               *bagImages = [[NSArray alloc] initWithObjects:@"shopping_bag_filled-100.png",nil],
        
              *beachTypes =[[NSArray alloc] initWithObjects:@"Beach Wear",nil],
        
              *beachImages = [[NSArray alloc] initWithObjects:@"market_square_filled-100.png",nil],
        
              *jewelTypes =[[NSArray alloc] initWithObjects:@"Jewelry & Watches",nil],
        
              *jewelImages = [[NSArray alloc] initWithObjects:@"icons8-ruby_gemstone.png",nil],
        
              *sunTypes =[[NSArray alloc] initWithObjects:@"Sunglasses & Eye Wear",nil],
        
              *sunImages = [[NSArray alloc] initWithObjects:@"glasses_filled-50.png",nil],
        
              *surfTypes =[[NSArray alloc] initWithObjects:@"Children's Clothing",nil],
        
              *surfImages = [[NSArray alloc] initWithObjects:@"icons8-girl_filled.png",nil],
        
              *hatTypes =[[NSArray alloc] initWithObjects:@"Designer Hats",nil],
        
              *hatImages = [[NSArray alloc] initWithObjects:@"German Hat_000000_100.png",nil],
        
             *tennisTypes =[[NSArray alloc] initWithObjects:@"Tennis Racquets",nil],
        
             *tennisImages = [[NSArray alloc] initWithObjects:@"Tennis_000000_100.png",nil],
        
            *mensshoes =[[NSArray alloc] initWithObjects:@"Mens Shoes",nil],
        
            *mensshoesImages = [[NSArray alloc] initWithObjects:@"icons8-mens_shoe_filled.png", @"icons8-mens_shoe_filled.png,",nil],
        
            *wmensshoes =[[NSArray alloc] initWithObjects:@"Womens Shoes",nil],
        
        *wmensshoesImages = [[NSArray alloc] initWithObjects:@"icons8-women_shoe_filled.png",nil],
        
              *ratings  = [[NSArray alloc] initWithObjects:@"Online Pay", @"InStore Pay", nil];
        
        NSInteger cuisineId = indexPath.row,
                  giftId      = indexPath.row,
                  rateId      = arc4random_uniform(ratings.count),
                  elecId      = arc4random_uniform(elecTypes.count),
                  bagId       = arc4random_uniform(bagTypes.count),
                  beachId     = arc4random_uniform(beachTypes.count),
                  jewelId     = arc4random_uniform(jewelTypes.count),
                  sunId       = arc4random_uniform(sunTypes.count),
                  surfId      = arc4random_uniform(surfTypes.count),
                  hatId       = arc4random_uniform(hatTypes.count),
                  tennisId    = arc4random_uniform(tennisTypes.count),
                  mshoeid     = arc4random_uniform(mensshoes.count),
                  wshoeid     = arc4random_uniform(wmensshoes.count),
                  clothingid    = arc4random_uniform(clothes.count);
        
        [item.weatherIMGView setImage:[UIImage imageNamed:shopTypeImageName]];

        [item.TempIMGView setImage:[UIImage imageNamed:@"smartphone_tablet_filled-50.png"]];

        
        [item.weatherIMGView setHidden:YES];
        [item.WeatherValue setHidden:YES];
        
        NSString        *cuisine = @"",
                        *gift   = @"",
                        *rating = [ratings objectAtIndex:rateId],
                        *hours  = @"Monday to Sunday 10 AM - 9 PM",
                        *phone  = [ItemViewController generateRandomPhone],
                        *elect  = [elecTypes objectAtIndex:elecId],
                        *bag    = [bagTypes objectAtIndex:bagId],
                        *beach  = [beachTypes objectAtIndex:beachId],
                        *jewel  = [jewelTypes objectAtIndex:jewelId],
                        *sun    = [sunTypes objectAtIndex:sunId],
                        *surf   = [surfTypes objectAtIndex:surfId],
                        *hat    = [hatTypes objectAtIndex:hatId],
                        *tennis = [tennisTypes objectAtIndex:tennisId],
                        *clo    = [clothes objectAtIndex:clothingid],
                        *site   = @"";
        
        UIImage *retailImage = nil;
        
        NSArray *titleData = [title componentsSeparatedByString:@"-"];
        NSString *newTitle =  title;
        if (titleData){
            newTitle = [titleData firstObject];
            selectedShop = [newTitle substringToIndex:newTitle.length];
            site  = [NSString stringWithFormat:@"www.%@.com", [newTitle stringByReplacingOccurrencesOfString:@"'" withString:@""]];
        }
        
        switch (retailId) {
            case 0:
                cuisine =   [cuisines objectAtIndex:cuisineId];
                 [item.Arrival_DepartureValue setText:cuisine];
                  shopTypeImageName = [cuisinesImages objectAtIndex:cuisineId];
                rndFoodImgId = cuisineId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                retailImage = selectedImageView.image;
                break;
            case 2:
                gift =  [mensshoes objectAtIndex:mshoeid],
                 [item.Arrival_DepartureValue setText:gift];
                shopTypeImageName = [mensshoesImages objectAtIndex:mshoeid];
                rndFoodImgName =[NSString stringWithFormat:@"%@_%d.jpg", [gift stringByReplacingOccurrencesOfString:@" " withString:@""], giftId];
                retailImage = selectedImageView.image;
                break;
            case 1:
                
                shopTypeImageName = [Utilities getParseColumnValue:appDelegate.electronicsbackgrounds anyIndex:indexPath.row anyColumn:@"IconName"];
                
                for(int idx = 0 ; idx < elecImages.count ; idx++ ){
                    NSString *eName = [elecImages objectAtIndex:idx];
                    if ([eName isEqualToString:shopTypeImageName]){
                        elecId = idx;
                        break;
                    }
                }
                
                elect =   [elecTypes objectAtIndex:elecId];
                [item.Arrival_DepartureValue setText:elect];

                rndFoodImgId = elecId;
                rndFoodImgName =  [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                retailImage = selectedImageView.image;
                break;
                
            case 3:
                bag =   [bagTypes objectAtIndex:bagId];
                [item.Arrival_DepartureValue setText:bag];
                shopTypeImageName = [bagImages objectAtIndex:bagId];
                rndFoodImgId = bagId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
               
                retailImage = selectedImageView.image;//[Utilities getAzureStorageImage:appDelegate.beachbags anyIndex:bagId];
                break;
                
              
                
            case 4:
                bag =   [wmensshoes objectAtIndex:wshoeid];
                [item.Arrival_DepartureValue setText:bag];
                shopTypeImageName = [wmensshoesImages objectAtIndex:wshoeid];
                rndFoodImgId = wshoeid;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                
                 retailImage = selectedImageView.image;//[Utilities getAzureStorageImage:appDelegate.beachwear anyIndex:beachId];
                break;
                
            case 5:
                jewel =   [jewelTypes objectAtIndex:jewelId];
                [item.Arrival_DepartureValue setText:jewel];
                shopTypeImageName = [jewelImages objectAtIndex:jewelId];
                rndFoodImgId = jewelId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                
                retailImage = selectedImageView.image;//[Utilities getAzureStorageImage:appDelegate.jewelrywatches anyIndex:jewelId];
                
                break;
                
            case 6:
                sun =   [sunTypes objectAtIndex:sunId];
                [item.Arrival_DepartureValue setText:sun];
                shopTypeImageName = [sunImages objectAtIndex:sunId];
                rndFoodImgId = sunId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                
                 retailImage = selectedImageView.image;//[Utilities getAzureStorageImage:appDelegate.sunglasses anyIndex:sunId];
                
                break;
            case 7:
                clo =   [clothes objectAtIndex:clothingid];
                [item.Arrival_DepartureValue setText:clo];
                shopTypeImageName = [clothesImages objectAtIndex:clothingid];
                rndFoodImgId = clothingid;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                
                retailImage = selectedImageView.image;//[Utilities getAzureStorageImage:appDelegate.sunglasses anyIndex:sunId];
                
                break;
                
            case 8:
                surf =   [surfTypes objectAtIndex:surfId];
                [item.Arrival_DepartureValue setText:surf];
                shopTypeImageName = [surfImages objectAtIndex:surfId];
                rndFoodImgId = surfId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                
                retailImage = selectedImageView.image;//[Utilities getAzureStorageImage:appDelegate.sunglasses anyIndex:sunId];
                
                break;
                
            case 9:
                tennis =   [tennisTypes objectAtIndex:tennisId];
                [item.Arrival_DepartureValue setText:tennis];
                shopTypeImageName = [tennisImages objectAtIndex:tennisId];
                rndFoodImgId = tennisId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,0];
                
                retailImage = selectedImageView.image;//[Utilities getAzureStorageImage:appDelegate.sunglasses anyIndex:sunId];
                
                break;
                
            default:
              
                elect =  self.categoryName;
                [item.Arrival_DepartureValue setText:elect];
                shopTypeImageName =  self.catLogo;
                rndFoodImgId = elecId;
                rndFoodImgName = [NSString stringWithFormat:rndFoodImgFormat,rndFoodImgId,giftId];
                
                retailImage = [Utilities getAzureStorageImage:retail anyIndex:giftId];
                
                hours  =   [Utilities getParseColumnValue:retail anyIndex:indexPath.row anyColumn:@"Hours"],
                phone =   [Utilities getParseColumnValue:retail anyIndex:indexPath.row anyColumn:@"Phone"],
                site    =   [Utilities getParseColumnValue:retail anyIndex:indexPath.row anyColumn:@"URL"];
                
                break;
        }
        
        if (retailImage){
            [item.AirlineIMGView setImage:retailImage];

        }else{
        
        [item.AirlineIMGView setImage:[UIImage imageNamed:rndFoodImgName]];
        }
        [item.AirlineIMGView setContentMode:UIViewContentModeScaleToFill];
        [item.AirlineIMGView.layer setBorderWidth:1.0f];
        UIColor *borderColor = [UIColor colorWithHexString:@"f0f0f0"];
        [item.AirlineIMGView.layer setBorderColor: borderColor.CGColor];
        
        UIImage *nImage = [UIImage imageNamed:shopTypeImageName];
        CGSize newSize = CGSizeMake(100, 100);
        
        if ([cuisine length] > 18 && indexPath.section == 0){
            newSize = CGSizeMake(60, 60);
            [item.Arrival_DepartureValue setFont:[UIFont fontWithName:@"Avenir Next" size:15.0f]];
        }
         nImage = [ItemViewController imageResize:nImage andResizeTo:newSize];
        [item.ArrDepIMGView setImage:nImage];
        
        [item.TempValue setNumberOfLines:0];
        [item.TempValue setText:@"R.O.P. ™\n (Reserve, Order & Pay)"];
        
        //[item.WeatherValue setText:cuisine];
       // [item.Arrival_DepartureValue setText:shopTypeImageName];
        
        [item.FlightLabel setText:@"Hours: "];
        
        [item.FlightValue setText:hours];
        
        //rating = @"Purchase Now";
        
        CGRect btnFrame = CGRectMake(item.TempIMGView.frame.origin.x,
                                     item.TempIMGView.frame.origin.y,
                                     item.TempIMGView.frame.size.width ,
                                     item.TempIMGView.frame.size.height);
        
        UIButton *btnReserve = [[UIButton alloc] initWithFrame:btnFrame];
        
        if (btnReserve){
            [btnReserve setBackgroundImage:item.TempIMGView.image forState:UIControlStateNormal];
            [btnReserve  setUserInteractionEnabled:YES];
            [btnReserve setShowsTouchWhenHighlighted:YES];
            
            [btnReserve addTarget:self action:@selector(actionReserveClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [item.TempIMGView setHidden:YES];
            [item.view addSubview:btnReserve];
            [item.view bringSubviewToFront:btnReserve];
            
        }
       
        
        [item.TerminalValue setText: [desc stringByReplacingOccurrencesOfString:@"Located Near " withString:@""]];
        [item.instructionsLabel setText:newTitle];
        [item.StatusLabel setText:@"Phone: "];
        item.TerminalValue.text =  [NSString stringWithFormat:@"%@",item.TerminalValue.text];
        if (appDelegate.isiPhone){
            switch (appDelegate.screenHeight) {
                case 736:
                    //tread as ipad
                    break;
                    
                default:
                    phone = [NSString stringWithFormat:@"\n%@",phone];
                    break;
            }
        }else{
            [item.TerminalLabel setNumberOfLines:0];
            item.TerminalLabel.text =  [item.TerminalLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"/\n"];
        }
        [item.StatusValue setText:phone];
        [item.AircraftLabel setText:@"Web Site: "];
        [item.AircraftValue setText:[site stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSInteger imgCount = 1;
        
        switch (retailId) {
            case 0:
                rndFoodImgFormatToo  = [rndFoodImgFormatToo stringByReplacingOccurrencesOfString:@"X"
                                                                                      withString:[NSString stringWithFormat:@"%d",indexPath.row]];
                
                
                switch (indexPath.row) {
                    case 1:
                        
                        clothes = skin;
                        clothesImages = skinImages;
                        break;
                        
                    default:
                        break;
                }
                
              //  [item startRandomStatus:clothes :clothesImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                imgCount = 5;
               // [item startTimer:rndFoodImgFormatToo :imgCount];

                break;

            case 2:
                
                switch (indexPath.row) {
                    case 0:
                           rndFoodImgFormat = @"Chocolates_%d.jpg";
                        imgCount = 4;
                        break;
                    case 1:
                        rndFoodImgFormat = @"News&Events_%d.jpg";
                        imgCount = 4;
                        break;
                    case 2:
                        rndFoodImgFormat = @"Magazines_%d.jpg";
                        imgCount = 4;
                        break;
                    case 3:
                        rndFoodImgFormat = @"SkinCare_%d.jpg";
                        imgCount = 4;
                        break;
                    case 4:
                        rndFoodImgFormat = @"Gadgets_%d.jpg";
                        imgCount = 4;
                        break;
                    case 5:
                        rndFoodImgFormat = @"SmartShop_%d.jpg";
                        imgCount = 4;
                        break;
                }
              //  [item startTimer:rndFoodImgFormat :imgCount];
                break;
                
            case 1:
                rndFoodImgFormat = @"Gadgets_%d.jpg";
              //  imgCount = 4;
             //   [item startTimer:rndFoodImgFormat :imgCount];
                break;
            case 3:
               // [item startRandomStatus:bagTypes :bagImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                

                break;
            case 4:
            //    [item startRandomStatus:beachTypes :beachImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                
                
                break;
            case 5:
             //   [item startRandomStatus:jewelTypes :jewelImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                
                
                break;
            case 6:
            //    [item startRandomStatus:sunTypes :sunImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                
                
                break;
            case 7:
            //    [item startRandomStatus:surfTypes :surfImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                
                
                break;
            case 8:
            //    [item startRandomStatus:hatTypes :hatImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                
                
                break;
                
            case 9:
           //     [item startRandomStatus:tennisTypes :tennisImages :item.Arrival_DepartureValue :item.ArrDepIMGView];
                
                
                break;
            default:
                
                break;
        }
 

 
        
    }];
}

- (IBAction)actionReserveClicked:(UIButton *)sender {
    NSURL    *url= nil;
    
    NSString *currentName = @"",
    *message= @"",
    *launchURL = @"";
    
    @try {
        
        currentName = selectedShop;
        if ([currentName length] > 0){
            currentName = [currentName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSLog(@"Invoking OMPN for %@",currentName);
        }
        
        launchURL = [NSString stringWithFormat:@"%@?term=%@",kOMPNApp,currentName];
        
        url=  [[NSURL alloc] initWithString:launchURL];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            message = [NSString stringWithFormat:@"Launching OMPN App-> %@",url];
        }else{
            url=  [[NSURL alloc] initWithString:kOMPN];
            message = [NSString stringWithFormat:@"Launching OMPN Web-> %@",url];
        }
        [[UIApplication sharedApplication] openURL:url];
    }
    @catch (NSException *exception) {
        message = exception.description;
    }
    @finally {
        url = nil;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = 1 ;
    return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    switch (section) {
        case 0:
         rows =   retail.count;
            break;
        
    }
    return rows;
}

-(UIView*) getSpecialTitleView: (NSString*) anyTitle{
    UILabel *titleView = nil;
    NSString *message = @"";
    @try {
        titleView = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 65.0f)];
        [titleView setBackgroundColor:[UIColor clearColor]];
        [titleView setNumberOfLines:0];
        [titleView setTextColor:[UIColor blackColor]];
        [titleView setTextAlignment:NSTextAlignmentCenter];
        [titleView setFont:[UIFont fontWithName:@"Avenir Roman" size:18.0f]];
        [titleView setText:anyTitle];
    }
    @catch (NSException *exception) {
        message = [exception description];
    }
    @finally {
        if (message.length > 0){
            NSLog(@"%@",message);
        }
        message = @"";
    }
    return titleView;
}

-(void) viewDidLoad{
    if (! appDelegate){
        appDelegate = [AppDelegate currentDelegate];
    }
    [self initTableView];
    [self.navigationItem setTitleView:[self getSpecialTitleView:@""]];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkOrderCount];
}
@end
