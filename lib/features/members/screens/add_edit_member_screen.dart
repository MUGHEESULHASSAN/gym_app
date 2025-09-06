
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/members_provider.dart';
import '../../../core/widgets/custom_text_form_field.dart';

import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/date_utils.dart';
import '../models/member.dart';

class AddEditMemberScreen extends StatefulWidget {
  final Member? editMember;
  const AddEditMemberScreen({super.key, this.editMember});

  @override
  State<AddEditMemberScreen> createState() => _AddEditMemberScreenState();
}

class _AddEditMemberScreenState extends State<AddEditMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  String _plan = '1 Month';
  DateTime? _startDate;
  File? _pickedImage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editMember != null) {
      final m = widget.editMember!;
      _name.text = m.fullName;
      _phone.text = m.phone;
      _email.text = m.email;
      _plan = m.plan;
      _startDate = m.startDate;
    }
  }

  Future<void> _pickImage() async {
    final p = ImagePicker();
    final res = await p.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (res != null) setState(() => _pickedImage = File(res.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final provider = context.read<MembersProvider>();
    final start = _startDate ?? DateTime.now();
    try {
      if (widget.editMember == null) {
        await provider.addMember(fullName: _name.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(), plan: _plan, startDate: start, profile: _pickedImage);
      } else {
        final m = widget.editMember!;
        final updated = m.copyWith(
          fullName: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          plan: _plan,
          startDate: start,
          expiryDate: addPlanToStartDate(start, _plan),
        );
        await provider.updateMember(updated, profile: _pickedImage);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editMember != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Member' : 'Add Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(radius:48, backgroundImage: _pickedImage!=null ? FileImage(_pickedImage!) : (widget.editMember?.profileImageUrl!=null ? NetworkImage(widget.editMember!.profileImageUrl!) as ImageProvider : null), child: _pickedImage==null && widget.editMember?.profileImageUrl==null ? const Icon(Icons.camera_alt) : null),
              ),
              const SizedBox(height:12),
              CustomTextFormField(label: 'Full Name', controller: _name, validator: (v) => v==null||v.isEmpty ? 'Required' : null),
              const SizedBox(height:12),
              CustomTextFormField(label: 'Phone', controller: _phone, keyboardType: TextInputType.phone, validator: (v) => v==null||v.isEmpty ? 'Required' : null),
              const SizedBox(height:12),
              CustomTextFormField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress, validator: (v) => v==null||v.isEmpty ? 'Required' : null),
              const SizedBox(height:12),
              DropdownButtonFormField<String>(
                initialValue: _plan,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Membership Plan'),
                items: ['1 Month','3 Months','1 Year'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _plan = v ?? '1 Month'),
              ),
              const SizedBox(height:12),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(border: const OutlineInputBorder(), labelText: _startDate==null? 'Start Date' : 'Start: ${_startDate!.toLocal().toIso8601String().split('T').first}'),
                onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (picked!=null) setState(() => _startDate = picked);
                },
              ),
              const SizedBox(height:20),
              PrimaryButton(label: isEdit ? 'Save Changes' : 'Add Member', onPressed: _save, loading: _loading),
              if (isEdit) TextButton(onPressed: () async {
                final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Confirm Delete'), content: const Text('Delete this member?'), actions: [TextButton(onPressed: () => Navigator.pop(context,false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(context,true), child: const Text('Delete'))]));
                if (ok==true) {
                  await context.read<MembersProvider>().deleteMember(widget.editMember!.id);
                  if (mounted) Navigator.pop(context);
                }
              }, child: const Text('Delete', style: TextStyle(color:Colors.red))) 
            ],
          ),
        ),
      ),
    );
  }
}
