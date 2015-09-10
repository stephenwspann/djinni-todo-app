#import "TableViewCell.h"

@implementation TableViewCell

@synthesize label = _label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // add a label
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self addSubview:self.label];
        
        // add the delete button
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //set the position of the button
        self.button.frame = CGRectMake(250, 5, 100, 30);
        [self.button setTitle:@"Delete" forState:UIControlStateNormal];
        self.button.backgroundColor= [UIColor clearColor];
        [self addSubview:self.button];

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
