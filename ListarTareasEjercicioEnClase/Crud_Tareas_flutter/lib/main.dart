import 'package:flutter/material.dart';

// Punto de entrada de toda app Flutter
void main() {
  runApp(const MyApp()); // Le dice a Flutter qué widget mostrar
}

class Tarea {
  int id; // Identificador único
  String titulo; // Texto de la tarea
  bool completada; // Si está marcada como hecha o no

  Tarea({
    required this.id,
    required this.titulo,
    this.completada = false, // Por defecto no está completada
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD de Tareas',
      debugShowCheckedModeBanner: false, // Quita el banner rojo de "debug"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaTareas(), // Pantalla principal
    );
  }
}

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  final List<Tarea> _tareas = [];

  int _contadorId = 1;

  final TextEditingController _controller = TextEditingController();

  void _agregarTarea() {
    final texto = _controller.text.trim();

    if (texto.isEmpty) return;

    setState(() {
      _tareas.add(Tarea(id: _contadorId++, titulo: texto));
      _controller.clear();
    });
  }

  void _toggleCompletada(int id) {
    setState(() {
      final tarea = _tareas.firstWhere((t) => t.id == id);
      tarea.completada = !tarea.completada;
    });
  }

  void _editarTarea(Tarea tarea) {
    final editController = TextEditingController(text: tarea.titulo);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Título',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),

          ElevatedButton(
            onPressed: () {
              final nuevoTexto = editController.text.trim();
              if (nuevoTexto.isEmpty) return;
              setState(() {
                tarea.titulo = nuevoTexto;
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarTarea(int id) {
    setState(() {
      _tareas.removeWhere((t) => t.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nueva tarea...',
                      border: OutlineInputBorder(),
                    ),

                    onSubmitted: (_) => _agregarTarea(),
                  ),
                ),
                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: _agregarTarea,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${_tareas.length} tareas'),
                Text(
                  'Completadas: ${_tareas.where((t) => t.completada).length}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: _tareas.isEmpty
                ? const Center(
                    child: Text(
                      'No hay tareas aún.\n¡Agrega una arriba! 👆',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = _tareas[index];

                      return ListTile(
                        leading: Checkbox(
                          value: tarea.completada,
                          onChanged: (_) => _toggleCompletada(tarea.id),
                        ),

                        title: Text(
                          tarea.titulo,
                          style: TextStyle(
                            decoration: tarea.completada
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: tarea.completada ? Colors.grey : null,
                          ),
                        ),

                        subtitle: Text('ID: ${tarea.id}'),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarTarea(tarea),
                              tooltip: 'Editar',
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarTarea(tarea.id),
                              tooltip: 'Eliminar',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
