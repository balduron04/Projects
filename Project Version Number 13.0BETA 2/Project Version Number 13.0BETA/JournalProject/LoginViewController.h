//
//  LoginViewController.h
//  Project
//
//  Created by ubicomp7 on 10/21/14.
//  Copyright (c) 2014 team5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *UsernameField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UILabel *ErrorLabel;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIView *RegisterView;
@property (weak, nonatomic) IBOutlet UIView *LoginView;

@property (weak, nonatomic) IBOutlet UITextField *Username2;
@property (weak, nonatomic) IBOutlet UITextField *Password2;
@property (weak, nonatomic) IBOutlet UITextField *PasswordConfirm;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@end
