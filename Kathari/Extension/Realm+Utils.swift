//
//  Realm+Utils.swift
//  Boiler
//
//  Created by Oluwadamisi Pikuda on 24/06/2020.
//  Copyright © 2020 Damisi Pikuda. All rights reserved.
//

//import RealmSwift
//
//extension RealmSwift.Object {
//    // swiftlint:disable nesting
//    struct PrimaryKey: Equatable {
//        enum KeyType: Equatable {
//            case int(Int)
//            case string(String)
//
//            var rawValue: Any {
//                switch self {
//                case .int(let int):
//                    return int
//                case .string(let string):
//                    return string
//                }
//            }
//        }
//
//        let value: KeyType
//        init(_ int: Int) {
//            value = .int(int)
//        }
//        init(_ string: String) {
//            value = .string(string)
//        }
//    }
//
//    var primaryKeyValue: Any? {
//        guard let primaryKeyName = type(of: self).primaryKey() else {
//            return nil
//        }
//
//        return self[primaryKeyName]
//    }
//
//    var primaryKey: PrimaryKey? {
//        switch primaryKeyValue {
//        case let int as Int:
//            return PrimaryKey(int)
//        case let string as String:
//            return PrimaryKey(string)
//        case nil:
//            return nil
//        default:
//            fatalError("The docs say this must be a `String` or an `Int`")
//        }
//    }
//}
//
//extension Realm {
//    public func safeWrite(_ block: (() throws -> Void)) throws {
//        if isInWriteTransaction {
//            try block()
//        } else {
//            try write(block)
//        }
//    }
//}
//
//extension Results {
//    func toArray() -> [Element] {
//        return compactMap { $0 }
//    }
//}
//
//extension LinkingObjects {
//    func toArray<T>() -> [T] {
//        return compactMap { $0 as? T }
//    }
//}
//
//extension List {
//    func toArray() -> [Element] {
//        return compactMap { $0 }
//    }
//}
