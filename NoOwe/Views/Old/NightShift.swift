//
//  NightShift.swift
//  NoOwe
//
//  Created by Filip Wicha on 04/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct NightShift: View {
    
    @State private var schedluled: Bool = false
    @State private var manuallyEnabledTillTomorrow: Bool = false
    @State private var colorTemperature: Float = 0.5
    
    var body: some View {
        
        NavigationView {
            
            Form{
                
                Section(header: Text("Night shift automatically shift colors Night shift automatically shift colors Night shift automatically shift colors Night shift automatically shift colors").padding(5).lineLimit(nil)) {
                    
                    Toggle(isOn: $schedluled){
                        Text("Scheduled")
                    }
                    NavigationLink(destination: Text("Scheduled Settings")){
                        HStack{
                            
                            VStack {
                                Text("From")
                                Text("To")
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Sunset").foregroundColor(Color.blue)
                                Text("Sunrise").foregroundColor(Color.blue)
                            }
                        }
                        
                    }
                }
                
                Section(header: Text("").padding(5)) {
                    
                    Toggle(isOn: $manuallyEnabledTillTomorrow){
                        Text("Manually enabled until tomorrow")
                    }
                }
                
                Section(header: Text("Color temperature").padding(5)) {
                    
                    Toggle(isOn: $manuallyEnabledTillTomorrow){
                        Text("Manually enabled until tomorrow")
                    }
                    
                    HStack {
                        Text("Less Warm")
                        Slider(value: $colorTemperature)
                        Text("More Warm")
                    }
                }
                
            }
            
        }
    }
}

struct NightShift_Previews: PreviewProvider {
    static var previews: some View {
        NightShift()
    }
}
