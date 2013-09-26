//
//  ViewController.m
//  SlidingPanel
//
//  Created by Ivelin Ivanov on 9/25/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ParentViewController.h"
#import "PanelViewController.h"

@interface ParentViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) PanelViewController *panelViewController;

@end

@implementation ParentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - PanelViewController Delegate Methods

- (void)panelDidMoveTo:(CGFloat)xCoordinate
{
    self.panelLeftConstraint.constant = xCoordinate;
}

- (void)panelDidSnapToLocation:(CGFloat)location
{
    [UIView animateWithDuration:0.5f animations:^{
        self.panelLeftConstraint.constant = location;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"panelSegue"]) {
        self.panelViewController = (PanelViewController *)segue.destinationViewController;
        self.panelViewController.delegate = self;
    }
}


@end
