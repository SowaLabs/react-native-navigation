#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RNNComponentPresenter.h"
#import "UIViewController+RNNOptions.h"
#import "RNNComponentViewController.h"
#import "UIViewController+LayoutProtocol.h"
#import "RNNTitleViewHelper.h"

@interface RNNComponentPresenterTest : XCTestCase

@property (nonatomic, strong) RNNComponentPresenter *uut;
@property (nonatomic, strong) RNNNavigationOptions *options;
@property (nonatomic, strong) UIViewController *boundViewController;
@property (nonatomic, strong) RNNReactComponentRegistry *componentRegistry;

@end

@implementation RNNComponentPresenterTest

- (void)setUp {
    [super setUp];
	self.componentRegistry = [OCMockObject partialMockForObject:[RNNReactComponentRegistry new]];
	self.uut = [[RNNComponentPresenter alloc] initWithComponentRegistry:self.componentRegistry defaultOptions:[[RNNNavigationOptions alloc] initEmptyOptions]];
	self.boundViewController = [OCMockObject partialMockForObject:[RNNComponentViewController new]];
	[self.uut bindViewController:self.boundViewController];
	self.options = [[RNNNavigationOptions alloc] initEmptyOptions];
}

- (void)testApplyOptions_backgroundImageDefaultNilShouldNotAddSubview {
	[self.uut applyOptions:self.options];
	XCTAssertTrue((self.boundViewController.view.subviews.count) == 0);
}

- (void)testApplyOptions_topBarPrefersLargeTitleDefaultFalse {
	[self.uut applyOptions:self.options];
	
	XCTAssertTrue(self.boundViewController.navigationItem.largeTitleDisplayMode == UINavigationItemLargeTitleDisplayModeNever);
}

- (void)testApplyOptions_layoutBackgroundColorDefaultWhiteColor {
	[self.uut applyOptions:self.options];
	XCTAssertNil(self.boundViewController.view.backgroundColor);
}

- (void)testApplyOptions_statusBarBlurDefaultFalse {
	[self.uut applyOptions:self.options];
	XCTAssertNil([self.boundViewController.view viewWithTag:BLUR_STATUS_TAG]);
}

- (void)testApplyOptions_statusBarStyleDefaultStyle {
	[self.uut applyOptions:self.options];
	XCTAssertTrue([self.boundViewController preferredStatusBarStyle] == UIStatusBarStyleDefault);
}

- (void)testApplyOptions_backButtonVisibleDefaultTrue {
	[self.uut applyOptions:self.options];
	XCTAssertFalse(self.boundViewController.navigationItem.hidesBackButton);
}

- (void)testApplyOptions_drawBehindTabBarTrueWhenVisibleFalse {
	self.options.bottomTabs.visible = [[RNNBool alloc] initWithValue:@(0)];
	[[(id) self.boundViewController expect] setDrawBehindTabBar:YES];
	[self.uut applyOptionsOnInit:self.options];
	[(id)self.boundViewController verify];
}

- (void)testApplyOptions_setOverlayTouchOutsideIfHasValue {
    self.options.overlay.interceptTouchOutside = [[RNNBool alloc] initWithBOOL:YES];
    [(UIViewController *) [(id) self.boundViewController expect] setInterceptTouchOutside:YES];
    [self.uut applyOptions:self.options];
    [(id)self.boundViewController verify];
}

- (void)testBindViewControllerShouldCreateNavigationButtonsCreator {
	RNNComponentPresenter* presenter = [[RNNComponentPresenter alloc] init];
	[presenter bindViewController:self.boundViewController];
	XCTAssertNotNil(presenter.navigationButtons);
}

-(void)testApplyOptionsOnInit_TopBarDrawUnder_true {
    self.options.topBar.drawBehind = [[RNNBool alloc] initWithValue:@(1)];

	[[(id) self.boundViewController expect] setDrawBehindTopBar:YES];
    [self.uut applyOptionsOnInit:self.options];
    [(id)self.boundViewController verify];
}

