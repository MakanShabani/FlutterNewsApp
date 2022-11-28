import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_cubit/image_cubit.dart';

class CustomeImage extends StatelessWidget {
  const CustomeImage({
    Key? key,
    required this.borderRadious,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
  }) : super(key: key);

  final double borderRadious;
  final String imageUrl;
  final double? height; // default is 100
  final double? width; // default is 100
  final BoxFit? fit; // default is BoxFit.Fill

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadious),
      child: BlocProvider(
        create: (context) => ImageCubit(),
        child: BlocBuilder<ImageCubit, ImageState>(
          builder: (context, state) {
            return Image.network(
              imageUrl,
              key: UniqueKey(),
              height: height ?? 100.0,
              width: width ?? 100.0,
              fit: fit ?? BoxFit.fill,
              errorBuilder: (context, exception, stackTrace) => SizedBox(
                height: height ?? 100.0,
                width: width ?? 100.0,
                child: Center(
                  child: IconButton(
                      onPressed: () => context.read<ImageCubit>().reload(),
                      icon: const Icon(Icons.refresh_rounded)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
