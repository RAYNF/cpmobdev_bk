//belum sama didownload

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/kategories_model.dart';
import 'package:mobile_inventory/data/models/product_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_inventory/presentation/utils/input_validators.dart';

class AddproductScreen extends StatefulWidget {
  final Product? produk;
  const AddproductScreen({super.key, this.produk});
  static const routeName = '/addproduct';

  @override
  State<AddproductScreen> createState() => _AddproductScreenState();
}

class _AddproductScreenState extends State<AddproductScreen> {
  Dbhelper db = Dbhelper();
  TextEditingController? nama = TextEditingController();
  TextEditingController? deskripsi = TextEditingController();
  TextEditingController? harga = TextEditingController();
  TextEditingController? stock = TextEditingController();
  // TextEditingController? kategori = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  final String defaultImage = 'assets/images/episode1.jpg';
  String imagepath = "";
  String imageBase64 = "";

  List<Kategories> kategoriList = [];
  int? selectedKategoriId;
  final _formKey = GlobalKey<FormState>();

  // openImage() async {
  //   try {
  //     var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       imagepath = pickedFile.path;

  //       File imageFile = File(imagepath);
  //       Uint8List imagebytes = await imageFile.readAsBytes();
  //       String base64string = base64.encode(imagebytes);

  //       setState(() {
  //         imageBase64 = base64string;
  //       });
  //     } else {
  //       print("No image selected");
  //     }
  //   } catch (e) {
  //     print("error whiling picking file");
  //   }
  // }

  Future<void> openImage(ImageSource sources) async {
    try {
      final pickedFile = await imgpicker.pickImage(source: sources);

      if (pickedFile != null) {
        imagepath = pickedFile.path;

        File imageFile = File(imagepath);
        Uint8List imagebytes = await imageFile.readAsBytes();
        String base64string = base64.encode(imagebytes);

        setState(() {
          imageBase64 = base64string;
        });
      }
    } catch (e) {
      print("error whiling picking file");
    }
  }

