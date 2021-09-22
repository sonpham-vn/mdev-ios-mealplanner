//
//  PlannerTableViewCell.swift
//  meal planner
//
//  Created by SonPT on 2021-08-19.
//

import UIKit

class PlannerTableViewCell: UITableViewCell {

    @IBOutlet weak var LbDate: UILabel!
    
    @IBOutlet weak var LbPeriod: UILabel!
    
    @IBOutlet weak var LbMealName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
