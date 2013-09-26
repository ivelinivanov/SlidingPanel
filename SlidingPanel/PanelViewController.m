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
    
    NSArray *portraitGuides;
    NSArray *landscapeGuides;
    
    NSArray *currentOrientationGuides;
}

@end

@implementation PanelViewController


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
    
    self.buttonWidth.constant = 40;
    self.buttonHeight.constant = 40;
    
    self.contentPanel.layer.cornerRadius = 5;
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

- (void)calculateGuides
{
    portraitGuides = @[@(self.parentViewController.view.frame.size.width - self.view.frame.size.width),
                       @(self.parentViewController.view.frame.size.width - 2 * self.view.frame.size.width / 3),
                       @(self.parentViewController.view.frame.size.width - self.view.frame.size.width / 3),
                       @(self.parentViewController.view.frame.size.width - (self.view.frame.size.width - self.contentPanel.frame.size.width))];
    
    landscapeGuides = @[@(self.parentViewController.view.frame.size.height - self.view.frame.size.width),
                        @(self.parentViewController.view.frame.size.height - 2 * self.view.frame.size.width / 3),
                        @(self.parentViewController.view.frame.size.height - self.view.frame.size.width / 3),
                        @(self.parentViewController.view.frame.size.height - (self.view.frame.size.width - self.contentPanel.frame.size.width))];
    
    [self setCurrentOrientationGuides];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setCurrentOrientationGuides];
    
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
    leftEdge = [currentOrientationGuides[PGPanelFullyShown] floatValue];
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

@end
