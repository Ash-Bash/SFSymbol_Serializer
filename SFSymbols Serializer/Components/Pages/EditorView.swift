//
//  EditorView.swift
//  SFSymbols Serializer
//
//  Created by Ashley Chapman on 21/06/2022.
//

import SwiftUI

struct EditorView: View {
    
    // Variables
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SFProjects.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<SFProjects>
    
    var project: SFProjects
    @ObservedObject var sfSymbolObject: SFSymbolsObject = SFSymbolsObject(items: [])
    
    @State private var symbolSelector: SFSymbolItem.ID?
    @State private var sortOrder = [KeyPathComparator(\SFSymbolItem.symbol)]
    
    @State private var presentAddSymbol: Bool = false
    @State private var presentFileExporter: Bool = false
    
    init(project: SFProjects) {
        self.project = project
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedProject = try jsonDecoder.decode(SFSymbolsObject.self, from: project.json!.data(using: .utf8)!)
            self.sfSymbolObject = decodedProject
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        self.editorBody
            .toolbar {
                ToolbarItem {
                    Button(action: { self.presentFileExporter.toggle() }) {
                        Label("Export Symbols", systemImage: "doc.badge.arrow.up")
                    }
                }
                ToolbarItem {
                    Button(action: { self.presentAddSymbol.toggle() }) {
                        Label("Add Symbols", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: self.$presentAddSymbol) {
                AddSymbolsView(items: self.$sfSymbolObject.items.onChange({ item in
                    self.updateProject()
                }))
            }
            #if os(macOS)
            .navigationSubtitle(self.project.name!)
            #elseif os(iOS)
            .navigationTitle(self.project.name!)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .fileExporter(isPresented: self.$presentFileExporter, document: SFSymbolSerializerDocument(name: self.project.name ?? "Untitled", json: self.project.json ?? "{ 'items': [] }"), contentType: .json, onCompletion: { (result) in
                        if case .success = result {
                            print("Success")
                        } else {
                            print("Failure")
                        }
                    })
    }
    
    var editorBody: some View {
        #if os(iOS)
        GeometryReader { geo in
            EditorTabletSplitView(canvas: AnyView(self.iosDetailBody), inspector: AnyView(self.inspectorBody))
                .edgesIgnoringSafeArea(.all)
        }
        #elseif os(macOS)
        GeometryReader { geo in
            HSplitView {
                self.detailBody
                    .frame(height: geo.size.height)
                self.inspectorBody
                    .frame(width: 320, height: geo.size.height)
            }
            .frame(height: geo.size.height)
        }
        #endif
    }
    
    var iosDetailBody: some View {
        self.detailBody
            .toolbar {
                ToolbarItem {
                    Button(action: { self.presentAddSymbol.toggle() }) {
                        Label("Add Symbols", systemImage: "plus")
                    }
                }
            }
    }
    
    var detailBody: some View {
        Table(self.sfSymbolObject.items, selection: self.$symbolSelector, sortOrder: self.$sortOrder) {
            TableColumn("Symbol") { item in
                HStack {
                    Image(systemName: item.symbol)
                    Text(item.symbol)
                    Spacer()
                }
            }
            TableColumn("Category") { item in
                Text(item.category.rawValue.capitalized)
            }
            TableColumn("Modifiable") { item in
                if !item.isLimited {
                    Image(systemName: "checkmark")
                }
            }
        }
        .onChange(of: sortOrder) {
            self.sfSymbolObject.items.sort(using: $0)
        }
    }
    
    @ViewBuilder var inspectorBody: some View {
        if self.getSymbolIndex() != nil {
            if self.symbolSelector != nil {
                InspectorView(item: Binding<SFSymbolItem>(get: {
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0]
                }, set: {
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].id = $0.id
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].symbol = $0.symbol
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].category = $0.category
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].isVariable = $0.isVariable
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].isMonochrome = $0.isMonochrome
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].isHierarchical = $0.isHierarchical
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].isPalette = $0.isPalette
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].isMulticolour = $0.isMulticolour
                    self.sfSymbolObject.items[self.getSymbolIndex() ?? 0].isLimited = $0.isLimited
                    
                    self.updateProject()
                }),
                items: self.$sfSymbolObject.items,
                selector: self.$symbolSelector,
                project: self.project)
            } else {
                Text("No Symbol Selected")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.secondary)
            }
        } else {
            Text("No Symbol Selected")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
        }
    }
    
    func getSymbolIndex() -> Int? {
        return self.sfSymbolObject.items.firstIndex(where: { $0.id == self.symbolSelector }) ?? nil
    }
    
    func updateProject() {
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try jsonEncoder.encode(self.sfSymbolObject)
            
            self.project.json = String(decoding: data, as: UTF8.self)
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            try viewContext.save()
            print("Project saved.")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(project: SFProjects())
    }
}
