//
//  APIService.swift
//  BeelineCodingChallenge
//
//  Created by Arbi on 1/15/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import Foundation

let apiURL:String = "https://damp-chamber-22487.herokuapp.com/api/v1"
let tokenAppiEndPoint:String = "/authentications/tokens"
let tournamentsEndPoint:String = "/tournaments"
let specificTournamentEndPoint:String = "/tournaments/"
let participationEndPoint:String = "/participation"

struct TokenData{
    var token:String
}

enum HTTPMethod:String{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
   
}
enum APIReponseType{
    case string
    case json
    case other
}
enum requestType{
    case Token
    case Tournament
    case SpecificTournament
    case Participate
    
}
protocol APIServiceProtocol:class{
    func success(data:[Tournament]?)
    func fail(error:Error)
}


class APIServices{

    weak var apiServiceDelegete:APIServiceProtocol?
    var requestID:String?
    var httpMethod:HTTPMethod = .get
    var token:String?
    
    func invalidateToken(){
        self.token = nil
        DAKeychain.shared["token"] = nil
    }
    
    //handles success responses coming from api
    func handleSuccessResponseWithType(type:requestType, responseData:Data){
            
                let token = DAKeychain.shared["token"]
                if token == nil{
                    guard let tokenFromApi:String = String(data: responseData, encoding: String.Encoding.utf8) else {
                        print("Serialization to Token String failed")
                        return
                    }
                    //saving token to keychain
                    DAKeychain.shared["token"] = tokenFromApi
                    self.token = tokenFromApi
                    self.apiServiceDelegete?.success(data:nil)
                    
                }

                else{
                    if type == .Tournament || type == .SpecificTournament{
                        do{
                            let tournaments = try JSONDecoder().decode(Tournaments.self, from: responseData)
                            
                            let listOfTournaments:[Tournament] = tournaments.data
                            self.apiServiceDelegete?.success(data: listOfTournaments)
                        }catch{
                
                        print("error model was nil")
                    }
                }
            }
        }
 
    //handles error responses
    func handleErrorResponse(error:Error , type:requestType){
           print("Error has occured in getting the Token" + error.localizedDescription)
            self.apiServiceDelegete?.fail(error: error)
        
    }

//builds the correct url for each endpoint
func buildURLForType(type:requestType)->URLRequest?{
    guard let tournamentsURL = URL(string:apiURL+tournamentsEndPoint) else{
        print("Tournaments URL was NIL")
        return nil
    }
    guard let tokenURL = URL(string: apiURL+tokenAppiEndPoint) else{
        print("Token URL was NIL")
        return nil
    }
    if let id = requestID{
    
        if let url = String(apiURL + specificTournamentEndPoint + id ).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
        guard let specificTournamentsURL = URL(string:url ) else{
            print ("Specific Tournament URL was NIL")
            return nil
            }
            return URLRequest(url:specificTournamentsURL)
        }
        guard let participateInTournament = URL(string:apiURL + tournamentsEndPoint + "/" + id + participationEndPoint) else{
            print ("Specific Tournament URL was NIL")
            return nil
        }
        return URLRequest(url:participateInTournament)

    }
    if  type  == .Token{
        return URLRequest(url:tokenURL)
    }
    return URLRequest(url:tournamentsURL  )
}
    //Builds the header for the url Request and returns
    func getURLRequest( type:requestType) -> URLRequest?{
        guard var urlRequest = buildURLForType(type:type) else{
            print("urlRequest was nil")
            return nil
        }
        let token = DAKeychain.shared["token"]
        if token != nil{
            if let token = token {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.addValue(token, forHTTPHeaderField: "X-Acme-Authentication-Token")
            }
        }
        return urlRequest
    }
    // after API returns response this method calls the delegate for each response
    func delegateResponseWithType(type:requestType,responseData:Data?){
        if let responseData = responseData{
            switch(type){
                case .Tournament:
                    self.handleSuccessResponseWithType(type: .Tournament, responseData: responseData)
                case .SpecificTournament:
                    self.handleSuccessResponseWithType(type: .SpecificTournament, responseData:responseData )
            
                case .Participate:
                    self.handleSuccessResponseWithType(type: .Participate, responseData: responseData)
                case .Token:
                    self.handleSuccessResponseWithType(type: .Token ,responseData: responseData)
            }
        }
    }
    func handleAPIErrorCode(code:Int){
        switch code {
        case 401:
            print("Unauthorized -- Invalid or missing authentication token")
        case 404:
            print("Not Found -- The requested resource was not found")
        case 500:
            print("Internal Server Error -- We had a problem with our server. Try again later.")
        default:
            print("An error occured while makeing the API request")
        }
    }
    
    //Here the response code is handles
    func handleResponseCode(responseData:Data?,
                            error:Error?,
                            response:URLResponse?,
                            type:requestType){
        
        if let responseData = responseData{
            guard let response = response as? HTTPURLResponse else {
                print("Could not cast the API response to HTTPURLResponse")
                return
            }
            if response.statusCode == 200 || response.statusCode == 201 {
                if error == nil{
                    delegateResponseWithType(type:type , responseData: responseData)
                }
            }
            else{
                if let error = error {
                    handleErrorResponse(error: error, type: type)
                }
                else{
                    handleAPIErrorCode(code: response.statusCode)
                }
            }
        }
    }
    func apiRequestWithType(type: requestType){
        //get a URLrequest for the given requestType
        guard var urlRequest = getURLRequest(type: type) else{
            return
        }
        urlRequest.httpMethod = httpMethod.rawValue
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: urlRequest, completionHandler: {
                [weak self] (
                responseData,
                resp,
                error)
                in
                self?.handleResponseCode(responseData:
                                        responseData,
                                        error: error,
                                        response: resp,
                                        type: type)
                }).resume()
            }
        }
    }
