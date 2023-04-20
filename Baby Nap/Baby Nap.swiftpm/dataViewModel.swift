//
//  dataViewModel.swift
//  Baby Nap
//
//  Created by Nibras Fitri Zuhra on 19/04/23.
//

import Foundation

class DataViewModel: ObservableObject {
    private var defaults = UserDefaults.standard
    
    private let key = "childData"
    
    @Published var childData: [DataModel] = []
    
    init() {
        self.childData = getAll()
    }
    
    func getAll() -> [DataModel] {
        if let data = defaults.data(forKey: key),
           let childs = try? JSONDecoder().decode([DataModel].self, from: data) {
            return childs
        }
        return []
    }
    
    private func update(newValue: [DataModel]) {
        if let data = try? JSONEncoder().encode(newValue) {
            defaults.set(data, forKey: key)
        }
    }
    
    func addChild(_ child: DataModel) {
        if childData.isEmpty {
            childData.append(child)
            update(newValue: childData)
        }
    }
    
    func reset() {
        update(newValue: [])
    }
    
    func removeChild(id: String) {
        childData.removeAll()
        self.childData = childData
        update(newValue: childData)
    }
}
