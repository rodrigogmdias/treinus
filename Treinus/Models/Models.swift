// Models.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case Error(Int, Data?, Error)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> T {
        let key = discriminator;
        if let decoder = decoders[key] {
            return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0) }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return source.int32Value as! T;
        }
        if T.self is Int64.Type && source is NSNumber {
            return source.int64Value as! T;
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }

        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject) -> Date in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int64 {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        } 

        // Decoder for [Geometry]
        Decoders.addDecoder(clazz: [Geometry].self) { (source: AnyObject) -> [Geometry] in
            return Decoders.decode(clazz: [Geometry].self, source: source)
        }
        // Decoder for Geometry
        Decoders.addDecoder(clazz: Geometry.self) { (source: AnyObject) -> Geometry in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Geometry()
            instance.location = Decoders.decodeOptional(clazz: Location.self, source: sourceDictionary["location"] as AnyObject?)
            return instance
        }


        // Decoder for [Location]
        Decoders.addDecoder(clazz: [Location].self) { (source: AnyObject) -> [Location] in
            return Decoders.decode(clazz: [Location].self, source: source)
        }
        // Decoder for Location
        Decoders.addDecoder(clazz: Location.self) { (source: AnyObject) -> Location in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Location()
            instance.lat = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["lat"] as AnyObject?)
            instance.lng = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["lng"] as AnyObject?)
            return instance
        }


        // Decoder for [Photo]
        Decoders.addDecoder(clazz: [Photo].self) { (source: AnyObject) -> [Photo] in
            return Decoders.decode(clazz: [Photo].self, source: source)
        }
        // Decoder for Photo
        Decoders.addDecoder(clazz: Photo.self) { (source: AnyObject) -> Photo in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Photo()
            instance.height = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["height"] as AnyObject?)
            instance.width = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["width"] as AnyObject?)
            instance.photoReference = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photo_reference"] as AnyObject?)
            return instance
        }


        // Decoder for [Place]
        Decoders.addDecoder(clazz: [Place].self) { (source: AnyObject) -> [Place] in
            return Decoders.decode(clazz: [Place].self, source: source)
        }
        // Decoder for Place
        Decoders.addDecoder(clazz: Place.self) { (source: AnyObject) -> Place in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Place()
            instance.id = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?)
            instance.placeId = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["place_id"] as AnyObject?)
            instance.geometry = Decoders.decodeOptional(clazz: Geometry.self, source: sourceDictionary["geometry"] as AnyObject?)
            instance.scope = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["scope"] as AnyObject?)
            instance.rating = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["rating"] as AnyObject?)
            instance.vicinity = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vicinity"] as AnyObject?)
            instance.types = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["types"] as AnyObject?)
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            instance.photos = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["photos"] as AnyObject?)
            return instance
        }


        // Decoder for [ResponseApiMaps]
        Decoders.addDecoder(clazz: [ResponseApiMaps].self) { (source: AnyObject) -> [ResponseApiMaps] in
            return Decoders.decode(clazz: [ResponseApiMaps].self, source: source)
        }
        // Decoder for ResponseApiMaps
        Decoders.addDecoder(clazz: ResponseApiMaps.self) { (source: AnyObject) -> ResponseApiMaps in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ResponseApiMaps()
            instance.results = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["results"] as AnyObject?)
            return instance
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}