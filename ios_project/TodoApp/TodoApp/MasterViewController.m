//
//  MasterViewController.m
//  TodoApp
//
//  Created by Stephen Spann on 9/2/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "TDATodoList.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController {
    TDATodoList *_todoInterface;
    NSMutableArray *_todos;
    int _newTodoCount;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // instantiate our Todo Library Interface with correct path
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _todoInterface = [TDATodoList createWithPath: documentsPath];
    
    // populate the array with our data
    NSArray *todos = [_todoInterface getTodos];
    NSLog(@"%@", todos);
    _todos = [[NSMutableArray alloc] initWithArray:todos];
    _newTodoCount = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!_todos) {
        _todos = [[NSMutableArray alloc] initWithArray:[_todoInterface getTodos]];
    }

    NSString *newTodoLabel = [NSString stringWithFormat:@"New Todo %d", _newTodoCount];
    [_todoInterface addTodo:newTodoLabel];
    _todos = [[NSMutableArray alloc] initWithArray:[_todoInterface getTodos]];
    [self.tableView reloadData];
    _newTodoCount++;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _todos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TDATodo *todo = _todos[indexPath.row];
    
    NSString *todoLabel = [todo label];
    
    NSString *completedString = @"  ";
    int completed = [todo completed];
    if (completed == 1) {
        completedString = @"X";
    }
    
    NSString *todoText = [NSString stringWithFormat:@"%@   %@", completedString, todoLabel];
    cell.textLabel.text = todoText;
    
    return cell;
    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    // toggle the todo in the database.
    TDATodo *todo = _todos[indexPath.row];
    int dbRow = todo.id;
    if ([todo completed] == 1) {
        [_todoInterface updateTodoCompleted:dbRow completed:0];
    } else {
        [_todoInterface updateTodoCompleted:dbRow completed:1];
    }
    // get new data from database and update the table view
    _todos = [[NSMutableArray alloc] initWithArray:[_todoInterface getTodos]];
    [self.tableView reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TDATodo *todo = _todos[indexPath.row];
        int dbRow = todo.id;
        NSLog(@"delete %d", dbRow);
        [_todoInterface deleteTodo:dbRow];
        _todos = [[NSMutableArray alloc] initWithArray:[_todoInterface getTodos]];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
