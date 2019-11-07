//
//  NetworkRouter.swift
//  Satellite Tracker
//
//  Created by Christopher Luc on 11/2/19.
//  Based off of https://github.com/Mackis/NetworkLayer/blob/master/NetworkLayer/Networking/Service/NetworkROUTER.swift

import Foundation

//Typealiases to make methods more readable
public typealias Parameters = [String:Any]
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()


//MARK: Router class that would handle setting up all API requests.  NetworkManager instanciates it
class Router<EndPoint: EndPointType> {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        print("route:", route)
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        //MARK make this dynamic if we end up needing different methods
        request.httpMethod = "GET"
        
        //MARK add other task types if added here
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .requestWithParameters(let urlParameters):
            do {
                try encode(urlRequest: &request, urlParameters: urlParameters)
            } catch {
                throw error
            }
        }
        return request
    }
    
    
}

//Mark extension to the router that adds in encoding capabilities
extension Router {
    
    public func encode(urlRequest: inout URLRequest, urlParameters: Parameters?) throws {
        //if no parameters passed in, bail early
        guard let urlParameters = urlParameters else { return }
        
        if var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false), !urlParameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            //Append all query params to the URL
            for (key,value) in urlParameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
    }
}
