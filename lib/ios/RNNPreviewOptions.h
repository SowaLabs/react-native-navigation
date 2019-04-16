#import "RNNOptions.h"

@interface RNNPreviewOptions : RNNOptions

@property (nonatomic, strong) Number* reactTag;
@property (nonatomic, strong) Number* width;
@property (nonatomic, strong) Number* height;
@property (nonatomic, strong) RNNBool* commit;
@property (nonatomic, strong) NSArray* actions;

@end
