package com.tarantini.pantry.item

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.tarantini.pantry.datastore.JdbcCoroutineTemplate
import com.tarantini.pantry.datastore.insertAllInto
import com.tarantini.pantry.datastore.selectAll
import com.tarantini.pantry.domain.Item
import com.tarantini.pantry.domain.JacksonSupport.toJson
import com.tarantini.pantry.item.ItemTable.Columns
import org.springframework.jdbc.core.RowMapper
import javax.sql.DataSource

class ItemDatastore(ds: DataSource) {

   private val template = JdbcCoroutineTemplate(ds)

   private val mapper = RowMapper { rs, _ ->
      Item(
         id = rs.getInt(Columns.ID),
         name = rs.getString(Columns.NAME),
         image = rs.getString(Columns.IMAGE),
         tags = jacksonObjectMapper().convertValue(rs.getString(Columns.TAGS), ArrayList<String>()::class.java)
      )
   }

   suspend fun insert(item: Item): Result<Int> {
      return template.update(
         insertAllInto(ItemTable),
         listOf(item.name, item.image, jacksonObjectMapper().toJson())
      )
   }

   suspend fun findAll(): Result<List<Item>> {
      return template.queryForList(selectAll(ItemTable), mapper)
   }

   suspend fun deleteAll(): Result<Int> {
      return template.delete(ItemTable)
   }
}
