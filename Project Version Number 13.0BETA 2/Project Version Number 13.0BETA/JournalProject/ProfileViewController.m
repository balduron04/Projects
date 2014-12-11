//
//  ProfileViewController.m
//  JournalProject
//
//  Created by ubicomp9 on 12/8/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize ProfileImage, NameLabel, DateLabel, Following, Activity, sidebarButton;
PFUser* user;
NSArray *followerArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    user = [PFUser currentUser];
    PFFile *userImageFile = user[@"profileImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            ProfileImage.image = [UIImage imageWithData:imageData];
        }
    }];
    NameLabel.text = user[@"username"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    DateLabel.text = [dateFormatter stringFromDate: user.createdAt];
    [Following setDelegate:self];
    [Following setDataSource:self];
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    [self.navigationItem setLeftBarButtonItem:sidebarButton];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Following"];
    [query whereKey:@"Follower" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            followerArray = objects;
            [Following reloadData];
        }
    }];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:72.0/255.0 green:145.0/255.0 blue:116.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    //   [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return followerArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel* text;
    text = (UILabel*) [cell viewWithTag:1];
    PFUser *use = followerArray[indexPath.row][@"TargetUser"];
    [use fetchIfNeeded];
    text.text = use.username;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
