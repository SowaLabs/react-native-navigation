#import <Foundation/Foundation.h>
#import "RNNDouble.h"

@interface DoubleParser : NSObject

+ (RNNDouble *)parse:(NSDictionary *)json key:(NSString *)key;

@end
