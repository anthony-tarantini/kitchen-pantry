package com.tarantini.pantry.item

import com.tarantini.pantry.domain.Item

class ItemService(private val datastore: ItemDatastore) {

   suspend fun create(name: String, keywords: List<String> = emptyList()): Result<Item> {
      val item = Item(name, keywords)
      return datastore.insert(item).map { item }
   }

   suspend fun findAll(): Result<List<Item>> {
      return datastore.findAll()
   }

   suspend fun deleteItem(itemId: Int): Result<Int> {
      return datastore.delete(itemId)
   }

   suspend fun deleteAllItems(): Result<Int> {
      return datastore.deleteAll()
   }
}
