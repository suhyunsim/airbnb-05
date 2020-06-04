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
    
    private var offset = 0
    private var guestCount: Int?
    private var bookingDate: (String, String)?
    private var priceRange: (String, String)?

    var selectedCityId: Int?
    var models: [RoomInfo]?
    var priceSetUpDelegate: SendDataDelegate?
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        configureAccomodationList()
    }
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureAccomodationList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GuestFilterViewController.segueName {
            let viewController = segue.destination as! GuestFilterViewController
            viewController.guestDelegate = self
        } else if segue.identifier == CalendarViewController.segueName {
            let viewController = segue.destination as! CalendarViewController
            viewController.dateDelegate = self
        } else if segue.identifier == PriceFilterViewController.segueName {
           let viewController = segue.destination as! PriceFilterViewController
            viewController.cityId = self.selectedCityId
            viewController.guestCount = self.guestCount
            viewController.bookingDate = self.bookingDate
        }
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
    
    private func configureAccomodationList() {
        let param = EndPoints.requestAccomodationList(offset: 0, checkIn: bookingDate?.0, checkOut: bookingDate?.1, guests: guestCount, minPrice: priceRange?.0, maxPrice: priceRange?.1)
        DataUseCase.getAccomodationList(manager: NetworkManager(), cityId: self.selectedCityId!, paramData: param) { roomInfoList in
            self.models = roomInfoList
            DispatchQueue.main.async {
                self.infoTableView.reloadData()
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = infoTableView.dequeueReusableCell(withIdentifier: AccomodationInfoTableViewCell.identifier, for: indexPath) as! AccomodationInfoTableViewCell
        guard let models = models else { return UITableViewCell() }
        cell.configure(with: models)
        cell.favoriteButton.isFavorite = models[indexPath.row].favorite
        let favoriteButtonManager = FavoriteButtonManager(isFavorite: cell.favoriteButton.isFavorite!)
        cell.setFavoriteButtonUI(view: cell.favoriteButton, manager: favoriteButtonManager)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        startCellDisplayAnimation(cell)
    }
    
    private func startCellDisplayAnimation(_ cell: UITableViewCell) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
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

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print("end of table view")
        }
    }
}

extension MainViewController: SendDataDelegate {
    func sendData(data: String) {
        guestCount = Int(data)!
    }
    
    func sendDate(first: String, second: String) {
        bookingDate = (first, second)
    }
    
    func sendPrice(first: String, second: String) {
        priceRange = (first, second)
    }
}

