package com.tarantini.pantry.item

import com.tarantini.pantry.domain.CreateItemRequest
import com.tarantini.pantry.endpoints.withRequest
import com.tarantini.pantry.utils.Constants.GOOGLE
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.itemEndpoints(service: ItemService) {
   authenticate(GOOGLE) {
      get("/items") {
         service.findAll().fold(
            { call.respond(HttpStatusCode.OK, it) },
            { call.respond(HttpStatusCode.InternalServerError, it) }
         )
      }

      post("/items") {
         withRequest<CreateItemRequest> { request ->
            service.create(request.name, request.image, request.categories).fold(
               { result -> call.respond(HttpStatusCode.Created, result) },
               { call.respond(HttpStatusCode.InternalServerError, it) }
            )
         }
      }

      delete("/items") {
         service.deleteAllItems().fold(
            { call.respond(HttpStatusCode.NoContent) },
            { call.respond(HttpStatusCode.InternalServerError, it) }
         )
      }
   }
}
