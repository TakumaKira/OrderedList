//
//  ContentView.swift
//  OrderedList
//
//  Created by SchwiftyUI on 9/2/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: ListItem.entity(), sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var listItems: FetchedResults<ListItem>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(listItems, id: \.self) { item in
                        Text("\(item.name) - \(item.order)")
                    }
                    .onDelete(perform: deleteItem)
                }
                Button(action: addItem) {
                    Text("Add Item")
                }
            }
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        let source = indexSet.first!
        let listItem = listItems[source]
        managedObjectContext.delete(listItem)
        saveItems()
    }
    
    func addItem() {
        let newItem = ListItem(context: managedObjectContext)
        newItem.name = "New Item"
        newItem.order = (listItems.last?.order ?? 0) + 1
        
        saveItems()
    }
    
    func saveItems() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
