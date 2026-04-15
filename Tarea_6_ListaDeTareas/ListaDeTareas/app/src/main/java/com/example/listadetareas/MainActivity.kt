package com.example.listadetareas

import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.listadetareas.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private val listaTareas = mutableListOf<Tarea>()
    private lateinit var adapter: TareaAdapter
    private var contadorId = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        configurarRecyclerView()
        configurarBotones()
        actualizarContador()
    }

    private fun configurarRecyclerView() {
        // TODO 1: Crear el adapter pasando listaTareas, lambda para eliminar y lambda para toggle
        adapter = TareaAdapter(listaTareas, { posicion ->
            eliminarTarea(posicion)
        }, {
            actualizarContador()
        })

        // TODO 2: Asignar un LinearLayoutManager al RecyclerView
        binding.rvTareas.layoutManager = LinearLayoutManager(this)

        // TODO 3: Asignar el adapter al RecyclerView
        binding.rvTareas.adapter = adapter
    }

    private fun configurarBotones() {
        binding.btnAgregar.setOnClickListener {
            val texto = binding.etNuevaTarea.text.toString().trim()
            if (texto.isNotEmpty()) {
                agregarTarea(texto)
                binding.etNuevaTarea.text.clear()
            } else {
                Toast.makeText(this, "Escribe una tarea primero", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun agregarTarea(titulo: String) {
        // TODO 4: Incrementar contadorId
        contadorId++
        // TODO 5: Crear una nueva Tarea con el id y titulo
        val nuevaTarea = Tarea(contadorId, titulo)
        // TODO 6: Agregarla a listaTareas
        listaTareas.add(nuevaTarea)
        // TODO 7: Notificar al adapter
        adapter.notifyItemInserted(listaTareas.size - 1)
        // TODO 8: Llamar a actualizarContador()
        actualizarContador()
    }

    private fun eliminarTarea(posicion: Int) {
        // TODO 9: Remover la tarea en la posición dada
        listaTareas.removeAt(posicion)
        // TODO 10: Notificar al adapter
        adapter.notifyItemRemoved(posicion)
        adapter.notifyItemRangeChanged(posicion, listaTareas.size)
        // TODO 11: Llamar a actualizarContador()
        actualizarContador()
    }

    private fun actualizarContador() {
        // TODO 12: Contar cuántas tareas tienen completada == false
        val pendientes = listaTareas.count { !it.completada }
        // TODO 13: Actualizar binding.tvContador.text
        binding.tvContador.text = "$pendientes tareas pendientes"
    }
}
