//
//  FirstViewController.swift
//  AirbnbProject
//
//  Created by Keunna Lee on 2020/05/18.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!

    var models = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        models.append(Model(imageName: "bye"))
        models.append(Model(imageName: "bye"))
        models.append(Model(imageName: "bye"))
        models.append(Model(imageName: "bye"))
    }
    
    private func setupTableView() {
        infoTableView.register(AccomodationInfoTableViewCell.nib(), forCellReuseIdentifier: AccomodationInfoTableViewCell.identifier)
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.delaysContentTouches = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accomodationCellTapped))
        self.infoTableView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func accomodationCellTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.infoTableView)
        guard let tappedCellIndexPath = self.infoTableView.indexPathForRow(at: tapLocation) else {return}
        let tappedCell = self.infoTableView.cellForRow(at: tappedCellIndexPath) as! AccomodationInfoTableViewCell
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = infoTableView.dequeueReusableCell(withIdentifier: AccomodationInfoTableViewCell.identifier, for: indexPath) as! AccomodationInfoTableViewCell
        cell.configure(with: models)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 2.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.width / 10
    }
}

