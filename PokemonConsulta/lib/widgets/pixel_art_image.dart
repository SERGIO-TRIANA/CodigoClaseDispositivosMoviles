// ============================================================
// WIDGET: PixelArtImage
// Muestra el sprite pixel art del Pokémon con animación bounce
// El truco: Image.network con filterQuality.none mantiene
// los píxeles nítidos (sin suavizado) para el look retro
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PixelArtImage extends StatefulWidget {
  final String url;
  final double size;

  const PixelArtImage({
    super.key,
    required this.url,
    this.size = 180,
  });

  @override
  State<PixelArtImage> createState() => _PixelArtImageState();
}

class _PixelArtImageState extends State<PixelArtImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // TweenSequence: secuencia de valores para una animación de rebote
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -20.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -20.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void didUpdateWidget(PixelArtImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nueva imagen → nueva animación
    if (oldWidget.url != widget.url) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnim,
      builder: (context, child) {
        // Transform.translate mueve el widget verticalmente
        return Transform.translate(
          offset: Offset(0, _bounceAnim.value),
          child: child,
        );
      },
      child: CachedNetworkImage(
        imageUrl: widget.url,
        width: widget.size,
        height: widget.size,
        // filterQuality.none = píxeles nítidos, look retro 8-bit
        filterQuality: FilterQuality.none,
        fit: BoxFit.contain,
        // Widget mientras carga
        placeholder: (context, url) => SizedBox(
          width: widget.size,
          height: widget.size,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        // Widget si hay error de red
        errorWidget: (context, url, error) => SizedBox(
          width: widget.size,
          height: widget.size,
          child: const Icon(Icons.error, size: 60, color: Colors.red),
        ),
      ),
    );
  }
}
