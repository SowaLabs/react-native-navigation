#import "Param.h"

@interface RNNBool : Param

- (instancetype)initWithBOOL:(BOOL)boolValue;

- (BOOL)get;

- (NSNumber *)getValue;

- (BOOL)getWithDefaultValue:(BOOL)value;

- (bool) isFalse;

@end
