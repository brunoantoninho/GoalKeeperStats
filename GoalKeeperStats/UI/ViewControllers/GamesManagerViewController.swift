//
//  GamesManagerViewController.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import UIKit

class GamesManagerViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var addGameButton: UIButton!
    @IBOutlet weak var tableGames: UITableView!
    
    private var viewModel = GameManagerViewModel()
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        tableGames.delegate = self
        tableGames.dataSource = self
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        addGameButton.addTarget(self, action: #selector(addGameButtonAction), for: .touchUpInside)
    }
    
    @objc
    private func addGameButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") {
            
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
        
        cell.HomeTeamLabel.text = game.homeTeamName
        cell.HomeTeamScoreLabel.text = String(game.homeTeamScore)
        cell.visitingTeamLabel.text = game.visitingTeamName
        cell.visitingTeamScoreLabel.text = String(game.visitingTeamScore)
        return cell
    }
}

extension GamesManagerViewController: GameManagerViewModelDelegate {
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
