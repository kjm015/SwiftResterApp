//
//  AddUserViewController.swift
//  Users
//
//  Created by Kurt McMahon on 10/10/18.
//  Copyright © 2018 Northern Illinois University. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    
    var urlString: String = "https://reqres.in/api/users"

    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var avatarUrlTextField: UITextField!
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    // MARK: - AddUserViewController methods
    
    @IBAction func saveUser(_ sender: Any) {
        
        // Make sure text fields are not empty
        
        if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty {
            return
        }
        
        // Create User object from text field text
        
        let user = User(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, avatar: avatarUrlTextField.text!)
        
        // Encode user to JSON like this:
        // let jsonData = try JSONEncoder().encode(user)
        
        do {
            let data = try JSONEncoder().encode(user)
            // Success – upload data to server using a URLSession uploadTask
            // Try to upload jsonData
            
            guard let url = URL(string: urlString) else {
                // Perform some error handling
                print("Invalid URL string")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.uploadTask(with: request, from: data) {
                (data, response, error) in
                
                let httpResponse = response as? HTTPURLResponse
                if httpResponse!.statusCode != 201 {
                    // If response code is not 201, print error to console
                    print("Unexpected HTTP response: \(httpResponse!.statusCode) \(error!)")
                } else {
                    // Else, display "user created" message in alert
                    do {
                        let resp = try JSONDecoder().decode(UserPostResponse.self, from: data!)
                        self.presentAlert(title: "User Created", message: "Your new user \(resp.lastName) has been created")
                    } catch {
                        print("The struggle is real: JSON decoding failed")
                    }
                }
            }
            task.resume()
        } catch {
            print("Error: Unable to encode new user as JSON data")
        }
    }

    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
