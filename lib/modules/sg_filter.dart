import 'package:linalg/linalg.dart';
import 'dart:math';

class SgFilter{
  int _order;
  int _frameLength;
  int _size;
  Matrix _kernel;

  /// The constructor for SgFilter
  /// Arguments:
  ///   - _order: int, the order of polynomial.
  ///   - _frameLength: int, the windows size for smoothing.
  /// Return:
  ///   - SgFilter
  SgFilter(this._order, this._frameLength){
    _size = _frameLength ~/ 2;
    _kernel = this._buildKernel();
  }


  /// Build the kernel for smoothing
  /// Arguments:
  ///   - void
  /// Return:
  ///   - Matrix: the kernel for smoothing
  Matrix _buildKernel(){
    List<double> baseSeq = [];
    List<List<double>> tempMatrix = [];
    Matrix matrix;
    Matrix kernel;

    // construct base sequence
    for (int i = -_size; i <= _size; i++){
      baseSeq.add(i.toDouble());
    }

    // fill the tempMatrix
    for(int i = 0; i < _order; i++){
      List<double> tempSeq = [];

      // make row
      for(double val in baseSeq){
        tempSeq.add(pow(val, i));
      }

      // add row
      tempMatrix.add(tempSeq);
    }

    // convert List<List<double>> to Matrix
    matrix = new Matrix(tempMatrix).transpose();

    // Calculate the kernel
    kernel = matrix * (matrix.transpose() * matrix).inverse() * matrix.transpose();

    return kernel;
  }


  /// Smooth given data
  /// Arguments:
  ///   - x: List<dynamic>, input data, only support int/double type.
  /// Return:
  ///   - List<dynamic>: Data after smoothing
  /// Throws:
  ///   - FormatException:
  ///      - if the data type is neither int nor double.
  ///      - Or the input length < _frameLength
  List<dynamic> smooth(List<dynamic> x){
    List<double> dataAfterSmooth = [];
    List<double> inputData = [];

    // validate input data
    if(x.length < _frameLength){
      throw FormatException("The length of input must be >= _frameLength. (_frameLength=$_frameLength; input=${x.length})");
    }
    if(x[0].runtimeType != 0.runtimeType && x[0].runtimeType != 1.0.runtimeType){
      throw FormatException("Only support int/double, get: ${x[0].runtimeType}!");
    }

    // convert List<int> to List<double> if needed
    if(x[0].runtimeType == 0.runtimeType){
      for(int val in x){
        inputData.add(val * 1.0);
      }

    }else{
      inputData = x;
    }

    // add padding
    // adding padding in the front
    for(int i = 0; i < _size; i++){
      inputData.insert(0, 1);
    }

    // adding padding at the end
    for(int i = 0; i < _size; i++){
      inputData.add(1);
    }

    // smoothing input data
    for(int i = _size; i < inputData.length - _size; i++){
      List<List<double>> tempWin = [inputData.sublist(i-_size, i+_size+1)];
      Matrix windowX = new Matrix(tempWin).transpose();
      dataAfterSmooth.add((_kernel * windowX)[_size][0]);
    }

    return dataAfterSmooth;
  }


  /// getters
  int get order{
    return _order;
  }

  int get frameLength{
    return _frameLength;
  }

  Matrix get kernel{
    return _kernel;
  }
}




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