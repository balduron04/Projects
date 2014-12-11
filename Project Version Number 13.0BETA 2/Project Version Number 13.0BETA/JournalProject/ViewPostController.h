//
//  ViewPostController.h
//  JournalProject
//
//  Created by Jessica Pittman on 11/12/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@import MediaPlayer;

@interface ViewPostController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *PostView;
@property (weak, nonatomic) IBOutlet UILabel *CommentLabel;
@property (weak, nonatomic) IBOutlet UITableView *CommentTable;
@property (weak, nonatomic) IBOutlet UITextView *CommentView;
@property (weak, nonatomic) IBOutlet UILabel *LeaveCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveCommentButton;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UILabel *LikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *PosterLabel;
- (IBAction)LikePost:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *Likebutton;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *postButtonImage;
@property PFObject* entry;
- (IBAction)mapButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *commentSectionView;
@property (weak, nonatomic) IBOutlet UIButton *FollowButton;
@property (weak, nonatomic) IBOutlet UIButton *DeleteButton;

@end
