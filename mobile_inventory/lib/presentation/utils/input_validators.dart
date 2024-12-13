String? notEmptyString(var value) {
  if (value == null || value.isEmpty) {
    return "Isian Tidak Boleh Kosong";
  } else {
    return null;
  }
}

String? notEmptyInt(var value) {
  if (value == null) {
    return "Isian Tidak Boleh Kosong";
  } else {
    return null;
  }
}
