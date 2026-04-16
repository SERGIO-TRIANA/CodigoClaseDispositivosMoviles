# Pokédex App - Flutter

App que consume la PokéAPI para mostrar imágenes pixel art y estadísticas de cualquier Pokémon.

## 🚀 Cómo usar este proyecto

### Opción A: Copiar archivos a un proyecto existente

1. Crea un proyecto Flutter nuevo:
   ```bash
   flutter create pokedex_app
   cd pokedex_app
   ```

2. Reemplaza el contenido de `lib/` con la carpeta `lib/` de este ZIP.

3. Reemplaza tu `pubspec.yaml` con el de este ZIP.

4. Instala dependencias y corre:
   ```bash
   flutter pub get
   flutter run
   ```

### Opción B: Usar directamente (si ya tienes Flutter instalado)

```bash
cd pokedex_app
flutter pub get
flutter run
```

## 📦 Dependencias

- `http: ^1.2.0` → Peticiones HTTP a la PokéAPI
- `cached_network_image: ^3.3.1` → Caché de imágenes

## 🗂️ Estructura

```
lib/
├── main.dart                     ← Punto de entrada
├── models/pokemon.dart           ← Clase Pokemon + Stat
├── services/pokemon_service.dart ← Llamadas a la PokéAPI
├── screens/pokedex_screen.dart   ← Pantalla principal
├── widgets/
│   ├── pixel_art_image.dart      ← Imagen retro con animación
│   ├── stats_card.dart           ← Barras de estadísticas animadas
│   └── tipo_badge.dart           ← Pastillas de tipo (fire, water...)
└── utils/tipo_colores.dart       ← Colores por tipo de Pokémon
```

## 🔍 Cómo buscar

- Por nombre: `pikachu`, `charizard`, `gengar`
- Por número: `25`, `6`, `94`
- Usa los chips de sugerencia rápida en la pantalla

## 🌐 API usada

PokéAPI → https://pokeapi.co (gratuita, sin API key)
