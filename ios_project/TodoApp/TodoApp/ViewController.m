#import "ViewController.h"
#import "TDATodoList.h"

@interface ViewController ()

@property NSMutableArray *objects;
@end

@implementation ViewController {
    TDATodoList *_todoInterface;
    NSMutableArray *_todos;
    int _newTodoCount;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton addTarget:self
               action:@selector(insertNewObject:)
     forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"Add Todo" forState:UIControlStateNormal];
    addButton.frame = CGRectMake(20.0, 20.0, 160.0, 40.0);
    [self.view addSubview:addButton];
    
    // instantiate our table view
    CGRect fr = CGRectMake(0, 65, 320, 415);
    _tableView = [[UITableView alloc] initWithFrame:fr style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
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
    [_tableView reloadData];
    _newTodoCount++;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _todos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"Cell"];
    }
    
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
    [_tableView reloadData];
    
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
        [_tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end