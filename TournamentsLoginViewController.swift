//
//  TournamentsLoginViewController.swift
//  BeelineCodingChallenge
//
//  Created by Arbi Derhartunian on 1/22/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import UIKit

class TournamentsLoginViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let apiSvc = APIServices()
    override func viewDidLoad() {
    
        super.viewDidLoad()
        spinner.isHidden = true
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.isHidden = true
    }
    
    @IBAction func login(_ sender: Any) {
        apiSvc.invalidateToken()
        let token = DAKeychain.shared["token"]
        
        if token == nil{
            apiSvc.httpMethod = .post
            apiSvc.apiServiceDelegete = self
            spinner.isHidden = false
            spinner.startAnimating()
            apiSvc.apiRequestWithType( type: .Token)
            
        }
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
     
        
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TournamentsLoginViewController: APIServiceProtocol{
    
    func success(data: [Tournament]?) {
        
        DispatchQueue.main.async {[weak self] in
            self?.spinner.stopAnimating()
            guard let tournamentsViewController = self?.storyboard?.instantiateViewController(withIdentifier: "TournamentsViewController")
                else{
                    print("TournamentsViewController is nil")
                    return
            }
            let nav = UINavigationController(rootViewController: tournamentsViewController)
            self?.present(nav, animated: true, completion: nil)
            
        }
        
    }
    
    func fail(error: Error) {
        print("Getting Token Failed with error" + error.localizedDescription)
    }
    
}

