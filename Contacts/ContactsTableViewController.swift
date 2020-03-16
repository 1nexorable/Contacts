//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Guest on 16.03.2020.
//  Copyright © 2020 Guest. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {

    var contacts: [Contact] = []
    var fetchedResultsController: NSFetchedResultsController<Contact>!
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    func updateContacts() {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            contacts = fetchedResultsController.fetchedObjects!
        } catch let error as NSError {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateContacts()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        


    }

    
   


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell
        cell.fullNameLabel.text = contacts[indexPath.row].name! + " " + contacts[indexPath.row].patronymicName! + " " + contacts[indexPath.row].familyName!
        cell.thumbnailImageView.image = UIImage(data: contacts[indexPath.row].image! as Data)

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ContactsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        contacts.remove(at: indexPath.row)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        contacts = controller.fetchedObjects as! [Contact]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
