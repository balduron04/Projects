//
//  SidebarViewController.m
//  AnonJournal
//
//  Created by Esraa Bataineh on 10/27/14.
//  Copyright (c) 2014 Esraa Bataineh. All rights reserved.
//

#import "SidebarViewController.h"
#import "NavigationHeaderCell.h"
#import "NavigationSubCell.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"
#import "NewPostController.h"
#import "BlogTableViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController
@synthesize navigationTable;

PFUser* user;
NSMutableArray *dataArray;
double HeaderCellHeight = 38.0;
double SubCellHeight = 38.0;
bool loggedIn = false;
NSInteger _presentedRow;

-(void)reloadLeftNavigation
{
    [super viewDidAppear:YES];
    [navigationTable setDelegate:self];
    [navigationTable setDataSource:self];
    [navigationTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    dataArray = [[NSMutableArray alloc] init];
    [dataArray removeAllObjects];
    
    user = [PFUser currentUser];
    if(user.username != nil)
        loggedIn = true;
    else
        loggedIn = false;
    
    //First Section data
    NSMutableArray* firstSectionArray = [[NSMutableArray alloc] init];
    NSMutableArray* secondSectionArray = [[NSMutableArray alloc] init];
    if(loggedIn) {
        firstSectionArray = [[NSMutableArray alloc] initWithObjects: @"My Profile",@"My Journal",@"New Journal Entry", @"Trending",@"Following", @"Location",@"Search",@"Settings",@"Log Out", nil];
        secondSectionArray = [[NSMutableArray alloc] initWithObjects:@"Search", @"Trending",@"Following", @"Location", nil];
    }
    else{
        firstSectionArray = [[NSMutableArray alloc] initWithObjects:@"Login / Register", nil];
        //secondSectionArray = [[NSMutableArray alloc] init];
    }
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstSectionArray forKey:@"data"];
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondSectionArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
   // [dataArray addObject:secondItemsArrayDict];
    [navigationTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self reloadLeftNavigation];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadLeftNavigation];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. Dequeue the custom header cell
    NavigationHeaderCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"NavigationHeaderCell"];
    
    if(section == 0)
    {
        if(!loggedIn)
            headerCell.title.text = @"Join Us!";
        else
            headerCell.title.text = [NSString stringWithFormat:@"Hello %@!", user.username];
        headerCell.image.image = [UIImage imageNamed:@"smiley-face"];
    }
    else if(section == 1)
    {
        headerCell.title.text = @"Website";
        headerCell.image.image = [UIImage imageNamed:@"smiley-face"];
    }
    //[headerCell.title sizeToFit];
    headerCell.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    headerCell.backgroundColor = [self view].tintColor;
    return headerCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SubCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NavigationSubCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NavigationSubCell"];
    
    //[cell addSubview:[self drawSeparationView: 1]];
    
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.title.text = cellValue;
    cell.title.font = [UIFont fontWithName:@"Helvetica" size:18];
    if ([cell.title.text isEqual:@"Log Out"])
    {
        cell.title.textColor = [UIColor whiteColor];
        cell.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        cell.contentView.backgroundColor = [UIColor colorWithRed:255.0/255 green:0/255 blue:0/255 alpha:.65];
        //cell.contentView.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Get the selected country
    
    //NSString *selectedCell = nil;
    //NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    //NSArray *array = [dictionary objectForKey:@"data"];
    //selectedCell = [array objectAtIndex:indexPath.row];
    
    
    //[navigationTable deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //SWRevealViewController *revealController = self.revealViewController;
    
    NSInteger row = indexPath.row;
//    _presentedRow = 1000;
//    
//    if ( row == _presentedRow )
//    {
//        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//        return;
//    }
//    else if (row == 2)
//    {
//        [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
//        return;
//    }
//    else if (row == 3)
//    {
//        [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
//        return;
//    }
    
    //UIViewController *newFrontController = nil;
    //:@"My Journals", @"Create new Journal",@"Search", @"Trending",@"Following", @"Location", @"settings", @"Log Out", nil];
    //:@"Search", @"Trending",@"Following", @"Location", nil];
    if(loggedIn)
    {
        BlogTableViewController *blogView;
        UINavigationController *mnav;
        NewPostController *postView;
        LoginViewController *loginView;
        MapViewController   *mapView;
        ProfileViewController *profileView;
        SettingsViewController *settingsView;
        switch (row) {
            case 0://PROFILE
                blogView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlogView"];
                profileView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Profile"];
                mnav = [[UINavigationController alloc]initWithRootViewController:profileView];
                break;
            case 1://MY ENTRIES
                blogView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlogView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:blogView];
                blogView.selector = 1;
                break;
            case 2://NEW ENTRY
                blogView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlogView"];
                postView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewPostView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:blogView];
                break;
            case 4://FOLLOWING
                blogView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlogView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:blogView];
                blogView.selector = 3;
                break;
            case 5://LOCATION
                mapView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MapView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:mapView];
                break;
            case 6://SEARCH
                blogView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlogView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:blogView];
                blogView.selector = 2;
                break;
            case 7:
                blogView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlogView"];
                settingsView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"settingsView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:settingsView];
                break;
            case 8://LOGOUT
                [PFUser logOut];
                [AppDelegate log:false];
                loginView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:loginView];
                break;
                
            default:
                blogView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlogView"];
                mnav = [[UINavigationController alloc]initWithRootViewController:blogView];
                blogView.selector = 0;
                break;
        }
        [mnav pushViewController:postView animated:YES];
        [self.revealViewController.rearViewController viewDidLoad];
        [self.revealViewController pushFrontViewController:mnav animated:YES];
    }
    else if(!loggedIn)
    {
        if(row == 0)
        {
            LoginViewController *loginView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
            UINavigationController *mnav = [[UINavigationController alloc]initWithRootViewController:loginView];
            [self.revealViewController.rearViewController viewDidLoad];
            [self.revealViewController pushFrontViewController:mnav animated:YES];
        }
            
    }
    
    
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    //[revealController pushFrontViewController:navigationController animated:YES];
    
    _presentedRow = row;  // <- store the presented row

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UIView*)drawSeparationView: (NSInteger)typeis {
    UIView *view = [[UIView alloc] init];
    
    if(typeis == 1)
    {
        view.frame = CGRectMake(0, 0, self.navigationTable.frame.size.width, HeaderCellHeight);
    }
    /*
    else if(typeis == 2)
    {
        view.frame = CGRectMake(0, 0, self.navigationTable.frame.size.width, SubCellHeight);
    }
//*/
    UIView *lowerStrip = [[UIView alloc]init];
    lowerStrip.backgroundColor = [UIColor grayColor];
    lowerStrip.frame = CGRectMake(0, 43, view.frame.size.width, 2);
    
    [view addSubview:lowerStrip];
    return view;
}


@end
