#import <UIKit/UIKit.h>
#import "RNNEventEmitter.h"
#import "RNNBottomTabsPresenter.h"
#import "UIViewController+LayoutProtocol.h"
#import "BottomTabsBaseAttacher.h"
#import "BottomTabPresenter.h"
#import "RNNDotIndicatorPresenter.h"
#import "RNNCustomTabBar.h"

@interface RNNBottomTabsController : UITabBarController <RNNLayoutProtocol, UITabBarControllerDelegate, RNNCustomTabBarDelegate>

- (instancetype)initWithLayoutInfo:(RNNLayoutInfo *)layoutInfo
                           creator:(id<RNNComponentViewCreator>)creator
                           options:(RNNNavigationOptions *)options
                    defaultOptions:(RNNNavigationOptions *)defaultOptions
                         presenter:(RNNBasePresenter *)presenter
                bottomTabPresenter:(BottomTabPresenter *)bottomTabPresenter
                dotIndicatorPresenter:(RNNDotIndicatorPresenter *)dotIndicatorPresenter
                      eventEmitter:(RNNEventEmitter *)eventEmitter
              childViewControllers:(NSArray *)childViewControllers
                bottomTabsAttacher:(BottomTabsBaseAttacher *)bottomTabsAttacher;

- (void)setSelectedIndexByComponentID:(NSString *)componentID;

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated;

- (void)restoreTabBarVisibility:(BOOL)visible;

// BISON
- (void)setTabBarShapeFillColor:(UIColor *)color;
- (void)setTabBarMiddleButtonBackgroundColor:(UIColor *)color;
- (void)setTabBarMiddleButtonImage:(UIImage *)image;

@property (nonatomic, strong) NSArray* pendingChildViewControllers;

@end
