import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Tarea {
  final int id;
  final String titulo;
  bool completada;

  Tarea({required this.id, required this.titulo, this.completada = false});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      debugShowCheckedModeBanner: false,
      home: const PantallaTareas(),
    );
  }
}

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  final List<Tarea> _listaTareas = [];
  final TextEditingController _controladorTexto = TextEditingController();
  int _contadorId = 0;

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  void _agregarTarea() {
    final texto = _controladorTexto.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe una tarea primero')),
      );
      return;
    }

    setState(() {
      _contadorId++;
      _listaTareas.add(Tarea(id: _contadorId, titulo: texto));
      _controladorTexto.clear();
    });
  }

  void _eliminarTarea(int posicion) {
    setState(() {
      _listaTareas.removeAt(posicion);
    });
  }

  void _cambiarEstadoTarea(int posicion, bool valor) {
    setState(() {
      _listaTareas[posicion].completada = valor;
    });
  }

  int _tareasPendientes() {
    return _listaTareas.where((tarea) => !tarea.completada).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Mis Tareas',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorTexto,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _agregarTarea(),
                    decoration: const InputDecoration(
                      hintText: 'Escribe una tarea...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _agregarTarea,
                  child: const Text('Agregar'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              '${_tareasPendientes()} tareas pendientes',
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: _listaTareas.length,
                itemBuilder: (context, posicion) {
                  final tarea = _listaTareas[posicion];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: tarea.completada,
                          onChanged: (valor) {
                            _cambiarEstadoTarea(posicion, valor ?? false);
                          },
                        ),
                        Expanded(
                          child: Text(
                            tarea.titulo,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: tarea.completada
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _eliminarTarea(posicion),
                          tooltip: 'Eliminar tarea',
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
