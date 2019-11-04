//
//  SatelliteEndpoint.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 11/2/19.
//

import Foundation
import CoreLocation

//API Constants
struct SatelliteApiConstants {
    static let URL = "https://ham-satellite.herokuapp.com/"
    static let ALTITUDE_PARAM = "alt"
    static let LONGITUDE_PARAM = "lng"
    static let LATITUDE_PARAM = "lat"
    static let NEARBY_PATH = "nearby"
    static let PASSES_PATH = "tracking"
}

//MARK: Enum that lists all possible API endpoints + required data to execute them
public enum SatelliteApi {
    case nearby(location: CLLocation)
    case radioPasses(location: CLLocation)
}

//MARK: Extension of the SatelliteApi enum that implements EndpointType protocol.
extension SatelliteApi: EndPointType {
    
    //Creates the base url used by the endpoint
    var baseURL: URL {
        guard let url = URL(string: SatelliteApiConstants.URL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    //Adds in the path to the URL
    var path: String {
        switch self {
        case .nearby:
            return SatelliteApiConstants.NEARBY_PATH
        case .radioPasses:
            return SatelliteApiConstants.PASSES_PATH
        }
    }
    
    //Configures the params on the URL (defined by the SatelliteApi enum)
    var task: HTTPTask {
        switch self {
        case .radioPasses(let location):
            //MARK Should match nearby in params
            return .request
        case .nearby(let location):
            return .requestWithParameters(urlParameters: [SatelliteApiConstants.LATITUDE_PARAM : location.coordinate.latitude,
                                                      SatelliteApiConstants.LONGITUDE_PARAM : location.coordinate.longitude,
                                                      SatelliteApiConstants.ALTITUDE_PARAM : location.altitude])
        }
    }
}
