//
//  GameViewController.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 28/10/2022.
//

import UIKit
import MessageUI

class GameViewController: UIViewController {

    @IBOutlet weak var defendedButton: UIButton!
    @IBOutlet weak var defendedLabel: UILabel!
    @IBOutlet weak var defendedLabelScore: UILabel!
    @IBOutlet weak var undoDefendedButton: UIButton!
    @IBOutlet weak var sufferdButton: UIButton!
    @IBOutlet weak var sufferedLabel: UILabel!
    @IBOutlet weak var sufferdLabelScore: UILabel!
    @IBOutlet weak var undoSufferdButton: UIButton!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var visitingTeamLabel: UILabel!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var visitingTeamScoreLabel: UILabel!
    @IBOutlet weak var homeTeamGoalButton: UIButton!
    @IBOutlet weak var homeTeamUndoGoalButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var gameOverButton: UIButton!
    private var defendedScore = 0 {
        didSet {
            defendedLabelScore.text = "\(defendedScore)"
        }
    }
    private var visitingTeamScore = 0 {
        didSet {
            sufferdLabelScore.text = "\(visitingTeamScore)"
            visitingTeamScoreLabel.text = "\(visitingTeamScore)"
            
        }
    }
    
    private var homeTeamScore = 0 {
        didSet {
            homeTeamScoreLabel.text = "\(homeTeamScore)"
        }
    }
    
    private var homeTeamName = "" {
        didSet {
            homeTeamLabel.text = homeTeamName
        }
    }
    
    private var visitingTeamName = "" {
        didSet {
            visitingTeamLabel.text = visitingTeamName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupLabels()
        setupUI()

        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func setupLabels() {
        homeTeamName = "AAC"
        visitingTeamName = "Albergaria"
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
            \(homeTeamName) X \(visitingTeamName)
            \(homeTeamScore) - \(visitingTeamScore)
            
            Número de defesas: \(defendedScore)
            Golos sofridos: \(visitingTeamScore)
"""
            mail.setMessageBody(emailBody, isHTML: false)
            present(mail, animated: true)
        } else {
            print("Error sending email")
        }
    }
    
    @objc
    func gameOverButtonAction() {
        saveGame()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    
    private func saveGame() {
        let currentGame = Game()
        currentGame.id = Int(Date().timeIntervalSince1970 * 1000)
        currentGame.defendedScore = defendedScore
        currentGame.homeTeamScore = homeTeamScore
        currentGame.homeTeamName = homeTeamName
        currentGame.visitingTeamName = visitingTeamName
        currentGame.visitingTeamScore = visitingTeamScore
        RealmManager.shared().save(currentGame)
    }
    
}

extension GameViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
