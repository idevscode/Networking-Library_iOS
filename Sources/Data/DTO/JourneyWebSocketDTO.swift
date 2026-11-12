//
//  JourneyWebSocketDTO.swift
//  Data
//
//  Created by SafeCircle Team on 18/10/26.
//

import Foundation
import Domain

// MARK: - Generic WebSocket Envelope
struct JourneyWebSocketEnvelopeDTO: Decodable {
    let event: String
    let journeyId: String?
    let rawData: Data?

    enum CodingKeys: String, CodingKey {
        case event
        case journeyId = "journey_id"
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.event = try container.decode(String.self, forKey: .event)
        self.journeyId = try container.decodeIfPresent(String.self, forKey: .journeyId)

        if container.contains(.data) {
            // Encode data sub-tree back to Data so specific event DTO can decode it
            let rawSubDecoder = try container.superDecoder(forKey: .data)
            let jsonValue = try JSONValue(from: rawSubDecoder)
            self.rawData = try JSONEncoder().encode(jsonValue)
        } else {
            self.rawData = nil
        }
    }
}

// MARK: - Helper to capture arbitrary JSON sub-tree
enum JSONValue: Codable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let boolVal = try? container.decode(Bool.self) {
            self = .bool(boolVal)
        } else if let doubleVal = try? container.decode(Double.self) {
            self = .number(doubleVal)
        } else if let strVal = try? container.decode(String.self) {
            self = .string(strVal)
        } else if let arrayVal = try? container.decode([JSONValue].self) {
            self = .array(arrayVal)
        } else if let dictVal = try? container.decode([String: JSONValue].self) {
            self = .object(dictVal)
        } else {
            self = .null
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let s): try container.encode(s)
        case .number(let n): try container.encode(n)
        case .bool(let b): try container.encode(b)
        case .object(let o): try container.encode(o)
        case .array(let a): try container.encode(a)
        case .null: try container.encodeNil()
        }
    }
}

// MARK: - Snapshot Event DTO
struct JourneySnapshotEventDTO: Decodable {
    let journeyId: String?
    let status: String?
    let startedAt: String?
    let endedAt: String?
    let start: JourneyWaypointDTO?
    let end: JourneyWaypointDTO?
    let plannedRoute: [RouteCoordinateDTO]?
    let isDeviated: Bool?
    let deviationCount: Int?
    let pingCount: Int?
    let lastLocation: JourneyLastLocationDTO?

    enum CodingKeys: String, CodingKey {
        case journeyId = "journey_id"
        case status
        case startedAt = "started_at"
        case endedAt = "ended_at"
        case start
        case end
        case plannedRoute = "planned_route"
        case isDeviated = "is_deviated"
        case deviationCount = "deviation_count"
        case pingCount = "ping_count"
        case lastLocation = "last_location"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.journeyId = try? container.decodeIfPresent(String.self, forKey: .journeyId)
        self.status = try? container.decodeIfPresent(String.self, forKey: .status)
        self.startedAt = try? container.decodeIfPresent(String.self, forKey: .startedAt)
        self.endedAt = try? container.decodeIfPresent(String.self, forKey: .endedAt)
        self.start = try? container.decodeIfPresent(JourneyWaypointDTO.self, forKey: .start)
        self.end = try? container.decodeIfPresent(JourneyWaypointDTO.self, forKey: .end)
        self.plannedRoute = try? container.decodeIfPresent([RouteCoordinateDTO].self, forKey: .plannedRoute)
        
        if let bDev = try? container.decode(Bool.self, forKey: .isDeviated) {
            self.isDeviated = bDev
        } else if let iDev = try? container.decode(Int.self, forKey: .isDeviated) {
            self.isDeviated = (iDev != 0)
        } else {
            self.isDeviated = nil
        }
        
        if let iDevCount = try? container.decode(Int.self, forKey: .deviationCount) {
            self.deviationCount = iDevCount
        } else if let sDevCount = try? container.decode(String.self, forKey: .deviationCount), let i = Int(sDevCount) {
            self.deviationCount = i
        } else {
            self.deviationCount = nil
        }
        
        if let iPing = try? container.decode(Int.self, forKey: .pingCount) {
            self.pingCount = iPing
        } else if let sPing = try? container.decode(String.self, forKey: .pingCount), let i = Int(sPing) {
            self.pingCount = i
        } else {
            self.pingCount = nil
        }
        
