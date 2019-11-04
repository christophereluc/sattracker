//
//  HttpTask.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 11/2/19.
//  Adapted from https://github.com/Mackis/NetworkLayer/blob/master/NetworkLayer/Networking/Service/HTTPTask.swift

import Foundation

//MARK: Declares the possible cases:  either a basic request, or a request that contains URL params
public enum HTTPTask {
    case request
    case requestWithParameters(urlParameters: Parameters?)
}
