//
//  SelectPlayerViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 07/11/2022.
//

import UIKit

protocol SelectPlayerProtocol: AnyObject {
    func selectedPlayer(player: Player)
    func deletedPlayer(player: Player)
}

class SelectPlayerViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    private let viewModel = SelectPlayerViewModel()
    weak var selectPlayerDelegate: SelectPlayerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Jogadores"
        setupDelegates()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createPlayerButtonAction))
    }
    
    private func setupDelegates() {
        table.delegate = self
        table.dataSource = self
        viewModel.delegate = self
    }
    
    @objc
    private func createPlayerButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePlayerViewController") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SelectPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playersList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "SelectPlayerCell", for: indexPath)
        
        guard let playersList = viewModel.playersList else { return cell }
        let player = playersList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = player.name
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let player = viewModel.playersList?[indexPath.row] {
            selectPlayerDelegate?.selectedPlayer(player: player)
        }
        if self.presentingViewController != nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Apagar") { [unowned self] contextualAction, view, completionHandler in
            if let player = viewModel.playersList?[indexPath.row] {
                RealmManager().delete(player)
                completionHandler(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension SelectPlayerViewController: TableNotificationProtocol {
    func initial() {
        table.reloadData()
    }
    
    func deletions(rows: [Int]) {
        table.performBatchUpdates({
            table.deleteRows(at: rows.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
        })
    }
    
    func insertions(rows: [Int]) {
        table.performBatchUpdates({
            table.insertRows(at: rows.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
        })
    }
    
    func modifications(rows: [Int]) {
        table.performBatchUpdates({
            table.reloadRows(at: rows.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
        })
    }
}
