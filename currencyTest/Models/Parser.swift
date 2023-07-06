//
//  Parser.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 07.07.2023.
//

import Foundation

class CurrentXMLParser: XMLParser {
    var currency = Currency(date: "0/00/0000", value: 0.0)
    var date = ""
    var value: Double = 0.0
    var elementName = ""
    var flag = false
    
    override init(data: Data) {
        super.init(data: data)
        self.delegate = self
    }
}

extension CurrentXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Valute" && attributeDict["ID"] == "R01235" {
            flag = true
        }
        if elementName == "Value" && flag{
            self.elementName = elementName
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Valute" && flag {
            if !self.value.isZero {
                self.currency.value = self.value
            }
            self.elementName = ""
            self.flag = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let dataWrap = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataUnwrap = dataWrap.replacingOccurrences(of: ",", with: ".")
        if !dataUnwrap.isEmpty{
            if self.elementName == "Value" {
                if let unwrap = Double(dataUnwrap) {
                    self.value = unwrap
                }
            }
        }
    }
}

class MonthlyXMlParser: XMLParser {
    var currencies: [Currency] = []
    var date = ""
    var value: Double = 0.0
    var elementName = ""
    
    override init(data: Data) {
        super.init(data: data)
        self.delegate = self
    }
}

extension MonthlyXMlParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Record" {
            if let unwrap = attributeDict["Date"] {
                self.date = unwrap
            }
        }
        if elementName == "Value" {
            self.elementName = elementName
        }
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Record" {
            if !(self.value.isZero) && !(self.date.isEmpty) {
                currencies.append(Currency(date: self.date, value: self.value))
            }
            self.elementName = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let dataWrap = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataUnwrap = dataWrap.replacingOccurrences(of: ",", with: ".")
        if !dataUnwrap.isEmpty{
            if self.elementName == "Value" {
                if let unwrap = Double(dataUnwrap){
                    self.value = unwrap
                }
            }
        }
    }
}
