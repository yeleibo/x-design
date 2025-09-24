import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'my_location_controller.dart';
///在地图上的我的位置标记图层
class XDMyPositionMarkLayer extends StatelessWidget {
  final XDMyLocationController myLocationController;
  const XDMyPositionMarkLayer({super.key,required this.myLocationController});

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider.value(
      value: myLocationController,
      child: Selector<XDMyLocationController, LatLng?>(
        builder: (context, myPosition, child) {
          return myPosition == null
              ? const SizedBox()
              : MarkerLayer(markers: [
            //我的方向
            Marker(
                point: formateFromW84ToOther(myLocationController.mapCode, myPosition),
                width: 120,
                height: 120,
                child: StreamBuilder<_LocationMarkerHeading>(
                    stream:
                    (FlutterCompass.events ?? const Stream.empty())
                        .where((CompassEvent compassEvent) =>
                    compassEvent.heading != null)
                        .map((CompassEvent compassEvent) {
                      return _LocationMarkerHeading(
                        heading: degToRadian(compassEvent.heading!),
                        accuracy:
                        (compassEvent.accuracy ?? pi * 0.3).clamp(
                          pi * 0.1,
                          pi * 0.4,
                        ),
                      );
                    }),
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<_LocationMarkerHeading> snapshot,
                        ) {
                      if (snapshot.hasData) {
                        return TweenAnimationBuilder(
                            tween: LocationMarkerHeadingTween(
                              begin: _LocationMarkerHeading(
                                  heading: snapshot.data!.heading,
                                  accuracy: snapshot.data!.accuracy),
                              end: _LocationMarkerHeading(
                                  heading: snapshot.data!.heading,
                                  accuracy: snapshot.data!.accuracy),
                            ),
                            duration: const Duration(milliseconds: 200),
                            builder: (
                                BuildContext context,
                                _LocationMarkerHeading heading,
                                Widget? child,
                                ) {
                              return CustomPaint(
                                size: const Size.fromRadius(
                                  60,
                                ),
                                painter: _HeadingSector(
                                  const Color.fromARGB(
                                      0xCC, 0x21, 0x96, 0xF3),
                                  heading.heading,
                                  pi * 0.2,
                                ),
                              );
                            });
                      } else {
                        return const SizedBox();
                      }
                    })),
            //我的位置
            Marker(
              point: formateFromW84ToOther(myLocationController.mapCode, myPosition),
              width: 20,
              height: 20,
              child: const _DefaultLocationMarker(),
            ),
          ]);
        },
        selector: (context, controller) => controller.myPosition,
      ),
    );
  }
}


/// A angle with accuracy for marker rendering.
class _LocationMarkerHeading {
  /// The heading, in radius, which 0 radians being the north and positive
  /// angles going clockwise.
  final double heading;

  /// The estimated accuracy of this heading, in radius.The smaller value, the
  /// better accuracy.
  final double accuracy;

  /// Create a LocationMarkerHeading.
  _LocationMarkerHeading({
    required this.heading,
    required this.accuracy,
  });
}

class LocationMarkerHeadingTween extends Tween<_LocationMarkerHeading> {
  /// Creates a tween.
  LocationMarkerHeadingTween({
    required _LocationMarkerHeading begin,
    required _LocationMarkerHeading end,
  }) : super(
    begin: begin,
    end: end,
  );

  @override
  _LocationMarkerHeading lerp(double t) {
    final begin = super.begin!;
    final end = super.end!;
    return _LocationMarkerHeading(
      heading: _radiusLerp(begin.heading, end.heading, t),
      accuracy: _radiusLerp(begin.accuracy, end.accuracy, t),
    );
  }

  double _doubleLerp(double begin, double end, double t) =>
      begin + (end - begin) * t;

  double _radiusLerp(double begin, double end, double t) {
    const twoPi = 2 * pi;
    // ignore: parameter_assignments
    begin = begin % twoPi;
    // ignore: parameter_assignments
    end = end % twoPi;

    final compareResult = (end - begin).abs().compareTo(pi);
    final crossZero = compareResult == 1 ||
        (compareResult == 0 && begin != end && begin >= pi);
    if (crossZero) {
      double shift(double value) {
        return (value + pi) % twoPi;
      }

      return shift(_doubleLerp(shift(begin), shift(end), t));
    } else {
      return _doubleLerp(begin, end, t);
    }
  }
}

class _DefaultLocationMarker extends StatelessWidget {
  /// The color of the marker.
  final Color color;

  /// Typically the marker's icon.
  final Widget? child;

  /// Create a DefaultLocationMarker.
  const _DefaultLocationMarker({
    super.key,
    this.color = const Color.fromARGB(0xFF, 0x21, 0x96, 0xF3),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _HeadingSector extends CustomPainter {
  /// The color of this sector origin. The actual color is multiplied by a
  /// opacity factor which decreases when the distance to the origin increases.
  final Color color;

  /// The heading, in radius, which define the direction of the middle point of
  /// this sector. See [LocationMarkerHeading.heading].
  final double heading;

  /// The accuracy, in radius, which affect the length of this sector. The
  /// actual length of this sector is `accuracy * 2`. See
  /// [LocationMarkerHeading.accuracy].
  final double accuracy;

  /// Create a HeadingSector.
  _HeadingSector(this.color, this.heading, this.accuracy);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    canvas.drawArc(
      rect,
      pi * 3 / 2 + heading - accuracy,
      accuracy * 2,
      true,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(color.opacity * 1.0),
            color.withOpacity(color.opacity * 0.6),
            color.withOpacity(color.opacity * 0.3),
            color.withOpacity(color.opacity * 0.1),
            color.withOpacity(color.opacity * 0.0),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_HeadingSector oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.heading != heading ||
        oldDelegate.accuracy != accuracy;
  }
}