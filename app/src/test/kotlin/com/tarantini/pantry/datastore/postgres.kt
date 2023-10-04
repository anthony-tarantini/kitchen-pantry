package com.tarantini.pantry.datastore

import io.kotest.extensions.testcontainers.SharedJdbcDatabaseContainerExtension
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.utility.DockerImageName

private val DOCKER_IMAGE_NAME = DockerImageName.parse("postgres:latest")
val postgresContainer = PostgreSQLContainer(DOCKER_IMAGE_NAME)
val postgres = SharedJdbcDatabaseContainerExtension(postgresContainer, afterStart = { flywayMigrate(it) })
