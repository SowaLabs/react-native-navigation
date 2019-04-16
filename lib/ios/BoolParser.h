#import <Foundation/Foundation.h>
#import "RNNBool.h"

@interface BoolParser : NSObject

+ (RNNBool *)parse:(NSDictionary *)json key:(NSString *)key;

@end
