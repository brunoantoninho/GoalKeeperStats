//
//  SelectPlayerViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 07/11/2022.
//

import UIKit

protocol SelectPlayerProtocol: AnyObject {
    func selectedPlayer(player: Player)
}

class SelectPlayerViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var selectPlayerButton: UIButton!
    @IBOutlet weak var createPlayerButton: UIButton!
    
    private let viewModel = SelectPlayerViewModel()
    weak var selectPlayerdelegate: SelectPlayerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        table.delegate = self
        table.dataSource = self
        viewModel.delegate = self
    }
    
    private func setupButtons() {
        createPlayerButton.addTarget(self, action: #selector(createPlayerButtonAction), for: .touchUpInside)
        selectPlayerButton.addTarget(self, action: #selector(selectPlayerButtonAction), for: .touchUpInside)
    }
    
    @objc
    private func selectPlayerButtonAction() {
        
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
        guard let playersList = viewModel.playersList else { return }
        let player = playersList[indexPath.row]
        selectPlayerdelegate?.selectedPlayer(player: player)
        self.navigationController?.popViewController(animated: true)
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
