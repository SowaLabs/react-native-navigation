#import "RNNBottomTabsPresenter.h"
#import "RNNBottomTabsController.h"

@implementation RNNBottomTabsPresenter

- (void)applyBackgroundColor:(UIColor *)backgroundColor translucent:(BOOL)translucent {
//    [self setTabBarTranslucent:translucent];
//    [self setTabBarBackgroundColor:backgroundColor];
    
    // BISON: set transparent tab bar
    self.tabBar.barTintColor = UIColor.clearColor;
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBar.shadowImage = [[UIImage alloc] init];
    // apply fill color to custom tab bar's shape layer
    RNNBottomTabsController *tabBarController = (RNNBottomTabsController *)self.tabBarController;
    [tabBarController setTabBarShapeFillColor:backgroundColor];
}

- (void)setTabBarBackgroundColor:(UIColor *)backgroundColor {
    self.tabBar.barTintColor = backgroundColor;
}

- (void)setTabBarTranslucent:(BOOL)translucent {
    self.tabBar.translucent = translucent;
}

@end
