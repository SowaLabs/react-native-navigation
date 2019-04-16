#import "RNNOptions.h"
#import "BottomTabsAttachMode.h"

@interface RNNBottomTabsOptions : RNNOptions

@property (nonatomic, strong) RNNBool* visible;
@property (nonatomic, strong) IntNumber* currentTabIndex;
@property (nonatomic, strong) RNNBool* drawBehind;
@property (nonatomic, strong) RNNBool* animate;
@property (nonatomic, strong) Color* tabColor;
@property (nonatomic, strong) Color* selectedTabColor;
@property (nonatomic, strong) RNNBool* translucent;
@property (nonatomic, strong) RNNBool* hideShadow;
@property (nonatomic, strong) Color* backgroundColor;
@property (nonatomic, strong) Number* fontSize;

@property (nonatomic, strong) Text* testID;
@property (nonatomic, strong) Text* currentTabId;
@property (nonatomic, strong) Text* barStyle;
@property (nonatomic, strong) Text* fontFamily;
@property (nonatomic, strong) Text* titleDisplayMode;
@property (nonatomic, strong) BottomTabsAttachMode* tabsAttachMode;

- (BOOL)shouldDrawBehind;

@end
