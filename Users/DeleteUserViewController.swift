//
//  DeleteUserViewController.swift
//  Users
//
//  Created by Kurt McMahon on 10/10/18.
//  Copyright © 2018 Northern Illinois University. All rights reserved.
//

import UIKit

class DeleteUserViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public var urlString: String = "https://reqres.in/api/users"

    // MARK: - Outlets
    
    @IBOutlet weak var idPickerView: UIPickerView!
 
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - DeleteUserViewController methods
    
    @IBAction func userSelected(_ sender: UIButton) {
        
        // Get the selected row of the picker view
        let id = idPickerView.selectedRow(inComponent: 0) + 1
        print("the id is \(id)")
        let realUrlString: String = "\(urlString)/\(id)"
        
        // Try to delete the user with the selected id
        
        guard let url = URL(string: realUrlString) else {
            // Perform some error handling
            print("Invalid URL string")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // If response code was not 204, print error to console
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse!.statusCode == 404 {
                print("Error 404 User not found! \(error!)")
            } else if httpResponse!.statusCode != 204 {
                print("Error invalid response! \(error!)")
            } else if (data == nil && error != nil) {
                print("Error! \(error!)")
            } else {
                // Display alert in main thread
                DispatchQueue.main.async {
                    self.presentAlert(title: "User Removed", message: "User \(id) has been deleted!")
                }
            }
        }
        task.resume()
        
        // Else, display "user deleted" alert
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 25
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
}
