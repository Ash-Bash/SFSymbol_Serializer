//
//  AddSymbolsView.swift
//  SFSymbols Serializer
//
//  Created by Ashley Chapman on 20/06/2022.
//

import SwiftUI

struct AddSymbolsView: View {
    
    // Variables
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SFProjects.date, ascending: true)],
        animation: .default)
    private var projects: FetchedResults<SFProjects>
    
    @Binding var items: [SFSymbolItem]
    
    @State private var addTypeSelector: Int = 0
    
    @State private var symbolText: String = "house"
    @State private var symbolTextEditor: String = ""
    @State private var symbolArray: [String] = []
    @State private var categorySelector: SFSymbolCategory = .communication
    @State private var categoryArray: [SFSymbolCategory] = [
        .communication,
        .weather,
        .objectsAndTools,
        .devices,
        .cameraAndPhotos,
        .gaming,
        .connectivity,
        .transport,
        .accessibility,
        .privacyAndSecurity,
        .human,
        .home,
        .fitness,
        .nature,
        .editing,
        .textFormatting,
        .media,
        .keyboard,
        .commerce,
        .time,
        .health,
        .shapes,
        .arrows,
        .indices,
        .maths
    ]
    
    @State private var isVariable: Bool = false
    @State private var isMonochrome: Bool = true
    @State private var isHierarchical: Bool = false
    @State private var isPalette: Bool = false
    @State private var isMulticolour: Bool = false
    @State private var isLimited: Bool = false
    @State private var dontDublicate: Bool = true
    
    @ViewBuilder var body: some View {
        VStack {
            HStack {
                Spacer()
                Picker("", selection: self.$addTypeSelector) {
                    Text("Add Symbol")
                        .tag(0)
                    Text("Add Multiple Symbols")
                        .tag(1)
                }
                .pickerStyle(.segmented)
                Spacer()
            }
            .padding()
            if self.addTypeSelector == 0 {
                Form {
                    Section {
                        TextField("Symbol", text: self.$symbolText)
                        Picker("Category", selection: self.$categorySelector) {
                            ForEach(self.categoryArray, id: \.self) { item in
                                Text(item.rawValue.capitalized)
                                    .tag(item)
                            }
                        }
                        Toggle("Don't Add if Duplicate", isOn: self.$dontDublicate)
                    }
                    
                    Section(header: Text("Properties & Filters")) {
                        Toggle("Is Variable", isOn: self.$isVariable)
                            .toggleStyle(.switch)
                        Toggle("Is Monochrome", isOn: self.$isMonochrome)
                            .toggleStyle(.switch)
                        Toggle("Is Hierarchical", isOn: self.$isHierarchical)
                            .toggleStyle(.switch)
                        Toggle("Is Palette", isOn: self.$isPalette)
                            .toggleStyle(.switch)
                        Toggle("Is Multicolour", isOn: self.$isMulticolour)
                            .toggleStyle(.switch)
                        Toggle("Is Limited", isOn: self.$isLimited)
                            .toggleStyle(.switch)
                    }
                }
                .formStyle(.grouped)
            } else {
                Form {
                    Section {
                        TextEditor(text: self.$symbolTextEditor.onChange({ value in
                            print("Contains (\n): ", value.components(separatedBy: "\n"))
                            self.symbolArray = value.components(separatedBy: "\n")
                        }))
                            .frame(height: 250)
                        Picker("Category", selection: self.$categorySelector) {
                            ForEach(self.categoryArray, id: \.self) { item in
                                Text(item.rawValue.capitalized)
                                    .tag(item)
                            }
                        }
                        Toggle("Don't Add if Duplicate", isOn: self.$dontDublicate)
                    }
                }
                .formStyle(.grouped)
            }
            HStack {
                Spacer()
                Button(action: { self.dismiss() }) {
                    Text("Cancel")
                        .frame(width: 72)
                }
                Button(action: {
                    self.save()
                }) {
                    Text("Save")
                        .frame(width: 72)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!self.canDublicate())
            }
            .padding()
        }
    }
    
    func save() {
        if self.addTypeSelector == 0 {
            let item = SFSymbolItem(id: UUID(), symbol: self.symbolText, category: self.categorySelector, isVariable: self.isVariable, isMonochrome: self.isMonochrome, isHierarchical: self.isHierarchical, isPalette: self.isPalette, isMulticolour: self.isMulticolour, isLimited: self.isLimited)
            if self.dontDublicate {
                if self.items.contains(where: { $0.symbol != item.symbol }) {
                    self.items.append(item)
                }
            } else {
                self.items.append(item)
            }
        } else {
            var vitems: [SFSymbolItem] = []
            for symbol in self.symbolArray {
                let item = SFSymbolItem(id: UUID(), symbol: symbol, category: self.categorySelector, isVariable: false, isHierarchical: false, isPalette: false, isMulticolour: false, isLimited: false)
                vitems.append(item)
            }
            if self.dontDublicate {
                for yt in self.items {
                    if let index = vitems.firstIndex(where: { $0.symbol == yt.symbol }) {
                        vitems.remove(at: index)
                    }
                }
                self.items += vitems
            } else {
                self.items += vitems
            }
        }
        
        self.dismiss()
    }
    
    func canDublicate() -> Bool {
        if self.dontDublicate {
            if self.addTypeSelector == 0 {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}

struct AddSymbolsView_Previews: PreviewProvider {
    static var previews: some View {
        AddSymbolsView(items: .constant([]))
    }
}
