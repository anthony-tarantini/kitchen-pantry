package com.tarantini.pantry.item

import com.tarantini.pantry.domain.Item

class ItemService(private val datastore: ItemDatastore) {

   suspend fun create(name: String, image: String, tags: List<String> = emptyList()): Result<Item> {
      val item = Item(name, image, tags)
      return datastore.insert(item).map { item }
   }

   suspend fun findAll(): Result<List<Item>> {
      return datastore.findAll()
   }

   suspend fun deleteAllItems(): Result<Int> {
      return datastore.deleteAll()
   }
}
