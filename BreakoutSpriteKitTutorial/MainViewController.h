
#import "HostViewController.h"
#import "JoinViewController.h"
#import "GameViewController.h"

@interface MainViewController : UIViewController<HostViewControllerDelegate, JoinViewControllerDelegate, GameViewControllerDelegate>
- (IBAction)touchInfor:(id)sender;

@end
