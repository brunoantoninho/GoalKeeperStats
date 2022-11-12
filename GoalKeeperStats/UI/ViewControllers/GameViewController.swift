//
//  GameViewController.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 28/10/2022.
//

import MessageUI
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet private weak var defendedButton: UIButton!
    @IBOutlet private weak var defendedLabel: UILabel!
    @IBOutlet private weak var defendedLabelScore: UILabel!
    @IBOutlet private weak var undoDefendedButton: UIButton!
    @IBOutlet private weak var sufferdButton: UIButton!
    @IBOutlet private weak var sufferedLabel: UILabel!
    @IBOutlet private weak var sufferdLabelScore: UILabel!
    @IBOutlet private weak var undoSufferdButton: UIButton!
    @IBOutlet private weak var homeTeamLabel: UILabel!
    @IBOutlet private weak var visitingTeamLabel: UILabel!
    @IBOutlet private weak var homeTeamScoreLabel: UILabel!
    @IBOutlet private weak var visitingTeamScoreLabel: UILabel!
    @IBOutlet private weak var homeTeamGoalButton: UIButton!
    @IBOutlet private weak var homeTeamUndoGoalButton: UIButton!
    @IBOutlet private weak var sendEmailButton: UIButton!
    @IBOutlet private weak var gameOverButton: UIButton!
    @IBOutlet weak var switchPlayerButton: UIButton!
    @IBOutlet weak var playerName: UILabel!
    
    let viewModel = GameViewModel()
    
    private var defendedScore = 0 {
        didSet {
            defendedLabelScore.text = "\(defendedScore)"
            viewModel.saveDefendedScore(score: defendedScore)
        }
    }
    
    private var missedScore = 0 {
        didSet {
            viewModel.saveMissedScore(score: missedScore)
        }
    }
    
    private var visitingTeamScore = 0 {
        didSet {
            sufferdLabelScore.text = "\(visitingTeamScore)"
            visitingTeamScoreLabel.text = "\(visitingTeamScore)"
            viewModel.saveVisitingTeamScore(score: visitingTeamScore)
        }
    }
    
    private var homeTeamScore = 0 {
        didSet {
            homeTeamScoreLabel.text = "\(homeTeamScore)"
            viewModel.saveHomeTeamScore(score: homeTeamScore)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.currentPlayerStats = viewModel.game?.playerStats.first!
        viewModel.delegate = self
        setupButtons()
        setupUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupButtons() {
        defendedButton.addTarget(self, action: #selector(defendedButtonAction), for: .touchUpInside)
        sufferdButton.addTarget(self, action: #selector(sufferdButtonAction), for: .touchUpInside)
        undoSufferdButton.addTarget(self, action: #selector(undoSufferdButtonAction), for: .touchUpInside)
        undoDefendedButton.addTarget(self, action: #selector(undoDefendedButtonAction), for: .touchUpInside)
        homeTeamGoalButton.addTarget(self, action: #selector(homeTeamGoalButtonAction), for: .touchUpInside)
        homeTeamUndoGoalButton.addTarget(self, action: #selector(homeTeamUndoGoalButtonAction), for: .touchUpInside)
        sendEmailButton.addTarget(self, action: #selector(sendEmailButtonAction), for: .touchUpInside)
        gameOverButton.addTarget(self, action: #selector(gameOverButtonAction), for: .touchUpInside)
        switchPlayerButton.addTarget(self, action: #selector(switchPlayerButtonAction), for: .touchUpInside)
    }
    
    private func setupUI() {
        UIApplication.shared.isIdleTimerDisabled = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        populateUI()
    }
    
    // MARK: Button Action
    
    @objc
    func defendedButtonAction() {
        defendedScore += 1
    }
    
    @objc
    func sufferdButtonAction() {
        visitingTeamScore += 1
        missedScore += 1
    }
    
    @objc
    func undoDefendedButtonAction() {
        if defendedScore > 0 {
            defendedScore -= 1
        }
    }
    
    @objc
    func undoSufferdButtonAction() {
        if visitingTeamScore > 0 && missedScore > 0 {
            visitingTeamScore -= 1
            missedScore -= 1
        }
    }
    
    @objc
    func homeTeamGoalButtonAction() {
        homeTeamScore += 1
    }
    
    @objc
    func homeTeamUndoGoalButtonAction() {
        if homeTeamScore > 0 {
            homeTeamScore -= 1
        }
    }
    
    @objc
    private func sendEmailButtonAction() {

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Dados do jogo")
            
            guard let game = viewModel.game else { return }
            var playerStatusString = ""
            for playerStatus in game.playerStatsList {
                if let playerName = RealmManager().object(ofType: Player.self, forPrimaryKey: playerStatus.playerId)?.name {
                    playerStatusString += "Nome Jogador: \(playerName)\n"
                }
                
                playerStatusString += "Número de defesas: " + String(playerStatus.defendedScore) + "\n"
                playerStatusString += "Golos sofridos: " + String(playerStatus.missedScore) + "\n\n"
            }
            let emailBody =
"""
            Resultado final:
            \(game.homeTeam.name) X \(game.visitingTeam.name)
            \(game.homeTeamScore) - \(game.visitingTeamScore)

            ---------- Dados Jogadores ----------
            \(playerStatusString)
"""
            mail.setMessageBody(emailBody, isHTML: false)
            present(mail, animated: true)
        } else {
            print("Error sending email")
        }
    }
    
    @objc
    func gameOverButtonAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func switchPlayerButtonAction() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectPlayerViewController") as? SelectPlayerViewController {
            vc.selectPlayerDelegate = self
            self.present(vc, animated: true)
        }
    }
    
    // MARK: Helpers
    
}

extension GameViewController: GameViewModelDelegate {
    func populateUI() {
        homeTeamLabel.text = viewModel.game?.homeTeam.name
        visitingTeamLabel.text = viewModel.game?.visitingTeam.name
        if let game = viewModel.game {
            homeTeamScoreLabel.text = String(game.homeTeamScore)
            visitingTeamScoreLabel.text = String(game.visitingTeamScore)
        }
        
        guard let currentPlayerStats = viewModel.currentPlayerStats else { return }
        defendedLabelScore.text = String(currentPlayerStats.defendedScore)
        
        if let name = RealmManager().object(ofType: Player.self, forPrimaryKey: currentPlayerStats.playerId)?.name {
            playerName.text = name
        }
    }
}

extension GameViewController: SelectPlayerProtocol {
    
    func selectedPlayer(player: Player) {
        
        viewModel.currentPlayerStats = viewModel.game?.playerStats.first(where: { gamePlayerStats in
            gamePlayerStats.playerId == player.id
        })!
        
        if let currentPlayerStats = viewModel.currentPlayerStats {
            defendedScore = currentPlayerStats.defendedScore
        }
        playerName.text = player.name
    }
    
    func deletedPlayer(player: Player) {
        if let removeIndex = viewModel.game?.playerStatsList.firstIndex(where: { gamePlayerStats in
            gamePlayerStats.playerId == player.id
        }) {
            viewModel.game?.playerStatsList.remove(at: removeIndex)
        }
    }
}

extension GameViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
