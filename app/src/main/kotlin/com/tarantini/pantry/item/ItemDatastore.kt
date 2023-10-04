package com.tarantini.pantry.item

import com.tarantini.pantry.datastore.JdbcCoroutineTemplate
import com.tarantini.pantry.datastore.insertAllInto
import com.tarantini.pantry.datastore.selectAll
import com.tarantini.pantry.domain.Item
import com.tarantini.pantry.item.ItemTable.Columns
import org.springframework.jdbc.core.RowMapper
import javax.sql.DataSource

class ItemDatastore(ds: DataSource) {

   private val template = JdbcCoroutineTemplate(ds)

   private val mapper = RowMapper { rs, _ ->
      Item(
         name = rs.getString(Columns.NAME),
         emptyList()
      )
   }

   suspend fun insert(item: Item): Result<Int> {
      return template.update(
         insertAllInto(ItemTable),
         listOf(item.name)
      )
   }

   suspend fun findAll(): Result<List<Item>> {
      return template.queryForList(selectAll(ItemTable), mapper)
   }

   suspend fun delete(itemId: Int): Result<Int> {
      return template.delete(ItemTable, itemId)
   }

   suspend fun deleteAll(): Result<Int> {
      return template.delete(ItemTable)
   }
}
