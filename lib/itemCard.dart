import 'package:flutter/material.dart';
import 'boleta.dart';

class ItemCard extends StatelessWidget {
  final Boleta boleta;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const ItemCard({
    super.key,
    required this.boleta,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      color: isFavorite ? colors.primaryContainer : colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  boleta.imagenPath,
                  width: 72,
                  height: 108,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 72,
                      height: 108,
                      color: colors.surfaceContainerHighest,
                      child: const Icon(
                        Icons.confirmation_number_outlined,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boleta.evento,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isFavorite
                            ? colors.onPrimaryContainer
                            : colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Asiento ${boleta.asiento}',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Icon(
                          boleta.vendida
                              ? Icons.do_not_disturb_on_outlined
                              : Icons.event_available_outlined,
                          size: 16,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            boleta.vendida ? 'Vendida' : 'Disponible',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: isFavorite ? 'Quitar favorita' : 'Marcar como favorita',
                onPressed: onFavoriteTap,
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                color: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
