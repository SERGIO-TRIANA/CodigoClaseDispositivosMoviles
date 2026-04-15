package com.example.listadetareas

/*
 * Respuestas a preguntas del Cierre:
 *
 * 1. ¿Cuál es la diferencia entre val y var?
 *    'val' se utiliza para variables de solo lectura (inmutables), mientras que 'var'
 *    se utiliza para variables cuyo valor puede cambiar (mutables).
 *
 * 2. ¿Para qué sirve el operador ?: (Elvis)?
 *    Sirve para proporcionar un valor por defecto en caso de que una expresión sea nula.
 *    Si el lado izquierdo no es nulo, lo devuelve; si es nulo, devuelve el lado derecho.
 *
 * 3. ¿Qué genera automáticamente una data class que una clase normal no?
 *    Genera automáticamente los métodos equals(), hashCode(), toString(), copy()
 *    y las funciones componentN() para desestructuración.
 *
 * 4. ¿Qué hace el Adapter en un RecyclerView?
 *    Actúa como un puente entre los datos y la interfaz de usuario. Se encarga de
 *    crear los ViewHolders y de vincular (bind) los datos de la lista con cada vista individual.
 *
 * 5. ¿Por qué usar View Binding en lugar de findViewById?
 *    View Binding es más seguro porque ofrece seguridad de tipos (Type safety) y
 *    seguridad frente a nulos (Null safety), además de evitar errores en tiempo de
 *    ejecución y reducir el código repetitivo.
 */
