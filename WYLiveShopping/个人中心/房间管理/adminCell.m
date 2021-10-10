
#import "adminCell.h"
#import "WYManagerModel.h"

#import "SDWebImage/UIButton+WebCache.h"


@implementation adminCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setModel:(WYManagerModel *)model{
    
    _model = model;
    _nameL.text = _model.name;
    //头像
    [self.iconBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.icon] forState:UIControlStateNormal];
    
    self.iconBTN.layer.cornerRadius = 20;
    self.iconBTN.layer.masksToBounds = YES;
}
 
+(adminCell *)cellWithTableView:(UITableView *)tableView{
    
    adminCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"adminCell" owner:self options:nil].lastObject;
    }
    return cell;
    
}
- (IBAction)delateBtnClick:(id)sender {
    [self.delegate delateAdminUser:_model];
}

@end
