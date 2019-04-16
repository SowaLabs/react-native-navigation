#import "RNNOptions.h"
#import "RNNInsetsOptions.h"

@interface RNNButtonOptions : RNNOptions

@property (nonatomic, strong) Text* fontFamily;
@property (nonatomic, strong) Text* text;
@property (nonatomic, strong) Number* fontSize;
@property (nonatomic, strong) Color* color;
@property (nonatomic, strong) Color* disabledColor;
@property (nonatomic, strong) Image* icon;
@property (nonatomic, strong) RNNBool* enabled;
@property (nonatomic, strong) RNNInsetsOptions* iconInsets;
@property(nonatomic, strong) RNNBool *selectTabOnPress;

@end
