//
//  PersonVC.swift
//  TestSunSystem
//
//  Created by Nadaf on 28/01/19.
//  Copyright © 2019 Nadaf. All rights reserved.
//

import UIKit

class PersonVC: BaseViewController {
    
    @IBOutlet weak var personTableView: UITableView!
    
    
    var person:[Person] = [Person]()
    
    
    override func viewDidLoad() {
        
        self.getPersonListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
   // MARK: Web Service
    
    func getPersonListAPI()  {
        
        self.showActivityIndicatorWithMessage(message: NSLocalizedString("Loading", comment: ""))
        
        WebServiceManager.sharedInstance.postRequestWithEndpoint(endpoint: Utilities.baseUrl(withEndPoints: Constats.kList_API)!, parameters: ["emailId" : "mrnadaf2010@gmail.com"], headers: [:]) { (error, response) in
            self.stopActivityIndicator()
            
            if let loadError =  error{
                
                print(loadError)
            }else if let personsArray = response{
                var persons = [Person]()
                var person = Person()
                
                
                let JSON = (personsArray as! NSDictionary).value(forKey: "items")as! NSArray
                
                for i in JSON{
                    
                    person = Person()
                    
                    if let obj = i as? NSDictionary{
                        
                        if let email = obj["emailId"] as? String{
                            person.emailId = email
                        }
                        
                        if let lastName =  obj["lastName"] as? String{
                            
                            person.lastName = lastName
                        }
                        if let firstName = obj["firstName"] as? String{
                            
                            person.firstName = firstName
                        }
                        if let image = obj["imageUrl"] as? String{
                            
                            person.imageUrl = image
                        }
                        
                    }
                    persons.append(person)
                }
                self.person = persons
                print(self.person)
                
                self.personTableView.reloadData()
            }
        }
    }
    
}

// MARK: TableView Datasource

extension PersonVC : UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.person.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "PersonTableViewCell"
        
        let cell : PersonTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PersonTableViewCell
        
        cell.configureCell(person:self.person[indexPath.row])
        
        return cell
        
    }
}
