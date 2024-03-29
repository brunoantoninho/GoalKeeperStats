//
//  GamesManagerViewController.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import UIKit

class GamesManagerViewController: UIViewController, Storyboarded {
    
    @IBOutlet private weak var addGameButton: UIButton!
    @IBOutlet private weak var tableGames: UITableView!
    
    private var viewModel = GameManagerViewModel()
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        tableGames.delegate = self
        tableGames.dataSource = self
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupButtons() {
        addGameButton.addTarget(self, action: #selector(addGameButtonAction), for: .touchUpInside)
    }
    
    @objc
    private func addGameButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameTypeViewController") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension GamesManagerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gamesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableGames.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as! GameTableViewCell
        
        guard let gamesList = viewModel.gamesList else { return cell }
        let game = gamesList[indexPath.row]
        
        cell.HomeTeamLabel.text = game.homeTeam.name
        cell.HomeTeamScoreLabel.text = String(game.homeTeamScore)
        cell.visitingTeamLabel.text = game.visitingTeam.name
        cell.visitingTeamScoreLabel.text = String(game.visitingTeamScore)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Apagar") { [unowned self] contextualAction, view, completionHandler in
            if let game = viewModel.gamesList?[indexPath.row] {
                RealmManager().delete(game)
                completionHandler(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension GamesManagerViewController: TableNotificationProtocol {
    func initial() {        
        tableGames.reloadData()
    }
    
    func deletions(rows: [Int]) {
        tableGames.performBatchUpdates({
            tableGames.deleteRows(at: rows.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
        })
    }
    
    func insertions(rows: [Int]) {
        tableGames.performBatchUpdates({
            tableGames.insertRows(at: rows.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
        })
    }
    
    func modifications(rows: [Int]) {
        tableGames.performBatchUpdates({
            tableGames.reloadRows(at: rows.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
        })
    }
}
