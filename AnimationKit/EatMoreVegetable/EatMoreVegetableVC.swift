//
//  ViewController.swift
//  EatMoreVegetable
//
//  Created by Brian Advent on 26/02/2017.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import UIKit
import CoreData

class EatMoreVegetableVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var foodItems = [Food]()
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Vegetables")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    var moc: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        moc = persistentContainer.viewContext
        self.tableView.dataSource = self
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveContext()
    }

    func loadData() {
        let foodRequest: NSFetchRequest<Food> = Food.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        foodRequest.sortDescriptors = [sortDescriptor]
        do {
            try foodItems = moc.fetch(foodRequest)

        } catch {
            print("Could not load data")
        }
        self.tableView.reloadData()
    }

    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        let foodItem = Food(context: moc)
        foodItem.added = Date()

        if sender.tag == 0 {
            foodItem.type = "Fruit"
        } else {
            foodItem.type = "Vegetable"
        }
        saveContext()
        loadData()
    }
}

extension EatMoreVegetableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let foodItem = foodItems[indexPath.row]
        let foodType = foodItem.type
        cell.textLabel?.text = foodType
        let foodDate = foodItem.added!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy, hh:mm"
        cell.detailTextLabel?.text = dateFormatter.string(from: foodDate)
        if foodType == "Fruit" {
            cell.imageView?.image = UIImage(named: "Apple")
        } else {
            cell.imageView?.image = UIImage(named: "Salad")
        }

        return cell
    }
}

// MARK: - Core Data Saving support
extension EatMoreVegetableVC {
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

