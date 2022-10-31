//
//  GameSetupViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import UIKit

enum GameType {
    case league
    case trainingGame
    case training
    case tournament
    case others
}

class GameSetupViewController: UIViewController {
    
    @IBOutlet private weak var homeTeamLabel: UILabel!
    @IBOutlet private weak var homeTeamTextField: UITextField!
    @IBOutlet private weak var visitingTeamLabel: UILabel!
    @IBOutlet private weak var visitingTeamTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var startGameButton: UIButton!
    
    var gameType: GameType!
    var viewModel = GameSetupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        startGameButton.addTarget(self, action: #selector(startGameButtonAction), for: .touchUpInside)
    }
    
    @objc
    func startGameButtonAction() {
        saveGame()
    }
    
    private func saveGame() {
        let game = Game()
        game.id = Int(Date().timeIntervalSince1970 * 1000)
        game.homeTeamName = homeTeamTextField.text!
        game.visitingTeamName = visitingTeamTextField.text!
        RealmManager.shared().save(game)
    }
}

extension GameSetupViewController: GameSetupDelegate {
    func navigateToGame(gameId: Int) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            vc.gameId = gameId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
