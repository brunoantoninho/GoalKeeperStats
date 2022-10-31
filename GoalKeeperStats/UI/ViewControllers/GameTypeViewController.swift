//
//  GameTypeViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import UIKit

class GameTypeViewController: UIViewController {

    @IBOutlet private weak var leagueButton: UIButton!
    @IBOutlet private weak var trainingGameButton: UIButton!
    @IBOutlet private weak var trainingButton: UIButton!
    @IBOutlet private weak var tournamentButton: UIButton!
    @IBOutlet private weak var othersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }
    
    private func setupButtons() {
        leagueButton.addTarget(self, action: #selector(leagueButtonAction), for: .touchUpInside)
        trainingGameButton.addTarget(self, action: #selector(trainingGameButtonAction), for: .touchUpInside)
        trainingButton.addTarget(self, action: #selector(trainingButtonAction), for: .touchUpInside)
        tournamentButton.addTarget(self, action: #selector(tournamentButtonAction), for: .touchUpInside)
        othersButton.addTarget(self, action: #selector(othersButtonAction), for: .touchUpInside)
    }
    
    // MARK: Button Action
    
    @objc
    func leagueButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameSetupViewController") as? GameSetupViewController {
            vc.gameType = .league
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func trainingGameButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameSetupViewController") as? GameSetupViewController {
            vc.gameType = .trainingGame
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func trainingButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameSetupViewController") as? GameSetupViewController {
            vc.gameType = .training
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func tournamentButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameSetupViewController") as? GameSetupViewController {
            vc.gameType = .tournament
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func othersButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameSetupViewController") as? GameSetupViewController {
            vc.gameType = .others
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
