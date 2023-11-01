package com.tarantini.pantry.userItem

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.tarantini.pantry.datastore.JdbcCoroutineTemplate
import com.tarantini.pantry.datastore.insertAllInto
import com.tarantini.pantry.domain.Item
import com.tarantini.pantry.domain.Measurement
import com.tarantini.pantry.domain.UserItem
import com.tarantini.pantry.domain.Weight
import com.tarantini.pantry.item.ItemTable
import org.springframework.jdbc.core.RowMapper
import javax.sql.DataSource

class UserItemDatastore(ds: DataSource) {

   private val template = JdbcCoroutineTemplate(ds)

   private val mapper = RowMapper { rs, _ ->
      UserItem(
         Item(
            id = rs.getInt(ItemTable.Columns.ID),
            name = rs.getString(ItemTable.Columns.NAME),
            image = rs.getString(ItemTable.Columns.IMAGE),
            categories = jacksonObjectMapper().convertValue(
               rs.getString(ItemTable.Columns.TAGS),
               ArrayList<String>()::class.java
            )
         ),
         Weight(
            rs.getDouble(UserItemProjection.Values.VALUE),
            Measurement.valueOf(rs.getString(UserItemProjection.Values.MEASUREMENT))
         )
      )
   }

   suspend fun getItemsForUser(userId: Int): Result<List<UserItem>> {
      return template.queryForList(UserItemProjection(userId).queryString, mapper)
   }

   suspend fun insert(userId: Int, itemId: Int, weight: Weight): Result<Int> {
      return template.update(
         insertAllInto(UserItemTable),
         listOf(userId, itemId, weight.value, weight.measurement.toString())
      )
   }
}
