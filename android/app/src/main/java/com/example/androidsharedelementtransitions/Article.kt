package com.example.androidsharedelementtransitions

import java.io.Serializable
import java.util.UUID

data class Article(
    val title: String,
): Serializable {
    val id = UUID.randomUUID().toString()
    val imageId: String get() = "article $id image"
    val titleId: String get() = "article $id title"
}