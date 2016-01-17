//
//  RootViewController.m
//  TicTacToeApp
//
//  Created by Julian Lee on 1/15/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UILabel *aDragDrop;
@property (weak, nonatomic) IBOutlet UILabel *gameTypeLabel;
@property int gridSize;
@property BOOL turnPlayerX;
@property BOOL modeOneIsOn;
@property (weak, nonatomic) IBOutlet UIView *turnTimerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property int movesTaken;
@property (weak, nonatomic) IBOutlet UILabel *countdownTimer;
@property int countdownTimeMemory;
@property NSTimer *myTimer;

@end

@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateVerticalGrid:3];
    self.aDragDrop.layer.borderColor = [UIColor grayColor].CGColor;
    self.aDragDrop.layer.borderWidth = 2.0f;
    self.aDragDrop.layer.cornerRadius = 5;
    self.turnPlayerX = true;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIButton *aButton in self.view.subviews) {
        if ([aButton.restorationIdentifier isEqualToString:@"Size-Button-0"]) {
            [self onSizeButtonPressed:aButton];
        }
        if ([aButton.restorationIdentifier isEqualToString:@"Player-Button-1"]) {
            [self onPlayerButtonPressed:aButton];
        }
    }
    
}



- (IBAction)onPlayerButtonPressed:(UIButton *)sender {
    
    if ([sender.restorationIdentifier isEqualToString:@"Player-Button-1"]) {
        if (!self.modeOneIsOn) {
            [self wipeAllMoves:sender];
            self.gameTypeLabel.text = [NSString stringWithFormat:@"Play Against AI"];
            self.modeOneIsOn = true;
            self.turnPlayerX = true;
            self.movesTaken = 0;
            [self killTimer];
        }
    } else {
        if (self.modeOneIsOn) {
            [self wipeAllMoves:sender];
            self.gameTypeLabel.text = [NSString stringWithFormat:@"Play with a friend"];
            self.modeOneIsOn = false;
            self.turnPlayerX = true;
            self.movesTaken = 0;
            [self killTimer];
        }
    }
    //stylistic purpose: remove color borders from unselected buttons on UIButtons panel
    for (UIButton *aButton in self.view.subviews) {
        for (UIView *aView in aButton.subviews) {
            if ([aView.restorationIdentifier isEqualToString:@"View-Frame-Two"]) {
                [aView removeFromSuperview];
            }
        }
        //stylisic purpose: remove background colors of unselected buttons on UIButtons panel
        if ([aButton.restorationIdentifier containsString:@"Player-Button"]) {
            if (aButton != sender) {
                aButton.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    [self frameHighlighterTwo:sender];
}


- (IBAction)onSizeButtonPressed:(UIButton *)sender {
    if (self.gridSize != sender.tag) {
        //stylicistic purpose: remove color borders from unselected buttons on grid buttons panel
        for (UIButton *aButton in self.view.subviews) {
            for (UIView *aView in aButton.subviews) {
                if ([aView.restorationIdentifier isEqualToString:@"View-Frame"]) {
                    [aView removeFromSuperview];
                }
            }
            //stylistic purpose: remove background colors of unselected buttons on grid buttons panel
            if ([aButton.restorationIdentifier containsString:@"Size-Button"]) {
                if (aButton != sender) {
                    aButton.backgroundColor = [UIColor whiteColor];
                }
            }
        }
        [self frameHighlighter:sender];
        //this removes current tic tac toe setup buttons
        for (UIButton *aButton in self.view.subviews) {
            if ([aButton.restorationIdentifier isEqualToString:@"Tic-Tac-Toe-Square"]) {
                [aButton removeFromSuperview];
            }
        }
        self.gridSize = (int)sender.tag;
        self.turnPlayerX = true;
        self.movesTaken = 0;
        [self generateVerticalGrid:sender.tag];
        [self killTimer];
    }
}







-(void) onTicTacToeButtonPressed: (UIButton *) aButton
{
    //FOR ONE PLAYER MODE AGAINST AI
    if (self.modeOneIsOn)
    {
        if ([aButton.titleLabel.text isEqualToString:@" "])
        {
            if (self.turnPlayerX)
            {
                [self killTimer];
                [aButton setTitle:@"X" forState:UIControlStateNormal];
                [aButton setTitleColor:[UIColor colorWithRed:0.008
                                                       green:0.529
                                                        blue:0.604
                                                       alpha:1]
                              forState:UIControlStateNormal];
                aButton.titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightSemibold];
                aButton.titleLabel.center = CGPointMake(aButton.center.x, aButton.center.y);
                self.turnPlayerX = false;
                self.movesTaken++;
                [self turnTimerSet];
            }
        }
    }
    //FOR TWO PLAYER MODE AGAINST A FRIEND
    else
    {
        if ([aButton.titleLabel.text isEqualToString:@" "])
        {
            if (self.turnPlayerX)
            {
                [self killTimer];
                [aButton setTitle:@"X" forState:UIControlStateNormal];
                [aButton setTitleColor:[UIColor colorWithRed:0.008
                                                       green:0.529
                                                        blue:0.604
                                                       alpha:1]
                              forState:UIControlStateNormal];
                aButton.titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightSemibold];
                aButton.titleLabel.center = CGPointMake(aButton.center.x, aButton.center.y);
                self.turnPlayerX = false;
                self.movesTaken++;
                [self runTimerNow];
            }
            else
            {
                [self killTimer];
                [aButton setTitle:@"O" forState:UIControlStateNormal];
                [aButton setTitleColor:[UIColor colorWithRed:0.008
                                                       green:0.529
                                                        blue:0.604
                                                       alpha:1]
                              forState:UIControlStateNormal];
                aButton.titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightSemibold];
                aButton.titleLabel.center = CGPointMake(aButton.center.x, aButton.center.y);
                self.turnPlayerX = true;
                self.movesTaken++;
                [self runTimerNow];
            }
        }
    }
}



