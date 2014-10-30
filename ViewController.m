//
//  ViewController.m
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/5/13.
//  Copyright (c) 2013 Nikanj Gupta Vemala. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "MainMenuScene.h"

@implementation ViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    //Create main menu Scene
    SKScene *mainmenu = [MainMenuScene sceneWithSize:skView.bounds.size];
    mainmenu.scaleMode = SKSceneScaleModeAspectFill;
    
    // Create and configure the scene.
   // SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    //have to change this to mainmenu scene
    [skView presentScene:mainmenu];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
