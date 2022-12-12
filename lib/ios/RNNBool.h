#import "Param.h"

@interface RNNBool : Param

- (instancetype)initWithBOOL:(BOOL)boolValue;

- (BOOL)get;

- (NSNumber *)getValue;

- (BOOL)withDefault:(BOOL)value;

- (bool)isFalse;

+ (instancetype)withValue:(BOOL)value;

@end
