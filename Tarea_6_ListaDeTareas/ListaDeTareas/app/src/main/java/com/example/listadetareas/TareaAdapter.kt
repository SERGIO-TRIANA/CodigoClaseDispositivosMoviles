package com.example.listadetareas

import android.graphics.Paint
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.listadetareas.databinding.ItemTareaBinding

class TareaAdapter(
    private val tareas: MutableList<Tarea>,
    private val onEliminar: (Int) -> Unit,
    private val onToggle: () -> Unit
) : RecyclerView.Adapter<TareaAdapter.TareaViewHolder>() {

    inner class TareaViewHolder(val binding: ItemTareaBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TareaViewHolder {
        val binding = ItemTareaBinding.inflate(
            LayoutInflater.from(parent.context), parent, false
        )
        return TareaViewHolder(binding)
    }

    override fun onBindViewHolder(holder: TareaViewHolder, position: Int) {
        val tarea = tareas[position]

        // TODO 1: Asignar el título de la tarea al TextView
        holder.binding.tvTitulo.text = tarea.titulo

        // TODO 2: Asignar el estado de completada al CheckBox
        holder.binding.cbCompletada.isChecked = tarea.completada

        actualizarEstiloTexto(holder, tarea.completada)

        // TODO 3: Listener del CheckBox — cuando cambie, actualizar tarea.completada
        //         y llamar a actualizarEstiloTexto con el nuevo estado
        holder.binding.cbCompletada.setOnCheckedChangeListener { _, isChecked ->
            tarea.completada = isChecked
            actualizarEstiloTexto(holder, isChecked)
            onToggle()
        }

        // TODO 4: Listener del botón eliminar — llamar a onEliminar(position)
        holder.binding.btnEliminar.setOnClickListener {
            onEliminar(position)
        }
    }

    override fun getItemCount(): Int = tareas.size

    // Esta función tacha o destacha el texto según el estado
    private fun actualizarEstiloTexto(holder: TareaViewHolder, completada: Boolean) {
        if (completada) {
            holder.binding.tvTitulo.paintFlags =
                holder.binding.tvTitulo.paintFlags or Paint.STRIKE_THRU_TEXT_FLAG
        } else {
            holder.binding.tvTitulo.paintFlags =
                holder.binding.tvTitulo.paintFlags and Paint.STRIKE_THRU_TEXT_FLAG.inv()
        }
    }
}
