//
//  ContentView.swift
//  SFSymbols Serializer
//
//  Created by Ashley Chapman on 20/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    // Variable
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SFProjects.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<SFProjects>
    
    @ObservedObject var sfSymbolObject: SFSymbolsObject = SFSymbolsObject(items: [])
    
    @State private var presentAddSymbol: Bool = false
    
    @State private var selection: SFProjects? = nil
    
    @ViewBuilder var body: some View {
        NavigationSplitView {
            List(selection: self.$selection) {
                Section(header: Text("Projects")) {
                    ForEach(items) { item in
                        SidebarItem(item: item)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationSplitViewColumnWidth(240)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "doc.badge.plus")
                    }
                }
            }
        } detail: {
            Text("No SFProject Selected")
                .font(.title)
                .bold()
                .foregroundColor(.secondary)
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = SFProjects(context: viewContext)
            newItem.id = UUID()
            newItem.date = Date()
            newItem.name = "Item \(items.count + 1)"
            newItem.json = "{ 'items': [] }"

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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
}

struct SidebarItem: View {
    
    // Variables
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SFProjects.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<SFProjects>
    var item: SFProjects
    
    @State private var isEditing: Bool = false
    @State private var renameText: String = ""
    
    init(item: SFProjects) {
        self.item = item
        self._renameText = State(initialValue: self.item.name!)
    }
    
    @ViewBuilder var body: some View {
        self.itemBody
            .contextMenu {
                Button(action: { self.isEditing.toggle() }) {
                    Label("Rename Item", systemImage: "pencil")
                        .labelStyle(.titleAndIcon)
                }
                Button(action: { self.delete() }) {
                    Label("Delete", systemImage: "trash")
                        .labelStyle(.titleAndIcon)
                }
            }
    }
    
    @ViewBuilder var itemBody: some View {
        if !self.isEditing {
            NavigationLink {
                EditorView(project: item)
            } label: {
                Label(item.name!, systemImage: "tablecells")
                    .labelStyle(.titleAndIcon)
                    .tint(.accentColor)
            }
        } else {
            HStack {
                Image(systemName: "tablecells")
                TextField("", text: self.$renameText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        self.save()
                    }
                Button(action: { self.save() }) {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
            }
        }
    }
    
    func save() {        
        self.item.name = self.renameText
        do {
            try viewContext.save()
            self.isEditing.toggle()
            print("Project saved.")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete() {
        withAnimation {
            self.viewContext.delete(self.item)

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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
