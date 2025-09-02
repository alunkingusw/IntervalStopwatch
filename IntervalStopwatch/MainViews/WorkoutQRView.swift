//
//  WorkoutQRView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 30/08/2025.
//


import SwiftUI
import CoreImage.CIFilterBuiltins

struct WorkoutQRView: View {
    var workout: Workout
    @State private var qrImage: UIImage?
    @State private var encodedString: String = ""
    @State private var decodedWorkout: Workout?
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("QR Code Export Test")
                .font(.title2)
            
            if let qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if !encodedString.isEmpty {
                ScrollView {
                    Text(encodedString)
                        .font(.footnote)
                        .textSelection(.enabled)
                        .padding()
                }
                .frame(height: 120)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            if let decoded = decodedWorkout {
                Text("Decoded Workout: \(decoded.name)")
                    .font(.headline)
            }
            
            HStack {
                Button("Encode") {
                    do {
                        let encoded = try workout.exportToQRPayload()
                        encodedString = encoded
                        qrImage = generateQRCode(from: encoded)
                        // Print payload length in characters
                        print("QR payload length (chars): \(encoded.count)")
                            
                            // Print payload size in bytes
                        if let payloadData = encoded.data(using: .utf8) {
                                print("QR payload size (bytes): \(payloadData.count)")
                            }
                    } catch {
                        print("Encoding failed: \(error)")
                    }
                }
                
                Button("Decode") {
                    do {
                        decodedWorkout = try Workout.importFromQRPayload(encodedString)
                    } catch {
                        print("Decoding failed: \(error)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}
#Preview {
    WorkoutQRView(workout:Workout.sampleData)
}
