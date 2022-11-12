//
//  SelectTeamViewController.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 11/11/2022.
//

import UIKit

enum TeamType {
    case home
    case visiting
}

protocol SelectTeamProtocol: AnyObject {
    func selectedTeam(team: Team, teamType: TeamType)
    func deleteTeam(team: Team)
}

class SelectTeamViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var teamType: TeamType!
    private let viewModel = SelectTeamViewModel()
    weak var selectTeamDelegate: SelectTeamProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Equipas"
        setupNavigationBar()
        setupDelegates()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTeamButtonAction))
    }
    
    private func setupDelegates() {
        table.delegate = self
        table.dataSource = self
        viewModel.delegate = self
    }
    
    @objc
    private func createTeamButtonAction() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamViewController") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SelectTeamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.teamList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "SelectTeamCell", for: indexPath)
        
        guard let teamList = viewModel.teamList else { return cell }
        let team = teamList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = team.name
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let team = viewModel.teamList?[indexPath.row] {
            selectTeamDelegate?.selectedTeam(team: team, teamType: teamType)
        }
        if self.presentingViewController != nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Apagar") { [unowned self] contextualAction, view, completionHandler in
            if let team = viewModel.teamList?[indexPath.row] {
                self.selectTeamDelegate?.deleteTeam(team: team)
                RealmManager().delete(team)
                completionHandler(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension SelectTeamViewController: TableNotificationProtocol {
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

