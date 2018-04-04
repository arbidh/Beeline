//
//  TournamentsDetailViewController.swift
//  BeelineCodingChallenge
//
//  Created by Arbi Derhartunian on 1/22/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import UIKit

class TournamentsDetailViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    let apiSvc = APIServices()
    var viewModel:TournamentsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else{
         return
        }
        guard let tournament = viewModel.selectedTournament else{
         return
        }
        apiSvc.httpMethod = .get
        apiSvc.requestID = tournament.id
        apiSvc.apiServiceDelegete = self
        apiSvc.apiRequestWithType(type: .SpecificTournament)
        
        //load the selected
        navItem.title = tournament.id
        createdAtLabel.text = tournament.attributes.date
        typeLabel.text = tournament.type
        nameLabel.text = tournament.attributes.name

        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinTournament(_ sender: Any) {
        apiSvc.apiRequestWithType(type: .Participate)
        DispatchQueue.main.async {[weak self] in
            self?.showAlert()
        }
        //this should be in success block but I get 404
      
    }
    func showAlert(){
        
        let alertController = UIAlertController(title: "Joining Tournament", message: "Welcome you Successfully Joined\(viewModel?.selectedTournament?.id ?? " ")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension TournamentsDetailViewController: APIServiceProtocol
{
    func success(data: [Tournament]?) {
        
        //since the data is nil because of the 404 error
        //I load the selected Tournament
        print("SUCCESS")
        
    }
    func fail(error: Error) {
        print("FAIL")
    }
        
}
