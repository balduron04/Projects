//
//  ViewPostController.m
//  JournalProject
//
//  Created by Jessica Pittman on 11/12/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import "ViewPostController.h"
#import "SWRevealViewController.h"
#import "MapViewController.h"

@interface ViewPostController ()
@end

#define FONT_SIZE 20.0f
#define CELL_CONTENT_WIDTH 715.0f
#define CELL_CONTENT_MARGIN 20.0f

@implementation ViewPostController
@synthesize TitleLabel, PostView, CommentLabel, CommentTable, CommentView, LeaveCommentLabel, UsernameLabel, saveCommentButton, entry, ScrollView, LikesLabel,Likebutton, postImageView, dateLabel, PosterLabel, commentSectionView, FollowButton, DeleteButton,postButtonImage;
PFUser* user;
NSMutableArray* commentArray;
CGPoint originalCenter;

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [PFUser currentUser];
    PFFile *postimage = entry[@"imageArray"];
    [postimage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            if([postimage.name containsString:@".jpeg"]){
                [postButtonImage setImage:[UIImage imageWithData:imageData] forState:UIControlStateDisabled];
                [postButtonImage setEnabled:NO];
            }
            else if([postimage.name containsString:@".mp4"])
                [postButtonImage setImage:[UIImage imageNamed:@"movie_play.png"] forState:UIControlStateNormal];
        }
        else [postButtonImage setImage:[UIImage imageNamed:@"appbar.3d.x.png"] forState:UIControlStateNormal];
    }];
    
    PFQuery *UserRead = [PFQuery queryWithClassName:@"LikeSignature"];
    [UserRead whereKey:@"parentUser" equalTo:user];
    [UserRead whereKey:@"parentPost" equalTo:entry];
    [UserRead findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if(results.count>0)
        {
            Likebutton.enabled = NO;
            [Likebutton setImage:[UIImage imageNamed:@"redheart-filled.png"] forState:UIControlStateDisabled];
        }
    }];
    
    UserRead = [PFQuery queryWithClassName:@"Following"];
    [UserRead whereKey:@"Follower" equalTo:user];
    [UserRead whereKey:@"TargetUser" equalTo:entry[@"author"]];
    [UserRead findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if(results.count>0)
        {
            FollowButton.enabled = NO;
            [FollowButton setTitle:@"Following" forState:UIControlStateDisabled];
        }
    }];
    PFUser *tempUser = entry[@"author"];
    if (![tempUser.objectId isEqual:user.objectId])
    {
        [DeleteButton setHidden:YES];
    }
    CommentView.delegate = self;
    CommentView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    TitleLabel.text = [NSString stringWithFormat:@"%@", entry[@"title"]];
    PostView.delegate = self;
    PostView.text = entry[@"content"];
    PostView.font = [UIFont fontWithName:@"Kannada Sangam MN" size:24];
    PostView.center = CGPointMake(PostView.center.x, PostView.center.y-0);
    
    CGFloat fixedWidth = PostView.frame.size.width;
    CGSize newSize = [PostView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = PostView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    PostView.frame = newFrame;
    
    
    [commentSectionView setCenter:CGPointMake(PostView.center.x, 200 + PostView.frame.size.height)];
    
    LikesLabel.text = [NSString stringWithFormat:@"%@ likes", entry[@"likes"]];
    PosterLabel.text = entry[@"username"];
    UsernameLabel.text = user.username;
    commentArray = [[NSMutableArray alloc] init];
    CommentTable.dataSource = self;
    CommentTable.delegate = self;
    
    
    originalCenter = self.view.center;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.title = TitleLabel.text;
    //set bar color
    CommentTable.separatorColor = [UIColor clearColor];
    CommentTable.scrollEnabled = false;
    [self loadComments];
    //[ScrollView setContentSize:CGSizeMake(736, 1248)];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SaveCommentUp:(id)sender {
    if (CommentView.text.length < 4)
        return;
    PFObject* comment = [PFObject objectWithClassName:@"comment"];
    comment[@"entry"] = entry.objectId;
    comment[@"username"] = user.username;
    comment[@"date"] = [NSDate date];
    comment[@"content"] = CommentView.text;
    saveCommentButton.enabled = false;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            //Activity Indicator.
            CommentView.text = @"";
            saveCommentButton.enabled = true;
            [commentArray addObject:comment];
            [self reloadCommentTable];
        }
        else
        {
            
        }
    }];
}

