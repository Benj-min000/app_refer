import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class FirestoreDumpTool {
  static const List<String> knownCollections = [
    'users', 'restaurants', 'orders', 'addresses', 'carts', 'notifications', 'menus', 'items', 'favorites'
  ];

  static Future<void> startExport() async {
    Map<String, dynamic> fullBackup = {};
    try {
      for (String root in ['users', 'restaurants', 'orders']) {
        debugPrint('Exporting root: $root...');
        fullBackup[root] = await _fetchCollectionRecursive(
          FirebaseFirestore.instance.collection(root),
          knownCollections,
        );
      }

      String jsonOutput = const JsonEncoder.withIndent('  ').convert(fullBackup);
      debugPrint('--- START OF DUMP ---');
      _printLongString(jsonOutput);
      debugPrint('--- END OF DUMP ---');
    } catch (e) {
      debugPrint('Deep Export Error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> _fetchCollectionRecursive(
      Query query, List<String> knownCollections) async {
    final snapshot = await query.get();
    List<Map<String, dynamic>> docsList = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> docData = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      Map<String, dynamic> subCollectionsFound = {};

      for (String subName in knownCollections) {
        final subRef = doc.reference.collection(subName);
        final subSnapshot = await subRef.limit(1).get();

        if (subSnapshot.docs.isNotEmpty) {
          subCollectionsFound[subName] = await _fetchCollectionRecursive(subRef, knownCollections);
        }
      }

      if (subCollectionsFound.isNotEmpty) {
        docData['_nested'] = subCollectionsFound;
      }

      docsList.add(_sanitizeData(docData));
    }
    return docsList;
  }

  static Future<void> startImport() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.json');

      // The code uses the emulator folders to access it and upload the new data. 
      // You need to go to Android studio emulator Device File Explorer and upload the .json file in the path below
      if (!await file.exists()) {
        final altFile = File('/data/data/com.megaapp.user_app/app_flutter/data.json');
        if (await altFile.exists()) {
          await _executeImport(altFile);
          return;
        }
        debugPrint("Error: File not found at ${file.path}");
        return;
      }

      await _executeImport(file);
    } catch (e) {
      debugPrint("Import Error: $e");
    }
  }

  static Future<void> _executeImport(File file) async {
    String jsonContent = await file.readAsString();
    int startIndex = jsonContent.indexOf('{');
    if (startIndex == -1) throw "Invalid JSON";
    Map<String, dynamic> decodedData = jsonDecode(jsonContent.substring(startIndex));
    await _processImport(decodedData);
    debugPrint("Import successful");
  }

  static Future<void> _processImport(Map<String, dynamic> data) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    int count = 0;

    for (String rootName in data.keys) {
      List docs = data[rootName];
      for (var docData in docs) {
        count = await _recursiveBatchWrite(
          FirebaseFirestore.instance.collection(rootName),
          Map<String, dynamic>.from(docData),
          batch,
          count,
        );
      }
    }
    await batch.commit();
  }

  static Future<int> _recursiveBatchWrite(
      CollectionReference colRef, Map<String, dynamic> data, WriteBatch batch, int count) async {
    int currentCount = count;
    String? id = data['id'];
    Map<String, dynamic>? nested = data['_nested'];

    Map<String, dynamic> cleanData = _deSanitizeData(data)
      ..remove('id')
      ..remove('_nested');

    DocumentReference docRef = id != null ? colRef.doc(id) : colRef.doc();
    batch.set(docRef, cleanData);
    currentCount++;

    if (currentCount >= 500) {
      await batch.commit();
      batch = FirebaseFirestore.instance.batch();
      currentCount = 0;
    }

    if (nested != null) {
      for (String subName in nested.keys) {
        for (var subDoc in nested[subName]) {
          currentCount = await _recursiveBatchWrite(
            docRef.collection(subName),
            Map<String, dynamic>.from(subDoc),
            batch,
            currentCount,
          );
        }
      }
    }
    return currentCount;
  }

  static Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      } else if (value is DocumentReference) {
        return MapEntry(key, value.path);
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _sanitizeData(value));
      } else if (value is List) {
        return MapEntry(key, value.map((item) {
          if (item is Map<String, dynamic>) return _sanitizeData(item);
          if (item is Timestamp) return item.toDate().toIso8601String();
          return item;
        }).toList());
      }
      return MapEntry(key, value);
    });
  }

  static Map<String, dynamic> _deSanitizeData(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is String && RegExp(r'^\d{4}-\d{2}-\d{2}T').hasMatch(value)) {
        try {
          return MapEntry(key, Timestamp.fromDate(DateTime.parse(value)));
        } catch (_) {
          return MapEntry(key, value);
        }
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _deSanitizeData(value));
      } else if (value is List) {
        return MapEntry(key, value.map((item) {
          if (item is Map<String, dynamic>) return _deSanitizeData(item);
          if (item is String && RegExp(r'^\d{4}-\d{2}-\d{2}T').hasMatch(item)) {
            return Timestamp.fromDate(DateTime.parse(item));
          }
          return item;
        }).toList());
      }
      return MapEntry(key, value);
    });
  }

  static void _printLongString(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }
}