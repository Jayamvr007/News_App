//
//  MyTableViewCell.swift
//  demo_task
//
//  Created by Jayam Verma on 21/04/23.
//

import UIKit

protocol MyTableViewCellDelegate{
    func checkBoxToggle(isSelected:Bool)
}

class MyTableViewCell: UITableViewCell {
    
    var delegate : MyTableViewCellDelegate?

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myLabel1: UILabel!
    
    @IBOutlet weak var myLabel2: UILabel!
    
    @IBOutlet weak var btnCheckbox: UIButton!
    
    public var boolval: Bool = true
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        
        // If user tapped on checkbox change the isSelected value
        
        if sender.isSelected == false{
            sender.isSelected = true
        }
        else{
            sender.isSelected = false
        }
        
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
