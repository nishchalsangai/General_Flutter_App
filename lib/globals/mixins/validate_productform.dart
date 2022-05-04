class ValidateProductFormMixin {

  String? productName(value) {
    if (value!.toString().isEmpty) {
      return 'This field cannot be left empty';
    } else if (value!.length < 5) {
      return 'Enter at least 5 characters';
    } else if (value.length > 30) {
      return 'Enter at most 30 characters';
    } else {
      return null;
    }
  }

  String? productDescription(value) {
    if (value!.toString().isEmpty) {
      return 'This field cannot be left empty';
    } else if (value!.length < 10) {
      return 'Enter at least 10 characters';
    } else if (value.length > 150) {
      return 'Enter at most 150 characters';
    } else {
      return null;
    }
  }

  String? productPrice(value) {
    if (value!.toString().isEmpty) {
      return 'This field cannot be left empty';
    } else if (double.parse(value!.toString()) < 0) {
      return 'Price can not be in negative';
    } else {
      return null;
    }
  }
}
