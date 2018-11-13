//
//  GetSingleUserViewController.swift
//  Users
//
//  Created by Kurt McMahon on 10/10/18.
//  Copyright © 2018 Northern Illinois University. All rights reserved.
//

import UIKit

class GetSingleUserViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var urlString: String = "https://reqres.in/api/users"

    // MARK: - Outlets
    
    @IBOutlet weak var idPickerView: UIPickerView!
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail" {
            let controller = segue.destination as! DetailViewController
            
            // Set properties of controller as needed to pass objects
        }
    }

    // MARK: - GetSingleUserViewController methods
    
    @IBAction func userSelected(_ sender: UIButton) {
        
        // Get the selected row of the picker view
        
        let id = idPickerView.selectedRow(inComponent: 0) + 1
        print("the id is \(id)")
        let realUrlString: String = "\(urlString)/\(id)"
        
        // Try to download the data for the user with the selected id
        
        guard let url = URL(string: realUrlString) else {
            // Perform some error handling
            print("Invalid URL string")
            return
        }
        
        //var request = URLRequest(url: url)
        //request.httpMethod = "GET"
        //request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                // Decode JSON and manually call performSegue(withIdentifier: "Show Detail", sender: self)
                if let s = String(data: data!, encoding: String.Encoding.utf8) {
                    print(s)
                }
                
                do {
                    let resp = try JSONDecoder().decode(GetResponseData.self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.presentAlert(title: "User Retrieved", message: "Your user \(resp.data.first_name) \(resp.data.last_name) has been found!")
                    }

                } catch {
                    print("JSON decoding failed, data: \(data!.description) \(data!)")
                }
                
                // Display alert in main thread
            }
        }
        task.resume()
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
