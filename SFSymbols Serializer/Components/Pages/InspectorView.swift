//
//  InspectorView.swift
//  SFSymbols Serializer
//
//  Created by Ashley Chapman on 20/06/2022.
//

import SwiftUI

struct InspectorView: View {
    
    // Variables
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SFProjects.date, ascending: true)],
        animation: .default)
    private var pitems: FetchedResults<SFProjects>
    
    var project: SFProjects
    
    @Binding var item: SFSymbolItem
    @Binding var items: [SFSymbolItem]
    @Binding var selector: SFSymbolItem.ID?

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
    
    init(item: Binding<SFSymbolItem>, items: Binding<[SFSymbolItem]>, selector: Binding<SFSymbolItem.ID?>, project: SFProjects) {
        self._item = item
        self._items = items
        self._selector = selector
        self.project = project
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Image(systemName: self.item.symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                    Text(self.item.symbol)
                        .font(.title)
                }
                .padding()
                Form {
                    Section {
                        TextField("Symbol", text: self.$item.symbol).disabled(true)
                        Picker("Category", selection: self.$item.category) {
                            ForEach(self.categoryArray, id: \.self) { item in
                                Text(item.rawValue.capitalized)
                                    .tag(item)
                            }
                        }
                    }
                    
                    Section(header: Text("Properties & Filters")) {
                        Toggle("Is Variable", isOn: self.$item.isVariable)
                            .toggleStyle(.switch)
                        Toggle("Is Monochrome", isOn: self.$item.isMonochrome)
                            .toggleStyle(.switch)
                        Toggle("Is Hierarchical", isOn: self.$item.isHierarchical)
                            .toggleStyle(.switch)
                        Toggle("Is Palette", isOn: self.$item.isPalette)
                            .toggleStyle(.switch)
                        Toggle("Is Multicolour", isOn: self.$item.isMulticolour)
                            .toggleStyle(.switch)
                        Toggle("Is Limited", isOn: self.$item.isLimited)
                            .toggleStyle(.switch)
                    }
                    
                }
                .formStyle(.grouped)
                
                Button(action: { self.delete() }) {
                    Label("Delete Symbol", systemImage: "trash")
                        .labelStyle(.titleAndIcon)
                        .frame(width: geo.size.width - 40, height: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .frame(width: geo.size.width - 40, height: 48)
                .padding()
            }
        }
    }
    
    func delete() {
        if let index = self.items.firstIndex(where: { $0.id == item.id }) {
            self.items.remove(at: index)
        }
        
        let sfObject = SFSymbolsObject(items: self.items)
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let data = try jsonEncoder.encode(sfObject)
            
            self.project.json = String(data: data, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct InspectorView_Previews: PreviewProvider {
    static var previews: some View {
        InspectorView(item: .constant(SFSymbolItem(id: UUID(), symbol: "house", category: .commerce, isVariable: false, isHierarchical: false, isPalette: false, isMulticolour: false, isLimited: false)), items: .constant([]), selector: .constant(UUID()), project: SFProjects())
    }
}
