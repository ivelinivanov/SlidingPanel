//
//  ViewController.m
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/25/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "SlidingPanelViewController.h"
#import "PanelViewController.h"

@interface SlidingPanelViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) PanelViewController *panelViewController;

@end

@implementation SlidingPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.panelViewController = [[PanelViewController alloc] initWithNibName:@"PanelViewController" bundle:[NSBundle mainBundle]];
    [self addChildViewController:self.panelViewController];
    [self.view addSubview:self.panelViewController.view];
}

#pragma mark - PanelViewController Delegate Methods

- (void)panelDidMoveTo:(CGFloat)xCoordinate
{
    CGRect newFrame = self.panelViewController.view.frame;
    newFrame.origin.x = xCoordinate;
    self.panelViewController.view.frame = newFrame;
}

- (void)panelDidSnapToGuide:(PanelGuide)guide location:(CGFloat)location
{
    [self.delegate panelWillSnapToGuide:guide];
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect newFrame = self.panelViewController.view.frame;
        newFrame.origin.x = location;
        self.panelViewController.view.frame = newFrame;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.delegate panelDidSnapToGuide:guide];
    }];
}


@end
