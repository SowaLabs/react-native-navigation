#import "RNNOptions.h"

@interface RNNSearchBarOptions : RNNOptions

@property(nonatomic, strong) RNNBool *visible;
@property(nonatomic, strong) RNNBool *focus;
@property(nonatomic, strong) RNNBool *hideOnScroll;
@property(nonatomic, strong) RNNBool *hideTopBarOnFocus;
@property(nonatomic, strong) RNNBool *obscuresBackgroundDuringPresentation;
@property(nonatomic, strong) Color *backgroundColor;
@property(nonatomic, strong) Color *tintColor;
@property(nonatomic, strong) Text *placeholder;
@property(nonatomic, strong) Text *cancelText;

@end
