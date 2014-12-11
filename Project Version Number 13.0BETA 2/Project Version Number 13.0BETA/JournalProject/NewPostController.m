//
//  PostViewController.m
//  JournalProject
//
//  Created by ubicomp11 on 11/11/14.
//  Copyright (c) 2014 Jessica Pittman. All rights reserved.
//

#import "NewPostController.h"
#import "ViewPostController.h" //This code is for testing the view post.
#import "SWRevealViewController.h"

@interface NewPostController ()

@end

@implementation NewPostController
@synthesize ActivityIndicator, TagsField, PostView, TitleField, usernameLabel, dateLabel, Image1, ErrorLabel;

PFUser* user;
PFObject* post;
CGPoint originalCenter;
PFFile *postImage;
NSString* placeholder;
PFGeoPoint* loc;

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [PFUser currentUser];
    usernameLabel.text = user.username;
    placeholder = PostView.text;
    PostView.delegate = self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    self.title = [NSString stringWithFormat:@"%@ - %@", @"New Entry", dateLabel.text];
    originalCenter = self.view.center;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:72.0/255.0 green:145.0/255.0 blue:116.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    [super viewDidAppear:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) uploadPost
{
    post = [PFObject objectWithClassName:@"Post"];
    post[@"username"] = user.username;
    post[@"title"] = TitleField.text;
    if (loc == nil)
    {
        loc = [PFGeoPoint alloc];
    }
    post[@"location"] = loc;
    post[@"content"] = PostView.text;
    post[@"tags"] = [self parseTags];
    post[@"likes"] = @0;
    post[@"commentsEnabled"] = @true;
    if (postImage != nil)
        post[@"imageArray"] = postImage;
    post[@"author"] = user;
    [post.ACL setPublicWriteAccess:YES];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [ActivityIndicator stopAnimating];
        if (!error)
            [self.navigationController popViewControllerAnimated:YES];
        else
            [self displayError:[error userInfo][@"error"]];
    }];
}

-(NSString*) getLocationString
{
    return @"N 29.762895, W 95.383173";
}

-(void) displayError: (NSString*) error
{
    ErrorLabel.text = error;
    ErrorLabel.hidden = false;
}

-(void) hideError
{
    ErrorLabel.text = @"";
    ErrorLabel.hidden = true;
}

- (IBAction)PostUp:(id)sender {
    if (TitleField.text.length < 2)
    {
        [self displayError:@"Title needs to be longer."];
    }
    else if (PostView.text.length < 4 || [PostView.text isEqualToString:placeholder])
    {
        [self displayError:@"Post needs more text."];
    }
    else
    {
        [ActivityIndicator startAnimating];
        [self uploadPost];
    }
}
- (IBAction)CancelUp:(id)sender {
}
- (IBAction)AddImageUp:(id)sender
{
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:picker animated:YES completion:NULL];}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //[imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if(CFStringCompare((CFStringRef) mediaType, kUTTypeMovie, 0)==kCFCompareEqualTo)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [imageView setImage:image];
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        NSData *imageData = [NSData dataWithContentsOfFile:moviePath];
        postImage = [PFFile fileWithName:@"video.mp4" data:imageData];
    }
    else
    {
        // if its an image, set it to the files
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [imageView setImage:image];
        
        NSData *imageData = UIImageJPEGRepresentation(image, .5f);
        postImage = [PFFile fileWithName:@"image.jpeg" data:imageData];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)TagsEdited:(id)sender {
}
-(NSString*) parseTags
{
    return TagsField.text;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ViewPostController* vc = segue.destinationViewController;
    vc.entry = post;
}

- (void)keyboardDidShow:(NSNotification *)note
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.view.center = CGPointMake(originalCenter.x, originalCenter.y - 10);
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeholder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error)
        {
            loc = geoPoint;
        }
    }];
    [textView becomeFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([ErrorLabel.text containsString:@"Post"] && PostView.text.length >= 4 && ![textView.text isEqualToString:placeholder])
    {
        [self hideError];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeholder;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
- (IBAction)TitleChanged:(id)sender {
    if ([ErrorLabel.text containsString:@"Title"] && TitleField.text.length >= 2)
    {
        [self hideError];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:72.0/255.0 green:145.0/255.0 blue:116.0/255.0 alpha:1.0]];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
}

@end
