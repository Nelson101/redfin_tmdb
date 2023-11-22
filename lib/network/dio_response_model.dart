class DioResponseModel<T extends dynamic> {
  bool success;
  String? msg = "";
  T? data;

  DioResponseModel({
    this.success = false,
    this.data,
    this.msg = "",
  });

  factory DioResponseModel.convertDataType(DioResponseModel<T> res) {
    return DioResponseModel<T>(
      success: res.success,
      data: res.data,
      msg: res.msg,
    );
  }
}