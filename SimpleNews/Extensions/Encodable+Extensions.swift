//
//  Encodable+Extensions.swift
//  FFLASHH
//
//  Created by Mina Malak on 22/05/2021.
//

import UIKit

extension Encodable {
    
    // this would try to encode an encodable type and decode it into an a dictionary
    var dictionary : [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return [:] }
        return json
    }
    
    // this would try to encode an encodable type and decode it into an array of dictionaries
    var dictionaries: [[String: Any]] {
        guard let data = try? JSONEncoder().encode(self) else { return [] }
        return (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]] ?? []
    }
    
    // this would try to encode an encodable type and decode it into a dictionary with dictionaries as its value
    var nestedDictionaries: [String: [String: Any]] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: [String: Any]] ?? [:]
    }
    
    // this will return only the properties that are referring to a nested structure/classe
    var nestedDictionariesOnly: [String: [String: Any]] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]).compactMapValues { $0 as? [String:Any] }
    }
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            if let value = (value as? Int), value % 1 == 0 {
                output +=  "\"\(key)\":\(value),"
            } else if let value = (value as? Double) {
                output +=  "\"\(key)\":\(value),"
            } else if let value = (value as? Dictionary) {
                output +=  "\"\(key)\":\"\(String(describing: value.queryString))\","
            } else {
                output +=  "\"\(key)\":\"\(value)\","
            }
            
        }
        output = String(output.dropLast())
        return output
    }
}
