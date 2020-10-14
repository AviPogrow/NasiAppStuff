//
//  FavoritesViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/3/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct TableView {
        struct CellIdentifiers {
            static let savedSingleCell = "SavedSingleCell"
        }
    }
    
    var favChildArr = [[String : String]]()
    var arrFavGirlsList = [NasiGirlsList]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwNoDataFound: UIView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Saved Nasi Singles"
        
        NotificationCenter.default.addObserver(self, selector: #selector(favouriteRemovedByUser(notificationReceived:)), name: Constant.EventNotifications.notifRemoveFromFav, object: nil)

        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.savedSingleCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.savedSingleCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.vwNoDataFound.isHidden = true
        self.getFav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Selectors
    @objc func favouriteRemovedByUser(notificationReceived : Notification) {
         self.getFav()
    }

    func getFav() {
        self.view.showLoadingIndicator()
        ref = Database.database().reference()
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        print("here is id", myId)
        ref.child("myFav").child(myId).observe(.childAdded) { (snapShots) in
            self.view.hideLoadingIndicator()
            self.favChildArr.removeAll()
            let snap = snapShots.value as? [String : Any]
            print(snap)
            if (snapShots.value is NSNull ) {
                print("– – – Data was not found – – –")
            } else {
                var snap = snapShots.value as? [String : String]
                snap?["child_key"] = snapShots.key as? String
                if let dict = snap {
                    print(dict)
                    // arrFavGirlsList.removeAll()
                    self.favChildArr.append(dict)
                    self.filterFavData()
                } else {
                    print("not a valid data")
                }
            }
        }
        
        
        if favChildArr.count > 0 {
            
        } else {
            self.view.hideLoadingIndicator()
            self.filterFavData()
        }
    }
    
    func filterFavData() {
        if favChildArr.count > 0 {
            print("here is fav child", favChildArr)
            print("here is fav child count", favChildArr.count)
            
            for (index,list) in Variables.sharedVariables.arrList.enumerated() {
                let currentId = list.currentGirlUID
                for (innerIndex,list) in favChildArr.enumerated() {
                    let userId = list["userId"]
                    let childKey = list["child_key"]
                    print("here is user id", userId ?? "")
                    print("here is child key", childKey ?? "")
                    if currentId == userId {
                        print("append")
                        arrFavGirlsList.append(Variables.sharedVariables.arrList[index])
                    }
                }
            }
            
            print("here is fav",arrFavGirlsList.count)
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.vwNoDataFound.isHidden = true
            
        } else {
            self.tableView.isHidden = true
            self.vwNoDataFound.isHidden = false
            print("here is no fav child")
        }
    }
    
    // MARK: - Table View Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavGirlsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.savedSingleCell, for: indexPath) as! SavedSingleTableViewCell
        
        let model = arrFavGirlsList[indexPath.row]
        cell.configure(for: model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vcSingleDetail = self.storyboard?.instantiateViewController(withIdentifier: "SingleDetailViewController") as! SingleDetailViewController
        vcSingleDetail.selectedSingle = arrFavGirlsList[indexPath.row]
        self.navigationController?.pushViewController(vcSingleDetail, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         if segue.identifier == "ShowDetail" {
         let detailViewController = segue.destination as! ShadchanListDetailViewController
         let indexPath = sender as! IndexPath
         let selectedSingle = fetchedResultsController.object(at: indexPath)
         detailViewController.selectedSingle = selectedSingle
         }*/
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
}