-(void)testApplyOptionsOnInit_TopBarDrawUnder_false {
    self.options.topBar.drawBehind = [[RNNBool alloc] initWithValue:@(0)];

	[[(id) self.boundViewController expect] setDrawBehindTopBar:NO];
    [self.uut applyOptionsOnInit:self.options];
    [(id)self.boundViewController verify];
}

-(void)testApplyOptionsOnInit_BottomTabsDrawUnder_true {
    self.options.bottomTabs.drawBehind = [[RNNBool alloc] initWithValue:@(1)];

	[[(id) self.boundViewController expect] setDrawBehindTabBar:YES];
    [self.uut applyOptionsOnInit:self.options];
    [(id)self.boundViewController verify];
}

-(void)testApplyOptionsOnInit_BottomTabsDrawUnder_false {
    self.options.bottomTabs.drawBehind = [[RNNBool alloc] initWithValue:@(0)];

	[[(id) self.boundViewController expect] setDrawBehindTabBar:NO];
    [self.uut applyOptionsOnInit:self.options];
    [(id)self.boundViewController verify];
}

- (void)testReactViewShouldBeReleasedOnDealloc {
	RNNComponentViewController* bindViewController = [RNNComponentViewController new];
	bindViewController.layoutInfo = [self createLayoutInfoWithComponentId:@"componentId"];
	[self.uut bindViewController:bindViewController];
	
	self.options.topBar.title.component = [[RNNComponentOptions alloc] initWithDict:@{@"name": @"componentName"}];
	
	[[(id)self.componentRegistry expect] clearComponentsForParentId:self.uut.boundComponentId];
	self.uut = nil;
	[(id)self.componentRegistry verify];
}

- (void)testBindViewControllerShouldSetBoundComponentId {
	RNNComponentViewController* bindViewController = [RNNComponentViewController new];
	RNNLayoutInfo* layoutInfo = [[RNNLayoutInfo alloc] init];
	layoutInfo.componentId = @"componentId";
	bindViewController.layoutInfo = layoutInfo;

	[self.uut bindViewController:bindViewController];
	XCTAssertEqual(self.uut.boundComponentId, @"componentId");
}

- (void)testRenderComponentsCreateReactViewWithBoundComponentId {
	RNNComponentViewController* boundViewController = [RNNComponentViewController new];
	RNNLayoutInfo* layoutInfo = [self createLayoutInfoWithComponentId:@"componentId"];
	boundViewController.layoutInfo = layoutInfo;
	boundViewController.defaultOptions = [[RNNNavigationOptions alloc] initEmptyOptions];
	[self.uut bindViewController:boundViewController];
	
	self.options.topBar.title.component = [[RNNComponentOptions alloc] initWithDict:@{@"name": @"titleComponent", @"componentId": @"id"}];
	
	[[(id)self.componentRegistry expect] createComponentIfNotExists:[OCMArg checkWithBlock:^BOOL(RNNComponentOptions* options) {
		return [options.name.get isEqual:@"titleComponent"] &&
		[options.componentId.get isEqual:@"id"];
	}] parentComponentId:self.uut.boundComponentId componentType:RNNComponentTypeTopBarTitle reactViewReadyBlock:[OCMArg any]];
	[self.uut renderComponents:self.options perform:nil];
	[(id)self.componentRegistry verify];
	
	
	XCTAssertEqual(self.uut.boundComponentId, @"componentId");
}

