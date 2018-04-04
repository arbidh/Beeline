 //
//  ViewController.swift
//  BeelineCodingChallenge
//
//  Created by Arbi on 1/14/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import UIKit

class TournamentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = TournamentsViewModel()
    let reuseID = "TournamentCell"
    let apiSvc = APIServices()

  
    
    func registerTournamentCell(){
        let unib = UINib(nibName:reuseID, bundle: nil)
        tableView.register(unib, forCellReuseIdentifier: reuseID)
    }
    
    func setupView(){
        registerTournamentCell()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        apiSvc.apiServiceDelegete = self
    
    }
    @IBAction func participateInTournament(_ sender: Any) {
        viewModel.participateInTournament(id: viewModel.selectedTournamentID)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTournamentsDataFromAPI()
    }
    
    func fetchTournamentsDataFromAPI(){
        let token = DAKeychain.shared["token"]
        if token != nil
        {
            apiSvc.apiRequestWithType(type: .Tournament)
        }
        else{
            apiSvc.httpMethod = .post
            apiSvc.apiRequestWithType( type: .Token)
        }
        
    }
    @IBAction func logout(_ sender: Any) {
        apiSvc.invalidateToken()
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        apiSvc.invalidateToken()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension TournamentsViewController:APIServiceProtocol{
    func success(data: [Tournament]?) {
        DispatchQueue.main.async {

            self.viewModel.listOfTournaments = data
            self.tableView.reloadData()
        }
    }
    
    func fail(error: Error) {
         print(error.localizedDescription)
    }
    
}

extension TournamentsViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tournaments = viewModel.listOfTournaments{
            return tournaments.count
        }
        else{
            return 0
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? TournamentsDetailViewController else{
            print("Could not load TournamentDetailViewController")
            return
        }
        detailViewController.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //fetch the specific tournament with id
        tableView.deselectRow(at: indexPath, animated: false)
        if let listOfTournaments = viewModel.listOfTournaments{
            let tournament = listOfTournaments[indexPath.row]
            viewModel.selectedTournament = tournament
            performSegue(withIdentifier: "detail", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tournamentCell = tableView.dequeueReusableCell(withIdentifier:reuseID, for: indexPath) as? TournamentCell else{
                return UITableViewCell()
        }
        if let tournaments = viewModel.listOfTournaments {
            tournamentCell.name.text = tournaments[indexPath.row].attributes.name
            tournamentCell.id.text = tournaments[indexPath.row].id
            tournamentCell.type.text = tournaments[indexPath.row].type
            tournamentCell.date.text = tournaments[indexPath.row].attributes.date
        }
        return tournamentCell
    }
}

