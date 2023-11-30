import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  //Fungsi
  Future<void> getContacts() async {
    List<Contact> contacts = await ContactsService.getContacts();
    print(contacts);
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  var _contacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Contact")),
        body: _contacts != null && _contacts.length != 0
            ? ListView.builder(
                itemCount: _contacts?.lenghth ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact? contact = _contacts?.elemenAt(index);
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                    leading:
                        (contact?.avatar != null && contact!.avatar!.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar!),
                              )
                            : CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(contact!.initials()),
                              ),
                    title: Text(contact.displayName ?? ''),
                  );
                })
            : Center(child: Text('Kontak Kosong')));
  }
}
