package com.tarantini.pantry.item

import com.tarantini.pantry.datastore.Table

object ItemTable : Table {
   object Columns {
      const val ID = "id"
      const val NAME = "name"
      const val IMAGE = "image"
      const val TAGS = "categories"
   }

   override val name: String
      get() = "item"
   override val idColumn: String
      get() = Columns.ID

   override val columns: List<String>
      get() = listOf(
         Columns.NAME,
         Columns.IMAGE,
         Columns.TAGS
      )
}
