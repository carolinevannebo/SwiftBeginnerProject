//
//  CountryCodesView.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 23/10/2023.
//

import SwiftUI

struct CountryCodesView: View {
    @State private var searchCountry: String = ""
    var presentSheet: Binding<Bool>
    
    var countryCode: Binding<String>// = "+47"
    var countryFlag: Binding<String>// = "🇳🇴"
    var countryPattern: Binding<String>// = "### ## ###"
    var countryLimit: Binding<Int>// = 17
    
    let countries: [CPData] = Bundle.main.decode(forName: "CountryNumbers")
    
    init(countryCode: Binding<String>, countryFlag: Binding<String>, countryPattern: Binding<String>, countryLimit: Binding<Int>, presentSheet: Binding<Bool>) {
        self.countryCode = countryCode
        self.countryFlag = countryFlag
        self.countryPattern = countryPattern
        self.countryLimit = countryLimit
        self.presentSheet = presentSheet
    }
    
    var body: some View {
        if presentSheet.wrappedValue == true {
            NavigationStack {
                
            }.sheet(isPresented: presentSheet) {
                NavigationView {
                    List(filteredResorts) { country in
                        HStack {
                            Text(country.flag)
                            Text(country.name)
                                .font(.headline)
                            Spacer()
                            Text(country.dial_code)
                                .foregroundColor(.secondary)
                        } // HStack
                        .onTapGesture {
                            countryFlag.wrappedValue = country.flag
                            countryCode.wrappedValue = country.dial_code
                            countryPattern.wrappedValue = country.pattern
                            countryLimit.wrappedValue = country.limit
                            presentSheet.wrappedValue = false
                            searchCountry = ""
                        } // HStack onTapGesture
                    } // List
                    .listStyle(.plain)
                    .searchable(text: $searchCountry, prompt: "Your country") //TODO: make case-insensitive
                } // NavigationView
                .presentationDetents([.medium, .large])
            } // Sheet
            .presentationDetents([.medium, .large])
            
            var filteredResorts: [CPData] {
                if searchCountry.isEmpty {
                    return countries
                } else {
                    return countries.filter { $0.name.contains(searchCountry) }
                }
            }
        }
    }
}

struct CountryCodesView_Previews: PreviewProvider {
    static var previews: some View {
        let presentSheet = Binding.constant(true)
        let countryCode = Binding.constant("+47")
        let countryFlag = Binding.constant("🇳🇴")
        let countryPattern = Binding.constant("### ## ###")
        let countryLimit = Binding.constant(17)
            
        return CountryCodesView(
            countryCode: countryCode,
            countryFlag: countryFlag,
            countryPattern: countryPattern,
            countryLimit: countryLimit,
            presentSheet: presentSheet
        )
    }
}
