package com.example.listadetareas

data class Tarea(
    val id: Int,
    val titulo: String,
    var completada: Boolean = false
)
