//
//  PanelViewController.m
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/25/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "PanelViewController.h"

typedef NS_ENUM(NSUInteger, PanelGuide)
{
    PGPanelFullyShown = 0,
    PGPanelShownSecondStage,
    PGPanelShownFirstStage,
    PGPanelHidden
};

@interface PanelViewController ()
{
    CGFloat newOrigin;
    
    PanelGuide snapGuide;
    
    NSInteger leftEdge;
    NSInteger rightEdge;
    
    NSArray *portraitGuides;
    NSArray *landscapeGuides;
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
    
    self.contentPanel.layer.cornerRadius = 5;
    self.panelButton.layer.cornerRadius = 5;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    [self calculateGuides];
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
    
    NSLog(@"%@ \n %@", portraitGuides, landscapeGuides);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

- (void)determineEdges
{
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        leftEdge = [portraitGuides[PGPanelFullyShown] floatValue];
        rightEdge = [portraitGuides[PGPanelHidden] floatValue];
    }
    else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        leftEdge = [landscapeGuides[PGPanelFullyShown] floatValue];
        rightEdge = [landscapeGuides[PGPanelHidden] floatValue];
    }
}


- (void)snapToGuide:(PanelGuide)guide
{
    [self.delegate panelDidSnapToGuide:guide];
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

    }
}

@end
