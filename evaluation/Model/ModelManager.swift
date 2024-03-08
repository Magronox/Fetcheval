//
//  ModelManager.swift
//  evaluation
//
//  Created by Amir Bas on 3/6/24.
//

import UIKit

struct ModelManager{
    func fetchData(completion: @escaping ([DataModel]?) -> Void) {
        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else {
            completion(nil) // Call completion with nil if URL is invalid
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil) // Call completion with nil if there's an error
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                completion(nil) // Call completion with nil if response is not successful
                return
            }
            
            guard let jsonData = data else {
                print("No data received")
                completion(nil) // Call completion with nil if no data is received
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([DataModel].self, from: jsonData)
                let filteredItems = decodedData.filter { item in
                    return !(item.name?.isEmpty ?? true)
                }
                let sortedItems = filteredItems.sorted { item1, item2 in
                    if item1.listId == item2.listId {
                        // If listId is the same, compare by name
                        return item1.name ?? "" < item2.name ?? ""
                    } else {
                        // Otherwise, compare by listId
                        return item1.listId < item2.listId
                    }
                }
                completion(sortedItems) // Call completion with sorted and filtered items
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil) // Call completion with nil if decoding fails
            }
        }
        
        dataTask.resume()
    }
}
