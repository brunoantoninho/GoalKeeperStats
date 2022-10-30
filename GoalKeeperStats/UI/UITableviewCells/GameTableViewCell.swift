//
//  GameTableViewCell.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var HomeTeamLabel: UILabel!
    @IBOutlet weak var HomeTeamScoreLabel: UILabel!
    @IBOutlet weak var visitingTeamLabel: UILabel!
    @IBOutlet weak var visitingTeamScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
