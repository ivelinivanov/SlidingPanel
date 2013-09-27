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
    
    self.panelViewController = [[PanelViewController alloc] initWithNibName:@"PanelViewController" bundle:[NSBundle mainBundle]];
    [self addChildViewController:self.panelViewController];
    [self.view addSubview:self.panelViewController.view];
    
    self.panelOffset = 100;
    
    self.contentViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle] ] instantiateViewControllerWithIdentifier:@"testController"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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

#pragma mark - Property Methods

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    contentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.panelViewController.contentPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.panelViewController addChildViewController:self.contentViewController];
    [self.panelViewController.contentPanelView insertSubview:self.contentViewController.view atIndex:5];

    NSDictionary* viewsDict = @{@"contentView" : self.contentViewController.view};
    [self.panelViewController.contentPanelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:viewsDict]];
    [self.panelViewController.contentPanelView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[contentView]|" options:0 metrics:nil views:viewsDict]];
}

- (void)setPanelOffset:(CGFloat)panelOffset
{
    self.panelViewController.panelOffset = panelOffset;
    _panelOffset = panelOffset;
}

@end
