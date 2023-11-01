package com.tarantini.pantry.domain

data class Item(
   val name: String,
   val image: String,
   val categories: List<String>,
   val id: Int? = null
)

data class CreateItemRequest(
   val name: String,
   val image: String,
   val categories: List<String>
)
