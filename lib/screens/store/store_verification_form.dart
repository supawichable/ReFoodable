import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';

enum FormField { phone, verificationMode }

extension
    on Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>> {
  String? get phone => this[FormField.phone.name]?.value;
  String? get verificationMode => this[FormField.verificationMode.name]?.value;
}

class StoreVerificationFormPage extends StatefulWidget {
  final String? storeId;
  const StoreVerificationFormPage(
      {super.key, @PathParam('storeId') this.storeId});

  @override
  State<StoreVerificationFormPage> createState() =>
      _StoreVerificationFormPageState();
}

class _StoreVerificationFormPageState extends State<StoreVerificationFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  DocumentSnapshot<Store>? _storeSnapshot;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final storeId = widget.storeId;
    FirebaseFirestore.instance.stores.doc(storeId).get().then((snapshot) {
      _storeSnapshot = snapshot;
      _formKey.currentState!.patchValue({
        FormField.phone.name: snapshot.data()?.phone,
      });
      final store = snapshot.data();
      if (store != null) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((e) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Verify Store')),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: FormBuilder(
              key: _formKey,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          name: FormField.phone.name,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _storeSnapshot?.data()?.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.match(r'^\+?[0-9]+$',
                                errorText: 'Invalid Phone Number.'),
                            FormBuilderValidators.required()
                          ]),
                        ),
                        const SizedBox(height: 12),
                        FormBuilderRadioGroup(
                          name: FormField.verificationMode.name,
                          decoration: const InputDecoration(
                              labelText: 'Verfication Method'),
                          options: ['SMS', 'Call']
                              .map(
                                  (mode) => FormBuilderFieldOption(value: mode))
                              .toList(growable: false),
                        ),
                        const SizedBox(height: 12),
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          Center(
                              child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              _submit();
                            },
                          ))
                      ],
                    ))
              ]),
            )));
  }

  Future<void> _submit() async {
    String? _message;
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final collection =
            FirebaseFirestore.instance.collection('store_verification');
        final fields = _formKey.currentState!.fields;
        await collection.doc().set({
          'timestamp': FieldValue.serverTimestamp(),
          'storeId': widget.storeId,
          'phone': fields.phone,
          'mode': fields.verificationMode
        });
        _message = 'Submitted successfully';
      } catch (e) {
        _message = 'Error submitting';
        setState(() {
          _isLoading = false;
        });
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_message)));
      if (mounted) {
        context.router.pop();
      }
    }
  }
}
