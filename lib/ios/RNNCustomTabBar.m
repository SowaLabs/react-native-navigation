//
//  RNNCustomTabBar.m
//  ReactNativeNavigation
//
//  Created by Andrej Česen on 11/02/2021.
//

#import "RNNCustomTabBar.h"

static CGFloat const middleButtonSize = 70;
static NSString *const RNNCustomTabBarShapeSublayerName = @"customUITabBarShapeLayer";

@interface RNNCustomTabBar ()
@property (nonatomic, strong) CAShapeLayer* shapeSublayer;
@property (nonatomic, strong) UIButton* middleButton;
@end

@implementation RNNCustomTabBar

- (UIButton *)createMiddleButton {
    CGRect frame = CGRectMake(0, 0, middleButtonSize, middleButtonSize);
    UIButton *middleButton = [[UIButton alloc] initWithFrame:frame];
    middleButton.center = CGPointMake(self.bounds.size.width / 2, 0);
    middleButton.layer.cornerRadius = middleButtonSize / 2;
    // confines the subview to the bounds of the view
    middleButton.clipsToBounds = YES;
    middleButton.backgroundColor = _middleButtonBackgroundColor;
    [middleButton addTarget:self
                     action:@selector(middleButtonTapAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    return middleButton;
}

// common setup code
- (void)setupView {
    _shapeSublayerFillColor = [UIColor blackColor];
    _middleButtonBackgroundColor = [UIColor blackColor];
    
    _middleButton = [self createMiddleButton];
    [self addSubview:_middleButton];
}

// init from xib or storyboard
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

// init from code
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (CGPathRef)createShapeLayerPathForRect:(CGRect)rect {
    CGFloat height = 37.0;
    CGFloat centerWidth = rect.size.width / 2;
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    // start at the top left
    [path moveToPoint:CGPointZero];
    
    // the beginning of the curve
    [path addLineToPoint:CGPointMake(centerWidth - height * 2, 0)];
    
    // first curve
    [path addCurveToPoint:CGPointMake(centerWidth, height)
            controlPoint1:CGPointMake(centerWidth - 30, 0)
            controlPoint2:CGPointMake(centerWidth - 35, height)];
    
    // second curve
    [path addCurveToPoint:CGPointMake((centerWidth + (height * 2)), 0)
            controlPoint1:CGPointMake(centerWidth + 35, height)
            controlPoint2:CGPointMake((centerWidth + 30), 0)];
    
    // close the rect
    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path addLineToPoint:CGPointMake(0, rect.size.height)];
    [path closePath];
    
    return path.CGPath;
}

- (CAShapeLayer *)createShapeLayerForBounds:(CGRect)bounds {
    // create tab bar's curved shape layer
    CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
    // set frame to detect tab bar's bounds change in subsequent `layoutSubviews` call
    // (not needed otherwise: https://stackoverflow.com/a/37548490/13210194)
    shapeLayer.frame = bounds;
    // name sublayer to be able to apply color to it later on
    shapeLayer.name = RNNCustomTabBarShapeSublayerName;
    shapeLayer.path = [self createShapeLayerPathForRect:bounds];
    
    // set colors
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 1.0;
    // `fillColor` is applied in `applyBackgroundColor:translucent:` method (subclasses of `BottomTabsBasePresenter`)
    
    // add shadow above the layer
    shapeLayer.shadowColor = UIColor.blackColor.CGColor;
    shapeLayer.shadowOpacity = 0.1;
    shapeLayer.shadowOffset = CGSizeZero;
    shapeLayer.shadowRadius = 6 / UIScreen.mainScreen.scale; // 6 px specified in Figma
    
    return shapeLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // recenter middle button upon screen rotation
    self.middleButton.center = CGPointMake(self.bounds.size.width / 2, 0);
    
    // create sublayer here, as bounds are guaranteed to be final in layoutSubviews (as opposed to init methods)
    if (!self.shapeSublayer || !CGRectEqualToRect(self.shapeSublayer.frame, self.bounds)) {
        CAShapeLayer *newSublayer = [self createShapeLayerForBounds:self.bounds];
        
        if (!self.shapeSublayer) {
            [self.layer insertSublayer:newSublayer atIndex:0];
        } else {
            // set color from a previous layer
            newSublayer.fillColor = self.shapeSublayer.fillColor;
            [self.layer replaceSublayer:self.shapeSublayer with:newSublayer];
        }
        
        self.shapeSublayer = newSublayer;
    }
}

// MARK:- override public setters

- (void)setMiddleButtonBackgroundColor:(UIColor *)middleButtonBackgroundColor {
    _middleButtonBackgroundColor = middleButtonBackgroundColor;
    self.middleButton.backgroundColor = middleButtonBackgroundColor;
}

- (void)setShapeSublayerFillColor:(UIColor *)shapeSublayerFillColor {
    _shapeSublayerFillColor = shapeSublayerFillColor;
    self.shapeSublayer.fillColor = shapeSublayerFillColor.CGColor;
}

// MARK:- middle button delegate

// TODO: change to delegate
- (void)middleButtonTapAction:(id)sender {
    NSLog(@"HERE");
}

/*
// BISON: We don't override drawRect: in an effort to be future-compatible (we configure each tabBarItem with configureWithTransparentBackground).
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
