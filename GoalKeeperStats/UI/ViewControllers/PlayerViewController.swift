//
//  PlayerViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 07/11/2022.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var totalDefensesCaptionLabel: UILabel!
    @IBOutlet weak var totalDefensesValueLabel: UILabel!
    @IBOutlet weak var totalSufferedCaptionLabel: UILabel!
    @IBOutlet weak var totalSufferedValueLabel: UILabel!
    @IBOutlet weak var numberPlayedGamesCaptionLabel: UILabel!
    @IBOutlet weak var numberPlayedGamesValueLabel: UILabel!
    
    @IBOutlet weak var averageDefensesCaptionLabel: UILabel!
    @IBOutlet weak var averageDefensesValueLabel: UILabel!
    @IBOutlet weak var averageSufferedCaptionLabel: UILabel!
    @IBOutlet weak var averageSufferedValueLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