-(void) loadComments
{
    PFQuery* query = [PFQuery queryWithClassName:@"comment"];
    [query whereKey:@"entry" equalTo:entry.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [commentArray addObject:object];
            }
            [self reloadCommentTable];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    //Query for comments with entry of certain id.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    UILabel* label = (UILabel *)[cell viewWithTag:1];
    label.text = commentArray[indexPath.row][@"username"];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    
    UILabel* labelDate = (UILabel *)[cell viewWithTag:5];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    labelDate.text = [dateFormatter stringFromDate:commentArray[indexPath.row][@"date"]];
    labelDate.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    UITextView* view = (UITextView*)[cell viewWithTag:2];
    view.text = commentArray[indexPath.row][@"content"];
    view.font=[UIFont fontWithName:@"Helvetica" size:20];
    
    
    CGFloat fixedWidth = view.frame.size.width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    view.frame = newFrame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height - 20);
    cell.frame = newFrame;
    return cell;
}

- (void)keyboardDidShow:(NSNotification *)note
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.view.center = CGPointMake(originalCenter.x, originalCenter.y - [self getKeyBoardHeight:note] / 4);
    [UIView commitAnimations];
}
-(void)keyboardDidHide:(NSNotification *)note
{
    self.view.center = originalCenter;
}
- (NSInteger)getKeyBoardHeight:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSInteger keyboardHeight = keyboardFrameBeginRect.size.height;
    return keyboardHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (IBAction)LikePost:(id)sender {
    PFObject *uniqueLike = [PFObject objectWithClassName:@"LikeSignature"];
    uniqueLike[@"parentUser"] = user;
    uniqueLike[@"parentPost"] = entry;
    int likes = [entry[@"likes"] intValue];
    entry[@"likes"] = [NSNumber numberWithInt:likes + 1];
    LikesLabel.text = [NSString stringWithFormat:@"%@ likes", entry[@"likes"]];
    [entry saveInBackground];
    [uniqueLike saveInBackground];
    [Likebutton setImage:[UIImage imageNamed:@"redheart-filled.png"] forState:UIControlStateNormal];
    Likebutton.enabled = NO;
}
- (IBAction)mapButton:(id)sender
{
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
    
    
}
- (IBAction)FollowUser:(id)sender {
    PFUser *entryAuth = entry[@"author"];
    PFObject *followers = [PFObject objectWithClassName:@"Following"];
    followers[@"Follower"] = user;
    followers[@"TargetUser"] = entryAuth;
    FollowButton.enabled = false;
    [FollowButton setTitle:@"Following" forState:UIControlStateDisabled];
    [followers saveInBackground];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController* mvc = segue.destinationViewController;
    mvc.post = entry;
}
- (IBAction)shareButton:(id)sender {
    
    NSUInteger amountToTake = 70;
    if(PostView.text.length < 70)
        amountToTake = PostView.text.length;
    
    NSArray *objectsToShare = @[@"Check out this post!", [NSString stringWithFormat:@"%@ -> %@", TitleLabel.text, [PostView.text substringToIndex:amountToTake]]];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    activityVC.popoverPresentationController.sourceView = self.parentViewController.view;
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void) reloadCommentTable {
    [CommentTable reloadData];
    CGFloat fixedWidth2 = CommentTable.frame.size.width;
    CGSize newSize2 = [CommentTable sizeThatFits:CGSizeMake(fixedWidth2, MAXFLOAT)];
    CGRect newFrame2 = CommentTable.frame;
    newFrame2.size = CGSizeMake(fmaxf(newSize2.width, fixedWidth2), newSize2.height + 70);
    CommentTable.frame = newFrame2;
    
    CGFloat fixedWidth3 = PostView.frame.size.width;
    CGSize newSize3 = [PostView sizeThatFits:CGSizeMake(fixedWidth3, MAXFLOAT)];
    CGRect newFrame3 = ScrollView.frame;
    newFrame3.size = CGSizeMake(fmaxf(newSize3.width, fixedWidth3), CommentTable.frame.size.height + PostView.frame.size.height + 200);
    [ScrollView setContentSize:newFrame3.size];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:    (NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = commentArray[indexPath.row][@"content"];;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 30000.0f);
    
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
    
    CGFloat height = MAX(size.height, 40.0f);
    
    if(height > 40)
        height += 10;
    return height + (CELL_CONTENT_MARGIN * 2);
}
- (IBAction)DeletePost:(id)sender {
    [entry deleteInBackground];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)postImageButton:(UIButton *)sender {
    //NSLog(@"nice touch");
    PFFile * fileName = entry[@"imageArray"];
    NSString *str = fileName.name;
    NSString *baseURL = @"http://files.parsetffs.com/";
    if([str  containsString:@".mp4"])
    {
        PFFile *myFile = entry[@"imageArray"];
        NSString *smallString = [NSString stringWithFormat:(@"%@%@",baseURL,myFile.url)] ;
        NSLog(@"%@",smallString);
        NSURL *url = [NSURL URLWithString:smallString];
        NSLog(@"%@",url);
        NSLog(@"url of video file is %@", smallString );
        
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:player];
        
    }
}


@end
