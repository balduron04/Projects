//
//  LoginViewController.m
//  Project
//
//  Created by ubicomp7 on 10/21/14.
//  Copyright (c) 2014 team5. All rights reserved.
//

#import "LoginViewController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize LoginButton, RegisterButton, ErrorLabel, UsernameField, PasswordField, ImageView, LoginView, RegisterView, Username2, Password2, PasswordConfirm, ActivityIndicator;

PFUser *user;

- (void)viewDidLoad {
    [super viewDidLoad];
    ErrorLabel.layer.borderColor = [UIColor redColor].CGColor;
    ErrorLabel.layer.borderWidth = 1.0f;
    LoginView.layer.borderColor = [UIColor grayColor].CGColor;
    LoginView.layer.borderWidth = .75f;
    RegisterView.layer.borderColor = [UIColor grayColor].CGColor;
    RegisterView.layer.borderWidth = .75f;
    UsernameField.delegate = self;
    PasswordField.delegate = self;
    user = [PFUser currentUser];
    if (user != nil && user.username.length >= 3)
    {
        [self loggedIn];
        return;
    }
    ErrorLabel.hidden = true;
    if ([self loadAccount])
        [self login:UsernameField.text password:PasswordField.text];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:224.0/255.0 green:221.0/255.0 blue:217.0/255.0 alpha:1.0]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    if ([AppDelegate isLoggedOut])
    {
        [self loseAccount];
        PasswordField.text = @"";
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)RegisterUp:(id)sender {
    LoginView.hidden = true;
    RegisterView.hidden = false;
    Username2.text = UsernameField.text;
    Password2.text = PasswordField.text;
    [self hideError];
}
- (IBAction)LoginUp:(id)sender {
    if ([UsernameField.text length] < 3)
    {
        [self displayError:@"Please provide a username."];
    }
    else if ([PasswordField.text length] < 6)
    {
        [self displayError:@"Please provide a password."];
    }
    else
    {
        [ActivityIndicator startAnimating];
        [self login:UsernameField.text password:PasswordField.text];
    }
}
- (IBAction)ForgotPasswordUp:(id)sender {
    [self displayError:@"Too bad."];
}
- (IBAction)CreateUp:(id)sender {
    if ([Username2.text length] < 3)
    {
        [self displayError:@"Please provide a username."];
    }
    else if ([Password2.text length] < 6)
    {
        [self displayError:@"Please provide a password."];
    }
    else if ([Password2.text isEqual:PasswordConfirm.text])
    {
        [ActivityIndicator startAnimating];
        [self create:Username2.text password:Password2.text];
    }
    else
        [self displayError:@"Password does not match."];
}
- (IBAction)BackUp:(id)sender {
    LoginView.hidden = false;
    RegisterView.hidden = true;
}
- (IBAction)UsernameEdited:(id)sender {
    if ([UsernameField.text length] >= 3)
    {
        [self hideError];
    }
}
- (IBAction)Username2Edited:(id)sender {
    if ([Username2.text length] >= 3)
    {
        [self hideError];
    }
}
- (IBAction)Password2Edited:(id)sender {
    if ([Password2.text length] >= 6)
    {
        [self hideError];
    }
}
- (IBAction)PasswordEdited:(id)sender {
    if ([PasswordField.text length] >= 6)
    {
        [self hideError];
    }
}

-(void) displayError: (NSString*) err
{
    ErrorLabel.text = err;
    ErrorLabel.hidden = false;
}

-(void) hideError
{
    ErrorLabel.hidden = true;
}

-(void) login: (NSString*) username password: (NSString*) password
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (!error)
            [self loggedIn];
        else
            [ActivityIndicator stopAnimating];
            [self displayError:@"Incorrect username or password."];
    }];
    [AppDelegate log:true];
}

-(void) create: (NSString*) username password: (NSString*) password
{
    user = [PFUser user];
    user.username = username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self loggedIn];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [self displayError:errorString];
        }
    }];
}

-(void) loggedIn
{
    [self.revealViewController.rearViewController viewDidLoad];
    [self saveAccount];
    [self hideError];
    [self performSegueWithIdentifier:@"PostListsSegue" sender:self];
}

-(void) saveAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UsernameField.text forKey:@"username"];
    [defaults setObject:PasswordField.text forKey:@"password"];
}

-(void) loseAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UsernameField.text forKey:@"username"];
    [defaults setObject:@"" forKey:@"password"];
}

-(bool) loadAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    UsernameField.text = username;
    if ([AppDelegate isLoggedOut] == false)
    {
        return false;
    }
    else
    {
        NSString *password = [defaults objectForKey:@"password"];
        if ([username length] < 3 || [password length] < 6)
            return false;
        PasswordField.text = password;
        return true;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.PasswordField) {
        [theTextField resignFirstResponder];
        [self LoginUp: nil];
    } else if (theTextField == self.UsernameField) {
        [self.PasswordField becomeFirstResponder];
    }
    return YES;
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
