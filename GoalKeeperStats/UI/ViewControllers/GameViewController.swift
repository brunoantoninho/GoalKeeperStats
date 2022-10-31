//
//  GameViewController.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 28/10/2022.
//

import UIKit
import MessageUI

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
    
    private var viewModel: GameViewModel!
    var gameId: Int!
    
    private var defendedScore = 0 {
        didSet {
            defendedLabelScore.text = "\(defendedScore)"
            viewModel.saveDefendedScore(defendedScore: defendedScore)
        }
    }
    private var visitingTeamScore = 0 {
        didSet {
            sufferdLabelScore.text = "\(visitingTeamScore)"
            visitingTeamScoreLabel.text = "\(visitingTeamScore)"
            viewModel.saveVisitingTeamScore(visitingTeamScore: visitingTeamScore)
        }
    }
    
    private var homeTeamScore = 0 {
        didSet {
            homeTeamScoreLabel.text = "\(homeTeamScore)"
            viewModel.saveHomeTeamScore(homeTeamScore: homeTeamScore)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameViewModel(gameId: gameId)
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
    }
    
    private func setupUI() {
        UIApplication.shared.isIdleTimerDisabled = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let game = viewModel.game {
            populateUI(game: game)
        }
    }
    
    // MARK: Button Action
    
    @objc
    func defendedButtonAction() {
        defendedScore += 1
    }
    
    @objc
    func sufferdButtonAction() {
        visitingTeamScore += 1
    }
    
    @objc
    func undoDefendedButtonAction() {
        if defendedScore > 0 {
            defendedScore -= 1
        }
    }
    
    @objc
    func undoSufferdButtonAction() {
        if visitingTeamScore > 0 {
            visitingTeamScore -= 1
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

            let emailBody =
"""
            Resultado final:
            \(viewModel.game.homeTeamName) X \(viewModel.game.visitingTeamName)
            \(viewModel.game.homeTeamScore) - \(viewModel.game.visitingTeamScore)
            
            Número de defesas: \(viewModel.game.defendedScore)
            Golos sofridos: \(viewModel.game.visitingTeamScore)
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
    
    // MARK: Helpers
    
    private func saveGame() {
        let currentGame = Game()
        currentGame.id = Int(Date().timeIntervalSince1970 * 1000)
        currentGame.defendedScore = defendedScore
        currentGame.homeTeamScore = homeTeamScore
        currentGame.visitingTeamScore = visitingTeamScore
        RealmManager.shared().save(currentGame)
    }
    
}

extension GameViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension GameViewController: GameViewModelDelegate {
    func populateUI(game: Game) {
        homeTeamLabel.text = game.homeTeamName
        homeTeamScoreLabel.text = String(game.homeTeamScore)
        visitingTeamLabel.text = game.visitingTeamName
        visitingTeamScoreLabel.text = String(game.visitingTeamScore)
        defendedLabelScore .text = String(game.defendedScore)
    }
}
