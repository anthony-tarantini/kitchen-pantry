package com.tarantini.pantry.datastore

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.core.RowMapper
import javax.sql.DataSource

class JdbcCoroutineTemplate(ds: DataSource) {

   private val template = JdbcTemplate(ds)

   suspend fun <T> query(
      sql: String, mapper: RowMapper<T>,
      args: List<Any?> = emptyList()
   ): Result<T?> = runCatching {
      withContext(Dispatchers.IO) {
         template.query(sql, mapper, *args.toTypedArray()).firstOrNull()
      }
   }

   suspend fun <T> queryForList(
      sql: String, mapper: RowMapper<T>,
      args: List<Any?> = emptyList()
   ): Result<List<T>> = runCatching {
      withContext(Dispatchers.IO) {
         template.queryForStream(sql, mapper, *args.toTypedArray()).use { it.toList() }
      }
   }

   suspend fun update(sql: String, args: List<Any?>): Result<Int> = runCatching {
      withContext(Dispatchers.IO) {
         template.update(sql, *args.toTypedArray())
      }
   }

   suspend fun exists(sql: String): Result<Boolean> = runCatching {
      withContext(Dispatchers.IO) {
         template.queryForObject(sql, Boolean::class.java)
      }
   }

   suspend fun delete(table: Table): Result<Int> = runCatching {
      withContext(Dispatchers.IO) {
         template.update("DELETE FROM ${table.name}")
      }
   }

   suspend fun delete(table: Table, itemId: Int): Result<Int> = runCatching {
      withContext(Dispatchers.IO) {
         template.update("DELETE FROM ${table.name} WHERE ${table.idColumn} = ${itemId}")
      }
   }
}
