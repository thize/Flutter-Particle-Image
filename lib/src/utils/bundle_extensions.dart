part of particle_image;

extension RootBundleImage on AssetBundle {
  Future<ui.Image> loadImage(String key) async {
    ByteData bd = await load(key);
    final bytes = Uint8List.view(bd.buffer);
    final codec = await ui.instantiateImageCodec(bytes);
    return (await codec.getNextFrame()).image;
  }
}