//this will set up a horizontal line of buttons going top down
- (void) generateVerticalGrid:(NSUInteger)size {
    int sizeInt = (int)size;
    int preStartPoint = (((240/sizeInt)*((sizeInt-1)*0.5))+((sizeInt-1)*5));
    for (int i = 0; i < size; i++) {
        int yCoordinate = ((self.view.center.y - 10) + ((preStartPoint - ((i * (240/sizeInt)) + (i * 10)))));
        [self generateHorizontalGrid:size :yCoordinate :i];
    }
}

//this will create buttons on a horizontal line from left to right and tag them accordingly
- (void) generateHorizontalGrid:(NSUInteger)size :(int)yCoordinate :(int)tagCounter {
    int sizeInt = (int)size;
    int preStartPoint = -(((240/sizeInt)*((sizeInt-1)*0.5))+((sizeInt-1)*5));
    for (int i = 0; i < size; i++) {
        UIButton *button = [self generateButton:size];
        button.center = CGPointMake((self.view.center.x + ((preStartPoint + ((i * (240/sizeInt)) + (i * 10))))), yCoordinate);
        button.tag = (i + (tagCounter * sizeInt));
    }
}




//this will create a button of relevant grid size, all identified as Tic-Tac-Toe-Square
- (UIButton *) generateButton: (NSUInteger)size {
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton addTarget:self action:@selector(onTicTacToeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setTitle:[NSString stringWithFormat:@" "] forState:UIControlStateNormal];
    [aButton setBackgroundColor:[UIColor grayColor]];
    [aButton setFrame:CGRectMake(self.view.center.x, self.view.center.y, 240/size, 240/size)];
    aButton.center = CGPointMake(self.view.center.x, self.view.center.y);
    aButton.restorationIdentifier = [NSString stringWithFormat:@"Tic-Tac-Toe-Square"];
    aButton.layer.cornerRadius = 3;
    aButton.layer.backgroundColor = [UIColor colorWithRed:0.369
                                                    green:0.8
                                                     blue:0.859
                                                    alpha:1.0].CGColor;
    [self.view addSubview:aButton];
    return aButton;
}





- (void) frameHighlighter: (UIButton *)sender {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sender.frame.size.width, 7)];
    UIView *botlineView = [[UIView alloc] initWithFrame:CGRectMake(0, (sender.frame.size.height - 7), sender.frame.size.width, 7)];
    lineView.backgroundColor = [UIColor colorWithRed:0.024
                                               green:0.698
                                                blue:0.792
                                               alpha:1.0];
    botlineView.backgroundColor = [UIColor colorWithRed:0.024
                                               green:0.698
                                                blue:0.792
                                               alpha:1.0];
    lineView.restorationIdentifier = [NSString stringWithFormat:@"View-Frame"];
    botlineView.restorationIdentifier = [NSString stringWithFormat:@"View-Frame"];
    [sender addSubview:lineView];
    [sender addSubview:botlineView];
    sender.backgroundColor = [UIColor colorWithRed:0.369
                                             green:0.8
                                              blue:0.859
                                             alpha:1];
}




