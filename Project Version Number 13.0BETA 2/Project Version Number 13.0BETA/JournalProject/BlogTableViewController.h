//

#import <UIKit/UIKit.h>

@interface BlogTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *postArray;

- (void)addPostButtonHandler:(id)sender;
- (void)refreshButtonHandler:(id)sender;
- (IBAction)Refresh:(id)sender;
- (IBAction)Logout:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property int selector;


@end