        self.lastLocation = try? container.decodeIfPresent(JourneyLastLocationDTO.self, forKey: .lastLocation)
    }

    struct JourneyWaypointDTO: Decodable {
        let lat: Double?
        let lng: Double?
        let label: String?

        enum CodingKeys: String, CodingKey {
            case lat
            case lng
            case label
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let dLat = try? container.decode(Double.self, forKey: .lat) {
                self.lat = dLat
            } else if let sLat = try? container.decode(String.self, forKey: .lat), let d = Double(sLat) {
                self.lat = d
            } else {
                self.lat = nil
            }

            if let dLng = try? container.decode(Double.self, forKey: .lng) {
                self.lng = dLng
            } else if let sLng = try? container.decode(String.self, forKey: .lng), let d = Double(sLng) {
                self.lng = d
            } else {
                self.lng = nil
            }

            self.label = try? container.decodeIfPresent(String.self, forKey: .label)
        }

        func toEntity() -> JourneyLiveWaypointEntity {
            JourneyLiveWaypointEntity(
                lat: lat ?? 0.0,
                lng: lng ?? 0.0,
                label: label ?? ""
            )
        }
    }

    struct JourneyLastLocationDTO: Decodable {
        let lat: Double?
        let lng: Double?
        let accuracyM: Double?
        let recordedAt: String?

        enum CodingKeys: String, CodingKey {
            case lat
            case lng
            case accuracyM = "accuracy_m"
            case recordedAt = "recorded_at"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let dLat = try? container.decode(Double.self, forKey: .lat) {
                self.lat = dLat
            } else if let sLat = try? container.decode(String.self, forKey: .lat), let d = Double(sLat) {
                self.lat = d
            } else {
                self.lat = nil
            }

            if let dLng = try? container.decode(Double.self, forKey: .lng) {
                self.lng = dLng
            } else if let sLng = try? container.decode(String.self, forKey: .lng), let d = Double(sLng) {
                self.lng = d
            } else {
                self.lng = nil
            }

            if let dAcc = try? container.decode(Double.self, forKey: .accuracyM) {
                self.accuracyM = dAcc
            } else if let sAcc = try? container.decode(String.self, forKey: .accuracyM), let d = Double(sAcc) {
                self.accuracyM = d
            } else {
                self.accuracyM = nil
            }

            self.recordedAt = try? container.decodeIfPresent(String.self, forKey: .recordedAt)
        }

        func toEntity() -> JourneyLiveLastLocationEntity {
            JourneyLiveLastLocationEntity(
                lat: lat ?? 0.0,
                lng: lng ?? 0.0,
                accuracyM: accuracyM,
                recordedAt: recordedAt
            )
        }
    }

    func toEntity(fallbackId: String) -> JourneyLiveSnapshotEntity {
        JourneyLiveSnapshotEntity(
            journeyId: journeyId ?? fallbackId,
            status: status ?? "active",
            startedAt: startedAt ?? "",
            endedAt: endedAt,
            start: start?.toEntity(),
            end: end?.toEntity(),
            plannedRoute: plannedRoute?.map { $0.toEntity() } ?? [],
            isDeviated: isDeviated ?? false,
            deviationCount: deviationCount ?? 0,
            pingCount: pingCount ?? 0,
            lastLocation: lastLocation?.toEntity()
        )
    }
}

// MARK: - Location Event DTO
struct JourneyLocationEventDTO: Decodable {
    let lat: Double?
    let lng: Double?
    let accuracyM: Double?
    let speedMps: Double?
    let heading: Double?
    let batteryLevel: Int?
    let recordedAt: String?
    let isDeviated: Bool?
    let pingCount: Int?

    enum CodingKeys: String, CodingKey {
        case lat
        case lng
        case accuracyM = "accuracy_m"
        case speedMps = "speed_mps"
        case heading
        case batteryLevel = "battery_level"
        case recordedAt = "recorded_at"
        case isDeviated = "is_deviated"
        case pingCount = "ping_count"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dLat = try? container.decode(Double.self, forKey: .lat) {
            self.lat = dLat
        } else if let sLat = try? container.decode(String.self, forKey: .lat), let d = Double(sLat) {
            self.lat = d
        } else {
            self.lat = nil
        }

