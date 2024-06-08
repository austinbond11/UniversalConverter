//
//  ContentView.swift
//  DistanceConverter
//
//  Created by Austin Bond on 6/8/24.
//

import SwiftUI

struct ContentView: View {
    // State variables to store user input and selected conversion units
    @State private var input = 1.0  // The user's input value to be converted
    @State private var inputUnit: Dimension = UnitLength.meters  // The initial unit for the input value
    @State private var outputUnit: Dimension = UnitLength.kilometers  // The initial unit for the output value
    @State private var selectedUnits = 0  // Index to track the type of conversion selected by the user

    // Focus state for managing the focus state of the input text field
    @FocusState private var inputIsFocused: Bool  // State to control if the input field is focused

    // Array of conversion categories
    let conversions = ["Area", "Astronomical", "Distance", "Mass", "Pressure", "Speed", "Temperature", "Time", "Volume"]
    
    // Nested array containing different Dimension units for each conversion category
    let unitTypes: [[Dimension]] = [
        [UnitArea.acres, UnitArea.hectares, UnitArea.squareFeet, UnitArea.squareKilometers, UnitArea.squareMeters, UnitArea.squareMiles],
        [UnitLength.astronomicalUnits, UnitLength.lightyears, UnitLength.parsecs],
        [UnitLength.centimeters, UnitLength.feet, UnitLength.inches, UnitLength.kilometers, UnitLength.meters, UnitLength.miles, UnitLength.millimeters, UnitLength.yards],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.metricTons, UnitMass.ounces, UnitMass.pounds, UnitMass.stones],
        [UnitPressure.bars, UnitPressure.hectopascals, UnitPressure.inchesOfMercury, UnitPressure.kilopascals, UnitPressure.millibars, UnitPressure.millimetersOfMercury, UnitPressure.newtonsPerMetersSquared, UnitPressure.poundsForcePerSquareInch],
        [UnitSpeed.kilometersPerHour, UnitSpeed.knots, UnitSpeed.metersPerSecond, UnitSpeed.milesPerHour],
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitDuration.hours, UnitDuration.microseconds, UnitDuration.milliseconds, UnitDuration.minutes, UnitDuration.nanoseconds, UnitDuration.seconds],
        [UnitVolume.bushels, UnitVolume.cubicCentimeters, UnitVolume.cubicFeet, UnitVolume.cubicInches, UnitVolume.cubicMeters, UnitVolume.fluidOunces, UnitVolume.gallons, UnitVolume.liters, UnitVolume.milliliters, UnitVolume.pints, UnitVolume.quarts]
    ]
    
    // Formatter for converting and displaying measurement values
    let formatter: MeasurementFormatter

    // Computed property to perform the conversion and return the formatted result as a string
    var result: String {
        let inputMeasurement = Measurement(value: input, unit: inputUnit)  // Create a Measurement object from the input
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)  // Convert to the desired output unit
        return formatter.string(from: outputMeasurement)  // Format the result as a string
    }
    
    var body: some View {
        NavigationStack {  // Use NavigationStack to manage the navigation
            Form {  // Use a Form for organizing the input fields and controls
                Section("Amount to convert") {
                    TextField("Amount", value: $input, format: .number)  // TextField for user input
                        .keyboardType(.decimalPad)  // Use decimal pad for numeric input
                        .focused($inputIsFocused)  // Bind focus state to the text field
                }
                
                Picker("Conversion", selection: $selectedUnits) {  // Picker to select conversion category
                    ForEach(0..<conversions.count, id: \.self) {
                        Text(conversions[$0])  // Display conversion categories
                    }
                }
                
                Picker("Convert from", selection: $inputUnit) {  // Picker to select input unit
                    ForEach(unitTypes[selectedUnits], id: \.self) { unit in
                        Text(formatter.string(from: unit).capitalized)  // Display formatted unit names
                    }
                }
                
                Picker("Convert to", selection: $outputUnit) {  // Picker to select output unit
                    ForEach(unitTypes[selectedUnits], id: \.self) { unit in
                        Text(formatter.string(from: unit).capitalized)  // Display formatted unit names
                    }
                }
                
                Section("Result") {
                    Text(result)  // Display the conversion result
                }
            }
            .navigationTitle("Universal Converter")  // Set the navigation title
            .toolbar {  // Toolbar for additional actions
                if inputIsFocused {  // If input is focused, show a "Done" button
                    Button("Done") {
                        inputIsFocused = false  // Dismiss the keyboard
                    }
                }
            }
            .onChange(of: selectedUnits) {  // Handle changes in selectedUnits
                let units = unitTypes[selectedUnits]  // Update input and output units based on the selected category
                inputUnit = units[0]
                outputUnit = units[1]
            }
        }
    }
    
    // Initializer to configure the MeasurementFormatter
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit  // Use the provided unit without conversion
        formatter.unitStyle = .long  // Use long style for unit names
    }
}

// Preview provider for SwiftUI previews
#Preview("Default View") {
    ContentView()
}
