//
//  FavoritesViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 5/3/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct TableView {
       struct CellIdentifiers {
         static let savedSingleCell = "SavedSingleCell"
        }
     }

    var savedSingles = [SingleGirl]()
   
    var coreDataStack: CoreDataStack!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<SingleGirl> = {
        
      let request: NSFetchRequest<SingleGirl> = SingleGirl.fetchRequest()
             
      // two sort descriptor
      let categorySortDescriptor = NSSortDescriptor(key: "category", ascending: true)
      let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
             
      // filter based on the isSavedPredicate
      let isSavedPredicate = NSPredicate(format: "%K == %@", #keyPath(SingleGirl.isSaved), "true")
                 
      // assign the sortDesc and predicates
      request.sortDescriptors = [categorySortDescriptor,ageSortDescriptor]
      request.predicate = isSavedPredicate
        
 
      let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      
      fetchedResultsController.delegate = self
      return fetchedResultsController
    }()
    
    deinit {
       fetchedResultsController.delegate = nil
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.title = "My Saved Nasi Singles"
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.savedSingleCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.savedSingleCell)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        performFetch()
        tableView.reloadData()
        
    }
    
    // MARK:- Helper methods
    func performFetch() {
      do {
        try fetchedResultsController.performFetch()
      } catch {
        fatalCoreDataError(error)
      }
    }
    
    // MARK: - Table View Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
          return fetchedResultsController.sections!.count
      }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           
         let sectionInfo = fetchedResultsController.sections![section]
         return sectionInfo.name
               
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let sectionInfo = fetchedResultsController.sections![section]
      return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.savedSingleCell, for: indexPath) as! SavedSingleTableViewCell
        
        let currentSingle = fetchedResultsController.object(at: indexPath)
        cell.configure(for: currentSingle)
        
      
        return cell 
    }
    
   /*
   func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "end of section"
    }
 */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
       performSegue(withIdentifier: "ShowDetail", sender: indexPath)
     }
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let location = fetchedResultsController.object(at: indexPath)
        location.removePhotoFile()
        managedObjectContext.delete(location)
        do {
          try managedObjectContext.save()
        } catch {
          fatalCoreDataError(error)
        }
      }
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ShowDetail" {
        let detailViewController = segue.destination as! SingleDetailViewController
        let indexPath = sender as! IndexPath
         let selectedSingle = fetchedResultsController.object(at: indexPath)
        
        detailViewController.selectedSingle = selectedSingle
      }
    }
}

// MARK:- NSFetchedResultsController Delegate Extension
extension FavoritesViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerWillChangeContent")
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .insert:
      print("*** NSFetchedResultsChangeInsert (object)")
      tableView.insertRows(at: [newIndexPath!], with: .fade)
      
    case .delete:
      print("*** NSFetchedResultsChangeDelete (object)")
      tableView.deleteRows(at: [indexPath!], with: .fade)
      
    case .update:
      print("*** NSFetchedResultsChangeUpdate (object)")
      if let cell = tableView.cellForRow(at: indexPath!) as? SavedSingleTableViewCell {
        let singleGirl = controller.object(at: indexPath!) as! SingleGirl
        cell.configure(for: singleGirl)
      }
      
    case .move:
      print("*** NSFetchedResultsChangeMove (object)")
      tableView.deleteRows(at: [indexPath!], with: .fade)
      tableView.insertRows(at: [newIndexPath!], with: .fade)
      
    @unknown default:
        fatalError("Unhandled switch case of NSFetchedResultsChangeType")
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      print("*** NSFetchedResultsChangeInsert (section)")
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      print("*** NSFetchedResultsChangeDelete (section)")
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .update:
      print("*** NSFetchedResultsChangeUpdate (section)")
    case .move:
      print("*** NSFetchedResultsChangeMove (section)")
    @unknown default:
        fatalError("Unhandled switch case of NSFetchedResultsChangeType")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerDidChangeContent")
    tableView.endUpdates()
  }
}
