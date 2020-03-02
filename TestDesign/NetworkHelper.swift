//
//  Service.swift
//  TestDesign
//
//  Created by Ivan Chernetskiy on 01.03.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//
import Foundation
import UIKit


struct Place: Codable {
    let status: Int
    let result: [Result]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case result = "Result"
    }
}


struct Result: Codable {
    let objectID, title, resultDescription: String
    let imageURL: String
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case objectID = "ObjectId"
        case title = "Title"
        case resultDescription = "Description"
        case imageURL = "ImageUrl"
        case latitude = "Latitude"
        case longitude
    }
}


class NetworkHelper {
    
    private let path = "http://zavtrakov.eurodir.ru/response.json"
    
    func fetchPlaces(completion: @escaping (([PlaceModel]) -> ())) {
        
        guard let url = URL(string: path) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let places = try decoder.decode(Place.self, from: data!)
                print(places)
                
                var res = [PlaceModel]()
                places.result.forEach { result in
                    let model = PlaceModel(name: result.title,
                                           description: result.resultDescription,
                                           image: result.imageURL,
                                           coordinates: (result.latitude, result.longitude))
                    res.append(model)
                }
                
                completion(res)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    func loadImage(with url: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
                completion(image)
        }.resume()
    }
}