        if let dLng = try? container.decode(Double.self, forKey: .lng) {
            self.lng = dLng
        } else if let sLng = try? container.decode(String.self, forKey: .lng), let d = Double(sLng) {
            self.lng = d
        } else {
            self.lng = nil
        }

        if let dAcc = try? container.decode(Double.self, forKey: .accuracyM) {
            self.accuracyM = dAcc
        } else if let sAcc = try? container.decode(String.self, forKey: .accuracyM), let d = Double(sAcc) {
            self.accuracyM = d
        } else {
            self.accuracyM = nil
        }

        if let dSpd = try? container.decode(Double.self, forKey: .speedMps) {
            self.speedMps = dSpd
        } else if let sSpd = try? container.decode(String.self, forKey: .speedMps), let d = Double(sSpd) {
            self.speedMps = d
        } else {
            self.speedMps = nil
        }

        if let dHead = try? container.decode(Double.self, forKey: .heading) {
            self.heading = dHead
        } else if let sHead = try? container.decode(String.self, forKey: .heading), let d = Double(sHead) {
            self.heading = d
        } else {
            self.heading = nil
        }

        if let iBat = try? container.decode(Int.self, forKey: .batteryLevel) {
            self.batteryLevel = iBat
        } else if let sBat = try? container.decode(String.self, forKey: .batteryLevel), let i = Int(sBat) {
            self.batteryLevel = i
        } else if let dBat = try? container.decode(Double.self, forKey: .batteryLevel) {
            self.batteryLevel = Int(dBat)
        } else {
            self.batteryLevel = nil
        }

        self.recordedAt = try? container.decodeIfPresent(String.self, forKey: .recordedAt)

        if let bDev = try? container.decode(Bool.self, forKey: .isDeviated) {
            self.isDeviated = bDev
        } else if let iDev = try? container.decode(Int.self, forKey: .isDeviated) {
            self.isDeviated = (iDev != 0)
        } else {
            self.isDeviated = nil
        }

        if let iPing = try? container.decode(Int.self, forKey: .pingCount) {
            self.pingCount = iPing
        } else if let sPing = try? container.decode(String.self, forKey: .pingCount), let i = Int(sPing) {
            self.pingCount = i
        } else {
            self.pingCount = nil
        }
    }

    func toEntity() -> JourneyLiveLocationEntity {
        JourneyLiveLocationEntity(
            lat: lat ?? 0.0,
            lng: lng ?? 0.0,
            accuracyM: accuracyM ?? 5.0,
            speedMps: speedMps ?? 0.0,
            heading: heading ?? 0.0,
            batteryLevel: batteryLevel ?? 100,
            recordedAt: recordedAt ?? "",
            isDeviated: isDeviated ?? false,
            pingCount: pingCount ?? 0
        )
    }
}

// MARK: - Deviation Event DTO
struct JourneyDeviationEventDTO: Decodable {
    let lat: Double?
    let lng: Double?
    let distanceFromRouteM: Double?
    let thresholdM: Double?
    let detectedAt: String?
    let deviationCount: Int?

    enum CodingKeys: String, CodingKey {
        case lat
        case lng
        case distanceFromRouteM = "distance_from_route_m"
        case thresholdM = "threshold_m"
        case detectedAt = "detected_at"
        case deviationCount = "deviation_count"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let dLat = try? container.decode(Double.self, forKey: .lat) {
            self.lat = dLat
        } else if let sLat = try? container.decode(String.self, forKey: .lat), let d = Double(sLat) {
            self.lat = d
        } else {
            self.lat = nil
        }

        if let dLng = try? container.decode(Double.self, forKey: .lng) {
            self.lng = dLng
        } else if let sLng = try? container.decode(String.self, forKey: .lng), let d = Double(sLng) {
            self.lng = d
        } else {
            self.lng = nil
        }

        if let dDist = try? container.decode(Double.self, forKey: .distanceFromRouteM) {
            self.distanceFromRouteM = dDist
        } else if let sDist = try? container.decode(String.self, forKey: .distanceFromRouteM), let d = Double(sDist) {
            self.distanceFromRouteM = d
        } else {
            self.distanceFromRouteM = nil
        }

        if let dThresh = try? container.decode(Double.self, forKey: .thresholdM) {
            self.thresholdM = dThresh
        } else if let sThresh = try? container.decode(String.self, forKey: .thresholdM), let d = Double(sThresh) {
            self.thresholdM = d
        } else {
            self.thresholdM = nil
        }

