import 'package:contact_app/local_db/contact_db.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];

  List<Contact> get contacts =>
      _filteredContacts.isEmpty ? _contacts : _filteredContacts;

  Future<void> fetchContacts() async {
    final dataList = await DBHelper().queryAllContacts();
    _contacts = dataList.map((item) => Contact.fromMap(item)).toList();
    _filteredContacts = [];
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await DBHelper().insertContact(contact.toMap());
    fetchContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await DBHelper().updateContact(contact.toMap());
    fetchContacts();
  }

  Future<void> deleteContact(int id) async {
    await DBHelper().deleteContact(id);
    fetchContacts();
  }

  void searchContacts(String query) {
    if (query.isEmpty) {
      _filteredContacts = [];
    } else {
      _filteredContacts = _contacts.where((contact) {
        final nameLower = contact.name.toLowerCase();
        final phoneLower = contact.phone.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            phoneLower.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }
}