- (void) frameHighlighterTwo: (UIButton *)sender {
    UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sender.frame.size.width, 7)];
    UIView *botlineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, (sender.frame.size.height - 7), sender.frame.size.width, 7)];
    lineViewTwo.backgroundColor = [UIColor colorWithRed:0.024
                                               green:0.698
                                                blue:0.792
                                               alpha:1.0];
    botlineViewTwo.backgroundColor = [UIColor colorWithRed:0.024
                                                  green:0.698
                                                   blue:0.792
                                                  alpha:1.0];
    lineViewTwo.restorationIdentifier = [NSString stringWithFormat:@"View-Frame-Two"];
    botlineViewTwo.restorationIdentifier = [NSString stringWithFormat:@"View-Frame-Two"];
    [sender addSubview:lineViewTwo];
    [sender addSubview:botlineViewTwo];
    sender.backgroundColor = [UIColor colorWithRed:0.369
                                             green:0.8
                                              blue:0.859
                                             alpha:1];
}



-(void) wipeAllMoves: (UIButton *)aButton {
    for (UIButton *aButton in self.view.subviews) {
        if ([aButton.restorationIdentifier isEqualToString:@"Tic-Tac-Toe-Square"]) {
            [aButton setTitle:@" " forState:UIControlStateNormal];
            self.turnPlayerX = true;
        }
    }
}


-(void) turnTimerSet {
    if (self.movesTaken == (self.gridSize * self.gridSize)) {
        [self killTimer];
        NSLog(@"GAME ENDED");
        return;
    }
    if (self.modeOneIsOn && !self.turnPlayerX) {
        [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(compTurnPause) userInfo:nil repeats:false];
    }
}

-(void)compTurnPause {
    [self.activityIndicator startAnimating];
    int lengthOfTimer = arc4random_uniform(10);
    [NSTimer scheduledTimerWithTimeInterval:(0.5 + (lengthOfTimer/5)) target:self selector:@selector(dumbassAI) userInfo:nil repeats:false];
}


-(void)dumbassAI {
    int randomizer = arc4random_uniform((self.gridSize * self.gridSize)-1);
    for (UIButton *aButton in self.view.subviews) {
        if ([aButton.restorationIdentifier isEqualToString:@"Tic-Tac-Toe-Square"]) {
            if (randomizer == (int)aButton.tag) {
                if ([aButton.titleLabel.text isEqualToString:@" "]) {
                    [aButton setTitle:@"O" forState:UIControlStateNormal];
                    [aButton setTitleColor:[UIColor colorWithRed:0.008
                                                           green:0.529
                                                            blue:0.604
                                                           alpha:1]
                                  forState:UIControlStateNormal];
                    aButton.titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightSemibold];
                    aButton.titleLabel.center = CGPointMake(aButton.center.x, aButton.center.y);
                    self.movesTaken++;
                    self.turnPlayerX = true;
                    [self runTimerNow];
                    [self.activityIndicator stopAnimating];
                    if (self.movesTaken == (self.gridSize * self.gridSize)) {
                        NSLog(@"CHECK IF ANYONE WON, IF NOT, GAME ENDED TIE, OTHERWISE SAY WHO WON");
                    }
                    return;
                }
            }
        }
    }
    [self dumbassAI];
}


-(void) runTimerNow {
    self.countdownTimeMemory = 5;
    self.countdownTimer.text = [NSString stringWithFormat:@"%i", self.countdownTimeMemory];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myCountdownTimer) userInfo:nil repeats:true];
}


-(void) myCountdownTimer {
    self.countdownTimeMemory--;
    if (self.countdownTimer.text >= 0) {
        self.countdownTimer.text = [NSString stringWithFormat:@"%i", self.countdownTimeMemory];
    }
    if (self.countdownTimeMemory == -1) {
        self.countdownTimer.text = @"Skip!";
        self.turnPlayerX = !self.turnPlayerX;
        
    }
    if (self.countdownTimeMemory == -2) {
        [self killTimer];
        if (self.modeOneIsOn) {
            [self turnTimerSet];
        }
    }
}


-(void)killTimer {
    self.countdownTimer.text = nil;
    [self.myTimer invalidate];
    self.myTimer = nil;
}




@end
