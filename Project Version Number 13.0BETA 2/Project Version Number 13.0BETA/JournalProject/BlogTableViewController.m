//

#import "BlogTableViewController.h"
#import "NewPostController.h"
#import "ViewPostController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@implementation BlogTableViewController
{
    NSArray *searchResults;
}

@synthesize postArray, sidebarButton, selector;
PFUser *user;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Posts"];
    
    //[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonHandler:)]]; //Switch to menu button that opens menu.
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPostButtonHandler:)]];
    
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    [self.navigationItem setLeftBarButtonItem:sidebarButton];
}

- (void)viewWillAppear:(BOOL)animated 
{
    indexRow = -1;
    user = [PFUser currentUser];
   if ([PFUser currentUser])
       [self refreshButtonHandler:nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:72.0/255.0 green:145.0/255.0 blue:116.0/255.0 alpha:1.0]];
 //   [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self refreshButtonHandler:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshButtonHandler:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        [self Logout:nil];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"tags contains[c] %@", searchText];
    searchResults = [postArray filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark - Button handlers

- (void)refreshButtonHandler:(id)sender 
{
    //Create query for all Post object by the current user
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    // case switch starts here:
    NSArray *following;
    NSMutableArray* followingUsernames = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Following"];
    switch (selector) {
        case 1:
            // Return only user's posts (My Posts)
            [postQuery whereKey:@"username" equalTo:user.username];
            break;
        case 2:
            // Return objects from most liked to least liked (Trending)
            [postQuery orderByDescending:@"likes"];
            break;
        case 3:
            // Return objects in following list (Following)
            [query whereKey:@"Follower" equalTo:user];
            following = [query findObjects];
            for(int i = 0; i < following.count; i++)
            {
                PFUser *use = following[i][@"TargetUser"];
                [use fetchIfNeeded];
                [followingUsernames addObject:use.username];
            }
            [postQuery whereKey:@"username" containedIn:followingUsernames];
            break;
            
        default:
            // Return objects from newest to oldest (Search)
            [postQuery orderByDescending:@"createdAt"];
            break;
    }
    
    // Run the query
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Save results and update the table
            postArray = objects;
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)Logout:(id)sender {
    [PFUser logOut];
    [self.revealViewController.rearViewController viewDidLoad];
    [AppDelegate log:false];
    //PFUser *currentUser = [PFUser currentUser];
}

- (void)addPostButtonHandler:(id)sender 
{
    [self performSegueWithIdentifier:@"NewPost" sender:self];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [postArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PFObject *post;
    // Configure the cell with the textContent of the Post as the cell's text label
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        post = [searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        post = [postArray objectAtIndex:indexPath.row];
    }
       // [cell.textLabel setText:[NSString stringWithFormat:@"%@ wrote: %@.    %@", [post objectForKey:@"username"], [post objectForKey:@"title"], [post objectForKey:@"content"]]];
    UILabel* usernm = (UILabel*) [cell.contentView viewWithTag:1];
    UILabel* ttle = (UILabel*) [cell viewWithTag:2];
    UILabel* lke = (UILabel*) [cell viewWithTag:100];
    usernm.text = [post objectForKey:@"username"];
    ttle.text = [post objectForKey:@"title"];
    lke.text = [NSString stringWithFormat:@"%@ likes", [post objectForKey:@"likes"]];
    PFFile *userImageFile = post[@"imageFile"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
    {
        if(!error)
        {
            UIImage *image = [UIImage imageWithData:imageData];
        }
    }];
    
    return cell;
}

int indexRow;
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexRow = indexPath.row;
    [self performSegueWithIdentifier:@"ViewPost" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (indexRow >= 0)
    {
        ViewPostController* vp = segue.destinationViewController;
        vp.entry = postArray[indexRow];
    }
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


@end
