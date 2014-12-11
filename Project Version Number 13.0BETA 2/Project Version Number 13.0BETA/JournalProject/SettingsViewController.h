//
//  SettingsViewController.h
//  JournalProject
//
//  Created by ubicomp5 on 12/9/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
