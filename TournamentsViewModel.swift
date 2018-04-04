//
//  TournamentsViewModel.swift
//  BeelineCodingChallenge
//
//  Created by Arbi on 1/15/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import Foundation
import UIKit

struct TournamentsViewModel{
    
    //fetch Tournments form API
    let apiSvc = APIServices()
    var listOfTournaments:[Tournament]?
    var selectedTournament:Tournament?
    var selectedTournamentID:String = ""

    func fetchSpecificTournament(id:String){
        apiSvc.requestID = selectedTournamentID
        apiSvc.httpMethod = .get
        apiSvc.apiRequestWithType(type: .SpecificTournament)
    }
    
    func participateInTournament(id:String){
        apiSvc.requestID = selectedTournamentID
        apiSvc.httpMethod = .post
        apiSvc.apiRequestWithType(type: .Participate)
    }
    
}

