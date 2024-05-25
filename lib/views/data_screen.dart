import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../viewmodels/data_viewmodel.dart';

class DataScreen extends StatelessWidget {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dataController,
                    decoration: InputDecoration(labelText: 'Enter Data'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_dataController.text.isNotEmpty) {
                      Provider.of<DataViewModel>(context, listen: false)
                          .addData(_dataController.text);
                      _dataController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: Provider.of<DataViewModel>(context).dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) return Text('Loading...');

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return ListTile(
                      title: Text(doc['value']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _updateController.text = doc['value'];
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Update Data'),
                                  content: TextField(
                                    controller: _updateController,
                                    decoration:
                                        InputDecoration(labelText: 'New Value'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_updateController.text.isNotEmpty) {
                                          Provider.of<DataViewModel>(context,
                                                  listen: false)
                                              .updateData(doc.id,
                                                  _updateController.text);
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Delete"),
                                    content: Text(
                                        "Are you sure you want to delete this item?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<DataViewModel>(context,
                                                  listen: false)
                                              .deleteData(doc.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
