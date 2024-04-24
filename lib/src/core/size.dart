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

class PD_SizeCurve extends PD_Size {
  final Curve curve;
  final PD_Size begin;
  final PD_Size end;

  const PD_SizeCurve({
    required this.curve,
    required this.begin,
    required this.end,
  });

  @override
  Size value(double progress) {
    return Size(
      lerpDouble(
          begin.width.value(0), end.width.value(0), curve.transform(progress))!,
      lerpDouble(begin.height.value(0), end.height.value(0),
          curve.transform(progress))!,
    );
  }

  @override
  PD_SizeCurve clone() {
    return PD_SizeCurve(
      curve: curve,
      begin: begin.clone(),
      end: end.clone(),
    );
  }
}
