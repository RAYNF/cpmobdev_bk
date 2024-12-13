import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/helpers/dbhelper.dart';
import 'package:mobile_inventory/data/models/product_models.dart';
import 'package:mobile_inventory/data/models/productcategories_model.dart';
import 'package:mobile_inventory/presentation/widgets/itemdashboard_widget.dart';

class AllproductScreen extends StatefulWidget {
  const AllproductScreen({super.key});

  @override
  State<AllproductScreen> createState() => _AllproductScreenState();
}

class _AllproductScreenState extends State<AllproductScreen> {
  List<ProductWithCategory> listProduct = [];

  Dbhelper db = Dbhelper();

  Future<void> _getAllProduct() async {
    // var list = await db.getAllProduk();
    var list = await db.getAllProdukWithKategoriName();

    // setState(() {
    //   listProduct.clear();
    //   for (var product in list!) {
    //     listProduct.add(
    //       Product.fromMap(product),
    //     );
    //   }
    // });

    setState(() {
      listProduct = list;
    });
  }

  // void cekHarga() {
  //   harga = 0;
  //   for (int i = 0; i < listProductOrder.length; i++) {
  //     harga += int.parse(listProductOrder[i].getHarga);
  //   }
  // }

  // Widget gridContent(String nama, String desc, int harga, String img,
  //     String kategori, int index) {
  //   return Container(
  //     margin: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: Colors.grey,
  //       ),
  //       borderRadius: BorderRadius.circular(30),
  //     ),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: 10,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             listProductOrder.add(listProduct[index]);
  //             // cekHarga();
  //             setState(() {});
  //           },
  //           child: Container(
  //             width: 100,
  //             height: 100,
  //             child: Image.memory(
  //               Base64Decoder().convert(img),
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             showDialog(
  //                 context: context,
  //                 builder: (context) {
  //                   return AlertDialog(
  //                     title: Text('Detail Product'),
  //                     content: Container(
  //                       height: 300,
  //                       width: 300,
  //                       child: Text(desc),
  //                     ),
  //                   );
  //                 });
  //           },
  //           child: Text(
  //             nama,
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black54,
  //             ),
  //           ),
  //         ),
  //         Text(
  //           'Rp ${harga.toString()}',
  //           style:
  //               TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
  //         ),
  //         Text(
  //           kategori,
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black54,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget gridContent(Product barang) {
  //   return Container(
  //     margin: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: Colors.grey,
  //       ),
  //       borderRadius: BorderRadius.circular(30),
  //     ),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: 10,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             // listProductOrder.add(listProduct[index]);
  //             // cekHarga();
  //             setState(() {});
  //           },
  //           child: Container(
  //             width: 100,
  //             height: 100,
  //             child: Image.memory(
  //               Base64Decoder().convert(barang.getGambar),
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             showDialog(
  //                 context: context,
  //                 builder: (context) {
  //                   return AlertDialog(
  //                     title: Text('Detail Product'),
  //                     content: Container(
  //                       height: 300,
  //                       width: 300,
  //                       child: Text(barang.getDeskripsi),
  //                     ),
  //                   );
  //                 });
  //           },
  //           child: Text(
  //             barang.getName,
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black54,
  //             ),
  //           ),
  //         ),
  //         Text(
  //           'Rp ${barang.getHarga.toString()}',
  //           style:
  //               TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
  //         ),
  //         Text(
  //           barang.getKategori,
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black54,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    _getAllProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addproduct');
        },
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 250,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              return ItemdashboardWidget(
                barang: listProduct[index],
              );
            }),
      )),
    );
  }
}
