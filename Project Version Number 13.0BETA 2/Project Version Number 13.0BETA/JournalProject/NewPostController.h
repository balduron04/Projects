//
//  PostViewController.h
//  JournalProject
//
//  Created by ubicomp11 on 11/11/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NewPostController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    
    
    UIImagePickerController *picker;
    
    UIImage *image;
    
    IBOutlet UIImageView *imageView;
    
}
@property (weak, nonatomic) IBOutlet UITextField *TitleField;
@property (weak, nonatomic) IBOutlet UITextView *PostView;
@property (weak, nonatomic) IBOutlet UITextField *TagsField;
@property (weak, nonatomic) IBOutlet UIImageView *Image1;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *ErrorLabel;

@end
