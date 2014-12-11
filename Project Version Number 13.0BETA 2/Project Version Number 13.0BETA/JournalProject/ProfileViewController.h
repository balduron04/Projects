//
//  ProfileViewController.h
//  JournalProject
//
//  Created by ubicomp9 on 12/8/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UITableView *Following;
@property (weak, nonatomic) IBOutlet UITableView *Activity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
