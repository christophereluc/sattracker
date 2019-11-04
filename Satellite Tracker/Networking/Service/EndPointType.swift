//
//  EndPointType.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 11/2/19.
//  https://github.com/Mackis/NetworkLayer/blob/master/NetworkLayer/Networking/Service/EndPointType.swift

import Foundation

//Protocol that defines the 3 parts of an API used in the application:  baseURL, path, and task that appends necessary params
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var task: HTTPTask { get }
}
