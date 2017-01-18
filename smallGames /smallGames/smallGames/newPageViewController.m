//
//  newPageViewController.m
//  NewGames
//
//  Created by kobe on 2016/12/20.
//  Copyright © 2016年 kobe. All rights reserved.
//

#import "newPageViewController.h"
#import "ViewController.h"
@interface newPageViewController ()
@property (weak, nonatomic) IBOutlet UIView *gesterView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

@end

@implementation newPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.gesterView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *gesturecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(enter)];
    gesturecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.gesterView addGestureRecognizer:gesturecognizer];
    
    NSArray *images = @[[UIImage imageNamed:@"upone"],
                        [UIImage imageNamed:@"uptwo"],
                        [UIImage imageNamed:@"upthree"]];
    self.stateImageView.animationImages = images;
    self.stateImageView.animationDuration = 0.7;
    [self.stateImageView startAnimating];    
    
}
-(void)enter{
    ViewController *controller = [[ViewController alloc]init];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
//    controller.name = self.nameTextField.text;
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
