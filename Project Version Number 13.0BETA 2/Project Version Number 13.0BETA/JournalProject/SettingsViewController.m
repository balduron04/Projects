//
//  SettingsViewController.m
//  JournalProject
//
//  Created by ubicomp5 on 12/9/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize TableView,sidebarButton;

NSMutableArray* wordsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    TableView.delegate = self;
    TableView.dataSource = self;
    TableView.scrollEnabled = false;
    TableView.separatorColor = [UIColor clearColor];
    wordsArray = [[NSMutableArray alloc] init];
    [self loadWords];
    // Do any additional setup after loading the view.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    [self.navigationItem setLeftBarButtonItem:sidebarButton];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:72.0/255.0 green:145.0/255.0 blue:116.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    //   [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadWords
{
    [self reloadTable];
}

-(void) reloadTable
{
    [TableView reloadData];
 /*   CGFloat fixedWidth = TableView.frame.size.width;
    CGSize newSize = [TableView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = TableView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height + 70);
    TableView.frame = newFrame;*/
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)NewWordUp:(id)sender {
    [self reloadTable];
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return wordsArray.count+1;
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row != wordsArray.count - 1 && wordsArray.count != 0)
    {
        UITextField* text;
        text = (UITextField*) [cell viewWithTag:1];
        text.text = @"TEST";
    }
    return cell;
}

@end

