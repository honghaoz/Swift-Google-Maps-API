#import <UIKit/UIKit.h>

@class DemoAppDelegate;

@interface MasterViewController : UITableViewController <
    UISplitViewControllerDelegate,
    UITableViewDataSource,
    UITableViewDelegate>

@property(nonatomic, assign) DemoAppDelegate *appDelegate;

@end