- (void)testRenderComponentsCreateReactViewFromDefaultOptions {
	RNNComponentViewController* boundViewController = [RNNComponentViewController new];
	boundViewController.layoutInfo = [self createLayoutInfoWithComponentId:@"componentId"];
	self.uut.defaultOptions = [[RNNNavigationOptions alloc] initEmptyOptions];
	[self.uut bindViewController:boundViewController];
	
	self.uut.defaultOptions.topBar.title.component = [[RNNComponentOptions alloc] initWithDict:@{@"name": @"titleComponent", @"componentId": @"id"}];
	
	[[(id)self.componentRegistry expect] createComponentIfNotExists:[OCMArg checkWithBlock:^BOOL(RNNComponentOptions* options) {
		return [options.name.get isEqual:@"titleComponent"] &&
		[options.componentId.get isEqual:@"id"];
	}] parentComponentId:self.uut.boundComponentId componentType:RNNComponentTypeTopBarTitle reactViewReadyBlock:[OCMArg any]];
	[self.uut renderComponents:self.options perform:nil];
	[(id)self.componentRegistry verify];
	
	
	XCTAssertEqual(self.uut.boundComponentId, @"componentId");
}

- (void)testRemoveTitleComponentIfNeeded_componentIsRemovedIfTitleTextIsDefined {
	id mockTitle = [OCMockObject niceMockForClass:[RNNReactTitleView class]];
    OCMStub([self.componentRegistry createComponentIfNotExists:[OCMArg any] parentComponentId:[OCMArg any] componentType:RNNComponentTypeTopBarTitle reactViewReadyBlock:nil]).andReturn(mockTitle);

	RNNComponentOptions* component = [RNNComponentOptions new];
	component.name = [[Text alloc] initWithValue:@"componentName"];
	component.componentId = [[Text alloc] initWithValue:@"someId"];
	_options.topBar.title.component = component;

	[self.uut mergeOptions:_options resolvedOptions:[[RNNNavigationOptions alloc] initEmptyOptions]];
    XCTAssertNotNil(self.boundViewController.navigationItem.titleView);
	XCTAssertEqual(self.boundViewController.navigationItem.titleView, mockTitle);

	[[mockTitle expect] removeFromSuperview];
    _options = [[RNNNavigationOptions alloc] initEmptyOptions];
    _options.topBar.title.text = [[Text alloc] initWithValue:@""];
	[self.uut mergeOptions:_options resolvedOptions:[[RNNNavigationOptions alloc] initEmptyOptions]];
    XCTAssertNotEqual(self.boundViewController.navigationItem.titleView, mockTitle);
	[mockTitle verify];
}

- (void)testRemoveTitleComponentIfNeeded_componentIsNotRemovedIfMergeOptionsIsCalledWithoutTitleText {
    id mockTitle = [OCMockObject niceMockForClass:[RNNReactTitleView class]];
    OCMStub([self.componentRegistry createComponentIfNotExists:[OCMArg any] parentComponentId:[OCMArg any]  componentType:RNNComponentTypeTopBarTitle reactViewReadyBlock:nil]).andReturn(mockTitle);

    RNNComponentOptions* component = [RNNComponentOptions new];
    component.name = [[Text alloc] initWithValue:@"componentName"];
    component.componentId = [[Text alloc] initWithValue:@"someId"];
    _options.topBar.title.component = component;

    [self.uut mergeOptions:_options resolvedOptions:[[RNNNavigationOptions alloc] initEmptyOptions]];
    XCTAssertNotNil(self.boundViewController.navigationItem.titleView);
    XCTAssertEqual(self.boundViewController.navigationItem.titleView, mockTitle);


    _options = [[RNNNavigationOptions alloc] initEmptyOptions];
    _options.bottomTabs.visible = [[RNNBool alloc] initWithBOOL:NO];
    [self.uut mergeOptions:_options resolvedOptions:[[RNNNavigationOptions alloc] initEmptyOptions]];
    XCTAssertEqual(self.boundViewController.navigationItem.titleView, mockTitle);
}

- (RNNLayoutInfo *)createLayoutInfoWithComponentId:(NSString *)componentId {
	RNNLayoutInfo* layoutInfo = [[RNNLayoutInfo alloc] init];
	layoutInfo.componentId = componentId;
	return layoutInfo;
}

@end
