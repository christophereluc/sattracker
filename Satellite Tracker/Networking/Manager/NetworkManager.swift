//
//  NetworkManager.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 11/2/19.
//

import Foundation
import CoreLocation

enum Result {
    case success
    case failure(String)
}



struct NetworkManager {
    //MARK Instatiate router -- Can be multiple if we end up needing new api endpoitns
    let router = Router<SatelliteApi>()
    
    //MARK
    func getNearbySatellites(location: CLLocation, completion: @escaping (_ data: [Any]?,_ error: String?)->()){
        router.request(.nearby(location: location)) { data, response, error in
            //Error isn't nil; therefore network errors
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                //Check if we got a successful HTTP response
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, "Response data was null -- validate API correct")
                        return
                    }
                    do {
                        //MARK: This is where the json object should be converted into a data model.  Still a TODO
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        
                        //MARK pass in data object into completion handler
                        completion(nil ,nil)
                    } catch {
                        completion(nil, "Error decoding data - \(error)")
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getNearbySatellites(id: Int, location: CLLocation, completion: @escaping (_ data: [Any]?,_ error: String?)->()){
        router.request(.nearby(location: location)) { data, response, error in
            //Error isn't nil; therefore network errors
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                //Check if we got a successful HTTP response
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, "Response data was null -- validate API correct")
                        return
                    }
                    do {
                        //MARK: This is where the json object should be converted into a data model.  Still a TODO
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        
                        //MARK pass in data object into completion handler
                        completion(nil ,nil)
                    } catch {
                        completion(nil, "Error decoding data - \(error)")
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getBeacons(id: Int, completion: @escaping (_ data: [Any]?,_ error: String?)->()){
        router.request(.beacons) { data, response, error in
            //Error isn't nil; therefore network errors
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                //Check if we got a successful HTTP response
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, "Response data was null -- validate API correct")
                        return
                    }
                    do {
                        //MARK: This is where the json object should be converted into a data model.  Still a TODO
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        
                        //MARK pass in data object into completion handler
                        completion(nil ,nil)
                    } catch {
                        completion(nil, "Error decoding data - \(error)")
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    //Checks status code.  Only concerned with 200-299 at this point
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result {
        switch response.statusCode {
        case 200...299:
            return .success
        default:
            return .failure("Network Request Failed -- status code outside valid range: \(response.statusCode)")
        }
    }
}
