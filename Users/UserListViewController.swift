//
//  UserListViewController.swift
//  Users
//
//  Created by Kurt McMahon on 10/10/18.
//  Copyright © 2018 Northern Illinois University. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {

    // MARK: - Properties
    
    var users = [User]()
    var urlString: String = "https://reqres.in/api/users?page=1&per_page=12"
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! DetailViewController
                controller.detailItem = users[indexPath.row]
                // Pass other objects to controller as needed
            }
        }
    }
    
    // MARK: - UserListViewController methods
    
    func populateTable() {
        
        // Download data for all users, decode JSON,
        
        guard let url = URL(string: urlString) else {
            // Perform some error handling
            print("Invalid URL string")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse!.statusCode == 404 {
                // If response code was 404, display "user not found" alert
                print("Error 404 User not found! \(error!)")
            } else if httpResponse!.statusCode != 200 {
                print("Error invalid response! \(error!)")
            } else if (data == nil && error != nil) {
                print("Error! \(error!)")
            } else {
                do {
                    let resp = try JSONDecoder().decode(UserData.self, from: data!)
                    
                    self.users = resp.data
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("JSON decoding failed, data: \(data!.description) \(data!)")
                }
            }
        }
        task.resume()
        
        // add objects to array, reload table view
    }

    // MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User Cell", for: indexPath)

        // Configure the cell...
        let user = users[indexPath.row]
        cell.textLabel?.text = "\(user.lastName), \(user.firstName)"

        return cell
    }

}
