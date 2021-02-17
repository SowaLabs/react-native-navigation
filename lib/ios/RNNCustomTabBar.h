//
//  RNNCustomTabBar.h
//  ReactNativeNavigation
//
//  Created by Andrej Česen on 11/02/2021.
//

#import <UIKit/UIKit.h>

@protocol RNNCustomTabBarDelegate <NSObject>

-(void)tabBarMiddleButtonWasPressed;

@end


@interface RNNCustomTabBar : UITabBar

@property (nonatomic, strong) UIColor* shapeSublayerFillColor;
@property (nonatomic, strong) UIColor* middleButtonBackgroundColor;
@property (nonatomic, strong) UIImage* middleButtonImage;

@property (nonatomic, weak) id <RNNCustomTabBarDelegate> customDelegate;

@end
