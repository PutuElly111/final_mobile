import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshoe/inputdata/editData.dart';

class DataTampil extends StatefulWidget {
  @override
  _DataTampilState createState() => _DataTampilState();
}

class _DataTampilState extends State<DataTampil> {
  //inget ganti yang isi 192.168.1.3 ini sesuaikan sama IP punya mu yang di IPConfig
  final String url = "http://127.0.0.1/api/inputs";
  Future getInput() async {
    var response = await http.get(Uri.parse(url));
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }

  Future deleteData(String dataId) async {
    final String url = "http://127.0.0.1/api/inputs/" + dataId;
    var response = await http.delete(Uri.parse(url));

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Pelanggan"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        width: double.maxFinite,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: getInput(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data['data'].length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Card(
                                  elevation: 8,
                                  child: ListTile(
                                    leading: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditData(
                                                    input: snapshot.data['data']
                                                        [index])));
                                      },
                                    ),
                                    title: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Nama Sepatu : " +
                                                  snapshot.data['data'][index]
                                                      ['nama_sepatu']),
                                              IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    // yang ini diemin ya ini untuk hapus datanya
                                                    // jadi index yang di ambil itu dari ID datanya misalkan ID 1 berarti data ke 1 yang di hapus
                                                    deleteData(snapshot
                                                            .data['data'][index]
                                                                ['id']
                                                            .toString())
                                                        .then((value) {
                                                      setState(() {});
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Data sudah dihapus")));
                                                    });
                                                  })
                                            ],
                                          ),
                                          Text("Warna :" +
                                              snapshot.data['data'][index]
                                                  ['warna']),
                                          Text("Ukuran :" +
                                              snapshot.data['data'][index]
                                                  ['ukuran']),
                                          Text("Harga : Rp. " +
                                              snapshot.data['data'][index]
                                                  ['harga']),
                                          Text("Jumlah :" +
                                              snapshot.data['data'][index]
                                                  ['jumlah']),
                                        ],
                                      ),
                                    ),
                                  )));
                        });
                  } else {
                    return Text("Error");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
