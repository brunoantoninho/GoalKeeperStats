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
    
    @IBOutlet weak var homeTeamButton: UIButton!
    @IBOutlet weak var visitingTeamButton: UIButton!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var playersStack: UIStackView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var startGameButton: UIButton!
    
    var gameType: GameType!
    var viewModel = GameSetupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Novo Jogo"
        setupButtons()
        viewModel.gameSetupDelegate = self
    }
    
    private func setupButtons() {
        startGameButton.addTarget(self, action: #selector(startGameButtonAction), for: .touchUpInside)
        addPlayerButton.addTarget(self, action: #selector(addPlayerButtonAction), for: .touchUpInside)
        homeTeamButton.addTarget(self, action: #selector(homeTeamButtonAction), for: .touchUpInside)
        visitingTeamButton.addTarget(self, action: #selector(visitingTeamButtonAction), for: .touchUpInside)
    }
    
    @objc
    private func addPlayerButtonAction() {
        navigateToSelectPlayer()
    }
    
    private func navigateToSelectPlayer() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectPlayerViewController") as? SelectPlayerViewController {
            vc.selectPlayerDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    private func startGameButtonAction() {
        if let homeTeam = viewModel.homeTeam,
           let visitorTeam = viewModel.visitorTeam {
            viewModel.saveGame(id: Int(Date().timeIntervalSince1970 * 1000),
                               homeTeam: homeTeam,
                               visitingTeam: visitorTeam,
                               date: datePicker.date,
                               players: viewModel.playersList)
        }
    }
    
    @objc
    private func homeTeamButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTeamViewController") as? SelectTeamViewController {
            vc.teamType = .home
            vc.selectTeamDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    private func visitingTeamButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTeamViewController") as? SelectTeamViewController {
            vc.teamType = .visiting
            vc.selectTeamDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension GameSetupViewController: GameSetupDelegate {
    
    func navigateToGame(game: Game) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            
            vc.viewModel.game = game
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setHomeTeam(team: Team?) {
        if let team {
            homeTeamButton.setTitle(team.name, for: .normal)
        } else {
            homeTeamButton.setTitle("Home Team", for: .normal)
        }
    }
    
    func setVisitingTeam(team: Team?) {
        if let team {
            visitingTeamButton.setTitle(team.name, for: .normal)
        } else {
            visitingTeamButton.setTitle("Home Team", for: .normal)
        }
    }
}

extension GameSetupViewController: SelectPlayerProtocol {
    func deletedPlayer(player: Player) {
        if let removeIndex = viewModel.playersList.firstIndex(of: player) {
            viewModel.playersList.remove(at: removeIndex)
        }
    }
    
    func selectedPlayer(player: Player) {
        viewModel.playersList.append(player)
        let playerLabel = UILabel()
        playerLabel.text = player.name
        playersStack.addArrangedSubview(playerLabel)
    }
}

extension GameSetupViewController: SelectTeamProtocol {
    
    func selectedTeam(team: Team, teamType: TeamType) {
        switch teamType {
        case .home:
            viewModel.homeTeam = team
            homeTeamButton.setTitle(team.name, for: .normal)
        case .visiting:
            viewModel.visitorTeam = team
            visitingTeamButton.setTitle(team.name, for: .normal)
        }
    }
    
    func deleteTeam(team: Team) {
        if viewModel.homeTeam == team {
            viewModel.homeTeam = nil
        } else if viewModel.visitorTeam == team {
            viewModel.visitorTeam = nil
        }
    }
}
