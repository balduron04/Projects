//
//  SidebarViewController.h
//  AnonJournal
//
//  Created by Esraa Bataineh on 10/27/14.
//  Copyright (c) 2014 Esraa Bataineh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *navigationTable;


@end
