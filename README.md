# smoothing

A flutter package implemented moving average, exponential moving average, and SG filtering

## Getting Started

All methods supports list of `int` or `double`. Exceptions will throw if the data type is neither of them.

## How to use

```dart
import 'package:smoothing/smoothing.dart';

void main(){
  SgFilter filter = new SgFilter(3, 11);
  List<double> x = [
    0.954886430307147,
    -0.601120319370960,
    -1.17189080414528,
    -0.577110307096737,
    -0.836430524453065,
    0.852969530087173,
    0.477331178676579,
    0.302320074946896,
    0.415776190617897,
    0.0429748293046916,
    -0.948853230057176,
    0.541608366255458,
    -0.821128258718891,
    -1.07190504844909,
    -1.07409163637826,
    0.869552807313267,
    0.981051414525262,
    -1.75882536913901,
    -0.148095957567039,
    0.251941746175391,
  ];
  List<double> result = filter.smooth(x);

}
```
