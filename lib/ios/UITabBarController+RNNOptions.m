#import "RNNBottomTabsController.h"
#import "UITabBar+utils.h"
#import "UITabBarController+RNNOptions.h"

@implementation UITabBarController (RNNOptions)

- (void)setCurrentTabIndex:(NSUInteger)currentTabIndex {
    [self setSelectedIndex:currentTabIndex];
}

- (void)setCurrentTabID:(NSString *)currentTabId {
    [(RNNBottomTabsController *)self setSelectedIndexByComponentID:currentTabId];
}

- (void)setTabBarTestID:(NSString *)testID {
    self.tabBar.accessibilityIdentifier = testID;
}

- (void)setTabBarStyle:(UIBarStyle)barStyle {
    self.tabBar.barStyle = barStyle;
}

- (void)setTabBarTranslucent:(BOOL)translucent {
    self.tabBar.translucent = translucent;
}

- (void)setTabBarHideShadow:(BOOL)hideShadow {
    if (hideShadow) {
        // clips UITabBar border and any shadow
        self.tabBar.clipsToBounds = true;
    } else {
        // allow shadow to appear
        self.tabBar.clipsToBounds = false;
        
        // add shadow above UITabBar
        self.tabBar.layer.shadowColor = UIColor.blackColor.CGColor;
        self.tabBar.layer.shadowOpacity = 0.08;
        self.tabBar.layer.shadowOffset = CGSizeZero;
        self.tabBar.layer.shadowRadius = 14; // 14 px specified in Figma
        
        // remove UITabBar border (https://stackoverflow.com/a/58063737/13210194)
        if (@available(iOS 13.0, *)) {
            // use UITabBarAppearance on iOS 13 (https://emptytheory.com/2019/12/31/using-uitabbarappearance-for-tab-bar-changes-in-ios-13/)
            for (UIViewController* childViewController in self.childViewControllers) {
                // `setTabBarBackgroundColor:` in `BottomTabsAppearancePresenter.m` resets apperance on each individual UITabBarItem,
                // therefore we need to remove border on each individual item, otherwise it would be overriden (items take precedence).
                UITabBarAppearance* appearance =  childViewController.tabBarItem.standardAppearance.copy;
                appearance.backgroundImage = [UIImage new];
                appearance.shadowImage = [UIImage new];
                appearance.shadowColor = [UIColor clearColor];
                childViewController.tabBarItem.standardAppearance = appearance;
            }
        } else {
            self.tabBar.shadowImage = [UIImage new];
            self.tabBar.backgroundImage = [UIImage new];
        }
    }
}
    
    - (void)centerTabItems {
        [self.tabBar centerTabItems];
    }
    
    - (void)showTabBar:(BOOL)animated {
        static const CGFloat animationDuration = 0.15;
        const CGRect tabBarVisibleFrame = CGRectMake(
                                                     self.tabBar.frame.origin.x, self.view.frame.size.height - self.tabBar.frame.size.height,
                                                     self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        self.tabBar.hidden = NO;
        if (!animated) {
            self.tabBar.frame = tabBarVisibleFrame;
        } else {
            [UIView animateWithDuration:animationDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^() {
                self.tabBar.frame = tabBarVisibleFrame;
            }
                             completion:^(BOOL finished){
            }];
        }
    }
    
    - (void)hideTabBar:(BOOL)animated {
        static const CGFloat animationDuration = 0.15;
        const CGRect tabBarHiddenFrame =
        CGRectMake(self.tabBar.frame.origin.x, self.view.frame.size.height,
                   self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        
        if (!animated) {
            self.tabBar.frame = tabBarHiddenFrame;
            self.tabBar.hidden = YES;
        } else {
            [UIView animateWithDuration:animationDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^() {
                self.tabBar.frame = tabBarHiddenFrame;
            }
                             completion:^(BOOL finished) {
                self.tabBar.hidden = YES;
            }];
        }
    }
    
    - (void)forEachTab:(void (^)(UIView *, UIViewController *tabViewController,
                                 int tabIndex))performOnTab {
        int tabIndex = 0;
        for (UIView *tab in self.tabBar.subviews) {
            if ([NSStringFromClass([tab class]) isEqualToString:@"UITabBarButton"]) {
                performOnTab(tab, [self childViewControllers][(NSUInteger)tabIndex], tabIndex);
                tabIndex;
            }
        }
    }

@end