        self.detectedAt = try? container.decodeIfPresent(String.self, forKey: .detectedAt)

        if let iDev = try? container.decode(Int.self, forKey: .deviationCount) {
            self.deviationCount = iDev
        } else if let sDev = try? container.decode(String.self, forKey: .deviationCount), let i = Int(sDev) {
            self.deviationCount = i
        } else {
            self.deviationCount = nil
        }
    }

    func toEntity() -> JourneyLiveDeviationEntity {
        JourneyLiveDeviationEntity(
            lat: lat ?? 0.0,
            lng: lng ?? 0.0,
            distanceFromRouteM: distanceFromRouteM ?? 0.0,
            thresholdM: thresholdM ?? 0.0,
            detectedAt: detectedAt ?? "",
            deviationCount: deviationCount ?? 0
        )
    }
}

// MARK: - Ended Event DTO
struct JourneyEndedEventDTO: Decodable {
    let status: String?
    let endedAt: String?
    let pingCount: Int?
    let deviationCount: Int?
    let openRisksClosed: Bool?

    enum CodingKeys: String, CodingKey {
        case status
        case endedAt = "ended_at"
        case pingCount = "ping_count"
        case deviationCount = "deviation_count"
        case openRisksClosed = "open_risks_closed"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try? container.decodeIfPresent(String.self, forKey: .status)
        self.endedAt = try? container.decodeIfPresent(String.self, forKey: .endedAt)

        if let iPing = try? container.decode(Int.self, forKey: .pingCount) {
            self.pingCount = iPing
        } else if let sPing = try? container.decode(String.self, forKey: .pingCount), let i = Int(sPing) {
            self.pingCount = i
        } else {
            self.pingCount = nil
        }

        if let iDev = try? container.decode(Int.self, forKey: .deviationCount) {
            self.deviationCount = iDev
        } else if let sDev = try? container.decode(String.self, forKey: .deviationCount), let i = Int(sDev) {
            self.deviationCount = i
        } else {
            self.deviationCount = nil
        }

        // Handles Bool (false/true) or Int count (0/1/2) or String ("0"/"1"/"true")
        if let bRisks = try? container.decode(Bool.self, forKey: .openRisksClosed) {
            self.openRisksClosed = bRisks
        } else if let iRisks = try? container.decode(Int.self, forKey: .openRisksClosed) {
            self.openRisksClosed = (iRisks != 0)
        } else if let sRisks = try? container.decode(String.self, forKey: .openRisksClosed) {
            if let i = Int(sRisks) {
                self.openRisksClosed = (i != 0)
            } else {
                self.openRisksClosed = (sRisks.lowercased() == "true")
            }
        } else {
            self.openRisksClosed = nil
        }
    }

    func toEntity() -> JourneyLiveEndedEntity {
        JourneyLiveEndedEntity(
            status: status ?? "completed",
            endedAt: endedAt,
            pingCount: pingCount ?? 0,
            deviationCount: deviationCount ?? 0,
            openRisksClosed: openRisksClosed
        )
    }
}

// MARK: - Risk Event DTO
struct JourneyRiskEventDTO: Decodable {
    let type: String?
    let severity: String?
    let message: String?
    let lat: Double?
    let lng: Double?

    enum CodingKeys: String, CodingKey {
        case type
        case severity
        case message
        case lat
        case lng
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try? container.decodeIfPresent(String.self, forKey: .type)
        self.severity = try? container.decodeIfPresent(String.self, forKey: .severity)
        self.message = try? container.decodeIfPresent(String.self, forKey: .message)

        if let dLat = try? container.decode(Double.self, forKey: .lat) {
            self.lat = dLat
        } else if let sLat = try? container.decode(String.self, forKey: .lat), let d = Double(sLat) {
            self.lat = d
        } else {
            self.lat = nil
        }

        if let dLng = try? container.decode(Double.self, forKey: .lng) {
            self.lng = dLng
        } else if let sLng = try? container.decode(String.self, forKey: .lng), let d = Double(sLng) {
            self.lng = d
        } else {
            self.lng = nil
        }
    }

    func toEntity() -> JourneyLiveRiskEntity {
        JourneyLiveRiskEntity(
            type: type ?? "risk",
            severity: severity ?? "warning",
            message: message ?? "Risk detected",
            lat: lat,
            lng: lng
        )
    }
}
