part of particle_image;

class PD_Size extends PD_Progress<PD_Size, Size> {
  final PD_Number width;
  final PD_Number height;

  const PD_Size({
    this.width = const PD_NumberConstant(50),
    this.height = const PD_NumberConstant(50),
  });

  @override
  Size value(double progress) {
    return Size(
      width.value(progress),
      height.value(progress),
    );
  }

  @override
  PD_Size clone() {
    return PD_Size(
      width: width.clone(),
      height: height.clone(),
    );
  }
}