  Future<void> upsertProduct() async {
    if (widget.produk != null) {
      final updatedProduct = Product.fromMap({
        'id': widget.produk!.getId,
        'nama': nama!.text,
        'deskripsi': deskripsi!.text,
        'harga': int.parse(harga!.text),
        // 'kategori': int.parse(kategori!.text),
        'kategori': selectedKategoriId!,
        'stock': int.parse(stock!.text),
        'gambar': imageBase64,
      });

      await db.updateProduct(updatedProduct);

      final productData =
          await db.getProductWithCategoryById(updatedProduct.getId);

      Navigator.pushReplacementNamed(context, '/detail',
          arguments: productData);

      // Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // final data = Product(
      //   nama!.text,
      //   deskripsi!.text,
      //   harga!.text,
      //   int.parse(kategori!.text),
      //   imageBase64.isNotEmpty
      //       ? imageBase64
      //       : base64.encode(
      //           await loadDefaultImageBytes(),
      //         ),
      // );

      // print(data.toMap());

      await db.saveProduct(
        Product(
          nama!.text,
          deskripsi!.text,
          int.parse(harga!.text),
          // int.parse(kategori!.text),
          selectedKategoriId!,
          int.parse(stock!.text),
          imageBase64.isNotEmpty
              ? imageBase64
              : base64.encode(
                  await loadDefaultImageBytes(),
                ),
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<Uint8List> loadDefaultImageBytes() async {
    ByteData bytes = await DefaultAssetBundle.of(context).load(defaultImage);
    return bytes.buffer.asUint8List();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await db.getAllKategoris();
      setState(() {
        kategoriList = categories;
        if (widget.produk != null) {
          selectedKategoriId = widget.produk!.getKategori;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load categories"),
        ),
      );
    }
  }

  @override
  void initState() {
    nama = TextEditingController(
        text: widget.produk == null ? '' : widget.produk!.getName);
    deskripsi = TextEditingController(
        text: widget.produk == null ? '' : widget.produk!.getDeskripsi);
    harga = TextEditingController(
        text: widget.produk == null
            ? 0.toString()
            : widget.produk!.getHarga.toString());
    stock = TextEditingController(
        text: widget.produk == null
            ? 0.toString()
            : widget.produk!.getStock.toString());
    // kategori = TextEditingController(
    //     text: widget.produk == null
    //         ? 0.toString()
    //         : widget.produk!.getKategori.toString());

    imageBase64 = widget.produk == null ? '' : widget.produk!.getGambar;

    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Product"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // TextField(
            //   controller: nama,
            //   decoration: InputDecoration(
            //       labelText: 'Nama barang',
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(8))),
            // ),
            TextFormField(
              // onChanged: (String value) {
              //   setState(() {
              //     nama!.text = value;
              //   });
              // },
              controller: nama,
              validator: notEmptyString,
              decoration: InputDecoration(
                labelText: "Nama barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // TextField(
            //   controller: deskripsi,
            //   decoration: InputDecoration(
            //       labelText: 'Deskripsi',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       )),
            // ),

            TextFormField(
              // onChanged: (String value) {
              //   setState(() {
              //     deskripsi!.text = value;
              //   });
              // },
              controller: deskripsi,
              validator: notEmptyString,
              decoration: InputDecoration(
                labelText: "Deskripsi barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // TextField(
            //   controller: harga,
            //   decoration: InputDecoration(
            //       labelText: 'Harga',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       )),
            // ),

            TextFormField(
              // onChanged: (String value) {
              //   setState(() {
              //     harga!.text = value;
              //   });
              // },
              controller: harga,
              validator: notEmptyInt,
              decoration: InputDecoration(
                labelText: "Harga barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // TextField(
            //   controller: kategori,
            //   decoration: InputDecoration(
            //       labelText: 'Kategori',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       )),
            // ),

            DropdownButtonFormField<int>(
              validator: notEmptyInt,
              value: selectedKategoriId,
              items: kategoriList.map((kategori) {
                return DropdownMenuItem<int>(
                  value:
                      kategori.getId, // Nilai yang dikirim adalah ID kategori
                  child: Text(kategori.getName), // Nama yang ditampilkan
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategoriId =
                      value; // Perbarui ID kategori yang dipilih
                });
              },
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              // onChanged: (String value) {
              //   setState(() {
              //     harga!.text = value;
              //   });
              // },
              controller: stock,
              validator: notEmptyInt,
              decoration: InputDecoration(
                labelText: "Stock barang",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: imageBase64.isNotEmpty
                      ? Image.memory(Base64Decoder().convert(imageBase64))
                      : Image.asset(defaultImage, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async =>
                          await openImage(ImageSource.camera),
                      icon: const Icon(Icons.camera),
                      label: const Text("Camera"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async =>
                          await openImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo),
                      label: const Text("Gallery"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // upsertProduct();
                if (_formKey.currentState!.validate()) {
                  upsertProduct();
                }
                // try {
                //   if (_formKey.currentState!.validate()) {
                //     upsertProduct();
                //   }
                // } catch (e) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content:
                //           Text("Gagal proses karena masih ada yang kosong"),
                //     ),
                //   );
                // }
              },
              child: widget.produk == null
                  ? const Text('Add')
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

//sudah sama didownload

// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mobile_inventory/data/helpers/dbhelper.dart';
// import 'package:mobile_inventory/data/models/product_models.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart';

// class AddproductScreen extends StatefulWidget {
//   final Product? produk;
//   const AddproductScreen({super.key, this.produk});
//   static const routeName = '/addproduct';

//   @override
//   State<AddproductScreen> createState() => _AddproductScreenState();
// }

// class _AddproductScreenState extends State<AddproductScreen> {
//   Dbhelper db = Dbhelper();
//   TextEditingController? nama;
//   TextEditingController? deskripsi;
//   TextEditingController? harga;
//   TextEditingController? kategori;

//   final ImagePicker imgpicker = ImagePicker();
//   String imageBase64 = "";
//   String savedImagePath = ""; // Path untuk menyimpan foto sementara

//   // Fungsi untuk mendapatkan Base64 gambar default
//   Future<String> getDefaultImageBase64() async {
//     // Mengambil gambar dari asset dan mengonversinya menjadi Base64
//     final ByteData data = await rootBundle.load('assets/images/default_image.png');
//     final buffer = data.buffer.asUint8List();
//     return base64.encode(buffer);
//   }

//   Future<void> pickImage(ImageSource source) async {
//     try {
//       var pickedFile = await imgpicker.pickImage(source: source);
//       if (pickedFile != null) {
//         File imageFile = File(pickedFile.path);
//         Uint8List imageBytes = await imageFile.readAsBytes();

//         // Simpan gambar ke direktori lokal
//         savedImagePath = await saveImageToLocal(imageBytes);

//         // Konversi ke Base64 untuk disimpan di database
//         setState(() {
//           imageBase64 = base64.encode(imageBytes);
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   Future<String> saveImageToLocal(Uint8List imageBytes) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/product_image_${DateTime.now().millisecondsSinceEpoch}.png';
//     final file = File(filePath);
//     await file.writeAsBytes(imageBytes);
//     return filePath;
//   }

//   Future<void> downloadImage() async {
//     if (savedImagePath.isNotEmpty) {
//       try {
//         // Mendapatkan direktori download
//         final downloadDirectory = await getExternalStorageDirectory();
//         final fileName = 'product_image_download.png';
//         final downloadPath = '${downloadDirectory!.path}/$fileName';
//         final downloadedImage = File(savedImagePath);

//         // Salin gambar ke direktori download
//         await downloadedImage.copy(downloadPath);

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image downloaded to $downloadPath')));
//       } catch (e) {
//         print('Error downloading image: $e');
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error downloading image')));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image to download')));
//     }
//   }

//   Future<void> upsertProduct() async {
//     // Jika tidak ada gambar yang diupload, gunakan gambar default
//     final imageToSave = imageBase64.isNotEmpty ? imageBase64 : await getDefaultImageBase64();

//     if (widget.produk != null) {
//       final updatedProduct = Product.fromMap({
//         'id': widget.produk!.getId,
//         'nama': nama!.text,
//         'deskripsi': deskripsi!.text,
//         'harga': harga!.text,
//         'kategori': kategori!.text,
//         'gambar': imageToSave,
//       });

//       await db.updateProduct(updatedProduct);
//       Navigator.pushReplacementNamed(context, '/detail', arguments: updatedProduct);
//     } else {
//       await db.saveProduct(Product(
//         nama!.text,
//         deskripsi!.text,
//         harga!.text,
//         kategori!.text,
//         imageToSave,
//       ));

//       Navigator.pushReplacementNamed(context, '/dashboard');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     nama = TextEditingController(
//         text: widget.produk == null ? '' : widget.produk!.getName);
//     deskripsi = TextEditingController(
//         text: widget.produk == null ? '' : widget.produk!.getDeskripsi);
//     harga = TextEditingController(
//         text: widget.produk == null ? '' : widget.produk!.getHarga);
//     kategori = TextEditingController(
//         text: widget.produk == null ? '' : widget.produk!.getKategori);
//     imageBase64 = widget.produk == null ? '' : widget.produk!.getGambar;
//   }

//   Widget buildImageDisplay() {
//     if (savedImagePath.isNotEmpty) {
//       return Image.file(File(savedImagePath), fit: BoxFit.cover);
//     } else if (imageBase64.isNotEmpty) {
//       return Image.memory(Base64Decoder().convert(imageBase64), fit: BoxFit.cover);
//     } else {
//       return Image.asset('assets/images/episode1.jpg', fit: BoxFit.cover);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Form Product"),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           TextField(
//             controller: nama,
//             decoration: InputDecoration(
//               labelText: 'Nama barang',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: deskripsi,
//             decoration: InputDecoration(
//               labelText: 'Deskripsi',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: harga,
//             decoration: InputDecoration(
//               labelText: 'Harga',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: kategori,
//             decoration: InputDecoration(
//               labelText: 'Kategori',
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Center(
//             child: Column(
//               children: [
//                 Container(
//                   width: 200,
//                   height: 200,
//                   child: buildImageDisplay(),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   onPressed: () => pickImage(ImageSource.gallery),
//                   icon: const Icon(Icons.photo),
//                   label: const Text("Pilih dari Galeri"),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   onPressed: () => pickImage(ImageSource.camera),
//                   icon: const Icon(Icons.camera),
//                   label: const Text("Ambil dari Kamera"),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   onPressed: downloadImage,
//                   icon: const Icon(Icons.download),
//                   label: const Text("Download Gambar"),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: upsertProduct,
//             child: Text(widget.produk == null ? 'Add' : 'Update'),
//           ),
//         ],
//       ),
//     );
//   }
// }