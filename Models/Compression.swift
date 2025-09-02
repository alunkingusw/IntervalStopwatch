//
//  Compression.swift
//  IntervalStopwatch
//
//  Created by Alun King on 30/08/2025.
//
///This file is used to turn the Workout into a JSON file, encode it using Base64 and compress it using gzip.
///By doing this, the workout can be displayed as a JSON file for others to share and load.
import Foundation
import Compression

extension Data {
    func compressed() throws -> Data {
        return try self.withUnsafeBytes { (rawBuffer: UnsafeRawBufferPointer) -> Data in
            guard let baseAddress = rawBuffer.baseAddress else { return Data() }
            
            let bufferSize = 64 * 1024
            var dstBuffer = Data(count: bufferSize)
            
            return try dstBuffer.withUnsafeMutableBytes { dstRawBuffer -> Data in
                guard let dstPointer = dstRawBuffer.baseAddress else { return Data() }
                
                let compressedSize = compression_encode_buffer(
                    dstPointer.assumingMemoryBound(to: UInt8.self),
                    bufferSize,
                    baseAddress.assumingMemoryBound(to: UInt8.self),
                    count,
                    nil,
                    COMPRESSION_ZLIB // gzip-compatible
                )
                
                if compressedSize == 0 {
                    throw NSError(domain: "CompressionError", code: -1, userInfo: nil)
                }
                
                return Data(bytes: dstPointer, count: compressedSize)
            }
        }
    }
    
    func decompressed(originalSize: Int) throws -> Data {
        return try self.withUnsafeBytes { (rawBuffer: UnsafeRawBufferPointer) -> Data in
            guard let baseAddress = rawBuffer.baseAddress else { return Data() }
            
            var dstBuffer = Data(count: originalSize)
            
            return try dstBuffer.withUnsafeMutableBytes { dstRawBuffer -> Data in
                guard let dstPointer = dstRawBuffer.baseAddress else { return Data() }
                
                let decompressedSize = compression_decode_buffer(
                    dstPointer.assumingMemoryBound(to: UInt8.self),
                    originalSize,
                    baseAddress.assumingMemoryBound(to: UInt8.self),
                    count,
                    nil,
                    COMPRESSION_ZLIB
                )
                
                if decompressedSize == 0 {
                    throw NSError(domain: "DecompressionError", code: -1, userInfo: nil)
                }
                
                return Data(bytes: dstPointer, count: decompressedSize)
            }
        }
    }
}

extension Workout {
    /// Encode this Workout to a compressed Base64 string for QR
    func exportToQRPayload() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [] // compact JSON
        let jsonData = try encoder.encode(self)
        
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
        let compressed = try jsonData.compressed()
        
        // Combine compressed data + original size (so we know how to decompress)
        let sizeBytes = withUnsafeBytes(of: UInt32(jsonData.count).bigEndian) { Data($0) }
        let payloadData = sizeBytes + compressed
        
        return payloadData.base64EncodedString()
    }
    
    /// Decode a Workout from a compressed Base64 string scanned from QR
    static func importFromQRPayload(_ payload: String) throws -> Workout {
        guard let payloadData = Data(base64Encoded: payload) else {
            throw NSError(domain: "WorkoutDecoding", code: -1, userInfo: nil)
        }
        
        // First 4 bytes = original size
        guard payloadData.count > 4 else {
            throw NSError(domain: "WorkoutDecoding", code: -2, userInfo: nil)
        }
        let sizeData = payloadData.prefix(4)
        let compressedData = payloadData.dropFirst(4)
        
        let originalSize = Int(UInt32(bigEndian: sizeData.withUnsafeBytes { $0.load(as: UInt32.self) }))
        
        let decompressed = try compressedData.decompressed(originalSize: originalSize)
        
        let workout = try JSONDecoder().decode(Workout.self, from: decompressed)
        // Re-encode to JSON for inspection (pretty-printed)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys] // optional for readability & consistency
        let jsonData = try encoder.encode(workout)
            
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Decoded Workout JSON:\n\(jsonString)")
        }
        workout.bindChildren()
        return workout
    }
}
