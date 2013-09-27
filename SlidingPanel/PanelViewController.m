//
//  PanelViewController.m
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/25/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "PanelViewController.h"
#import "SlidingPanelViewController.h"

@interface PanelViewController ()
{
    CGFloat newOrigin;
    
    PanelGuide closestGuide;
    
    NSInteger leftEdge;
    NSInteger rightEdge;
    
    NSMutableArray *portraitGuides;
    NSMutableArray *landscapeGuides;
    
    NSArray *currentOrientationGuides;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelWidth;

@end

@implementation PanelViewController

CGFloat const kEndSlideOffset = 40;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [self.panelButton addGestureRecognizer:panRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanelLeft:)];
    swipeLeftRecognizer.direction = (UISwipeGestureRecognizerDirectionLeft);
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanelRight:)];
    swipeRightRecognizer.direction = (UISwipeGestureRecognizerDirectionRight);
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    self.contentPanelView.layer.cornerRadius = 5;
    self.panelButton.layer.cornerRadius = 20;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.delegate = (SlidingPanelViewController *)self.parentViewController;
   
    [self calculateGuides];
    closestGuide = PGPanelHidden;
    [self snapToGuide:closestGuide];
}

- (void)setPanelOffset:(CGFloat)panelOffset
{
    _panelOffset = panelOffset;
    [self calculateGuides];
}

- (void)calculateGuides
{
    [self applyOffsetOnPanel];
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        portraitGuides = [NSMutableArray arrayWithArray: @[@(self.parentViewController.view.frame.size.width - self.view.frame.size.width),
                           @(self.parentViewController.view.frame.size.width - 2 * self.view.frame.size.width / 3),
                           @(self.parentViewController.view.frame.size.width - self.view.frame.size.width / 3),
                           @(self.parentViewController.view.frame.size.width - (self.buttonSpace.constant))]];
        
        landscapeGuides = [NSMutableArray arrayWithArray: @[@(self.parentViewController.view.frame.size.height - self.view.frame.size.height),
                            @(self.parentViewController.view.frame.size.height - 2 * self.view.frame.size.height / 3),
                            @(self.parentViewController.view.frame.size.height - self.view.frame.size.height / 3),
                            @(self.parentViewController.view.frame.size.height - (self.buttonSpace.constant))]];
    }
    else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        portraitGuides = [NSMutableArray arrayWithArray: @[@(self.parentViewController.view.frame.size.width - self.view.frame.size.height),
                           @(self.parentViewController.view.frame.size.width - 2 * self.view.frame.size.height / 3),
                           @(self.parentViewController.view.frame.size.width - self.view.frame.size.height / 3),
                           @(self.parentViewController.view.frame.size.width - (self.buttonSpace.constant))]];
        
        landscapeGuides = [NSMutableArray arrayWithArray: @[@(self.parentViewController.view.frame.size.height - self.view.frame.size.width),
                            @(self.parentViewController.view.frame.size.height - 2 * self.view.frame.size.width / 3),
                            @(self.parentViewController.view.frame.size.height - self.view.frame.size.width / 3),
                            @(self.parentViewController.view.frame.size.height - (self.buttonSpace.constant))]];
    }
    
    NSLog(@"%@ %@", portraitGuides, landscapeGuides);
    [self applyOffsetOnGuides];
    NSLog(@"%@ %@", portraitGuides, landscapeGuides);

    [self setCurrentOrientationGuides];
}

- (void)applyOffsetOnPanel
{
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        self.panelWidth.constant = self.parentViewController.view.frame.size.width - self.panelButton.frame.size.width - self.panelOffset - 16;
    }
    else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        self.panelWidth.constant = self.parentViewController.view.frame.size.height - self.panelButton.frame.size.width - self.panelOffset - 16;
    }
}

- (void)applyOffsetOnGuides
{
    portraitGuides[PGPanelFullyShown] = @([portraitGuides[PGPanelFullyShown] floatValue] + self.panelOffset);
    portraitGuides[PGPanelShownSecondStage] = @([portraitGuides[PGPanelShownSecondStage] floatValue] +  2 * self.panelOffset / 3);
    portraitGuides[PGPanelShownFirstStage] = @([portraitGuides[PGPanelShownFirstStage] floatValue] + self.panelOffset / 3);

    landscapeGuides[PGPanelFullyShown] = @([landscapeGuides[PGPanelFullyShown] floatValue] + self.panelOffset);
    landscapeGuides[PGPanelShownSecondStage] = @([landscapeGuides[PGPanelShownSecondStage] floatValue] +  2 * self.panelOffset / 3);
    landscapeGuides[PGPanelShownFirstStage] = @([landscapeGuides[PGPanelShownFirstStage] floatValue] + self.panelOffset / 3);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setCurrentOrientationGuides];
    
    [self applyOffsetOnPanel];
    
    [self snapToGuide:closestGuide];
}

- (void)setCurrentOrientationGuides
{
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        currentOrientationGuides = portraitGuides;
    }
    else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        currentOrientationGuides = landscapeGuides;
    }
}

- (void)determineEdges
{
    leftEdge = [currentOrientationGuides[PGPanelFullyShown] floatValue] - kEndSlideOffset;
    rightEdge = [currentOrientationGuides[PGPanelHidden] floatValue];
}

- (void)getClosestGuideToLocation:(CGFloat)location
{
    NSArray *guidesForOrientation;
    
    guidesForOrientation = currentOrientationGuides;
    
    CGFloat minimalDistance = abs([guidesForOrientation[0] floatValue] - location);
    closestGuide = 0;
    
    for (NSInteger i = 1; i < [guidesForOrientation count]; i++)
    {
        if (minimalDistance > abs([guidesForOrientation[i] floatValue] - location))
        {
            minimalDistance = abs([guidesForOrientation[i] floatValue] - location);
            closestGuide = i;
        }
    }
}

- (void)snapToGuide:(PanelGuide)guide
{
    [self.delegate panelDidSnapToGuide:guide location:[currentOrientationGuides[guide] floatValue]];
}

- (void)movePanel:(UIPanGestureRecognizer *)panRecognizer
{
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self determineEdges];
    }
    
    newOrigin = [panRecognizer locationInView:self.parentViewController.view].x;
    
    if (newOrigin >= leftEdge && newOrigin <= rightEdge)
    {
        [self.delegate panelDidMoveTo:newOrigin];
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self getClosestGuideToLocation:newOrigin];
        [self snapToGuide:closestGuide];
    }
}

- (void)swipePanelLeft:(UISwipeGestureRecognizer *)swipeRecognizer
{
    if (closestGuide != PGPanelFullyShown)
    {
        closestGuide--;
        [self.delegate panelDidSnapToGuide:closestGuide location:[currentOrientationGuides[closestGuide] floatValue]];
    }
}

- (void)swipePanelRight:(UISwipeGestureRecognizer *)swipeRecognizer
{
    if (closestGuide != PGPanelHidden)
    {
        closestGuide++;
        [self.delegate panelDidSnapToGuide:closestGuide location:[currentOrientationGuides[closestGuide] floatValue]];
    }
}

@end
