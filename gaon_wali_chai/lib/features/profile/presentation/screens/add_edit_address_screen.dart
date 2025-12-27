import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/models/address_model.dart';
import '../../data/repositories/address_repository.dart';

/// Add/Edit Address Screen
class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final AddressRepository _addressRepository = AddressRepository();

  final _labelController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  String _selectedLabel = 'Home';
  bool _isDefault = false;
  bool _isLoading = false;

  final List<String> _labelOptions = ['Home', 'Work', 'Other'];
  final List<String> _indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _initializeWithAddress(widget.address!);
    }
  }

  void _initializeWithAddress(AddressModel address) {
    _selectedLabel = address.label;
    _addressLine1Controller.text = address.addressLine1;
    _addressLine2Controller.text = address.addressLine2 ?? '';
    _cityController.text = address.city;
    _stateController.text = address.state;
    _pincodeController.text = address.pincode;
    _isDefault = address.isDefault;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = widget.address == null
          ? await _addressRepository.createAddress(
              label: _selectedLabel,
              addressLine1: _addressLine1Controller.text.trim(),
              addressLine2: _addressLine2Controller.text.trim().isEmpty
                  ? null
                  : _addressLine2Controller.text.trim(),
              city: _cityController.text.trim(),
              state: _stateController.text.trim(),
              pincode: _pincodeController.text.trim(),
              isDefault: _isDefault,
            )
          : await _addressRepository.updateAddress(
              widget.address!.id,
              label: _selectedLabel,
              addressLine1: _addressLine1Controller.text.trim(),
              addressLine2: _addressLine2Controller.text.trim().isEmpty
                  ? null
                  : _addressLine2Controller.text.trim(),
              city: _cityController.text.trim(),
              state: _stateController.text.trim(),
              pincode: _pincodeController.text.trim(),
              isDefault: _isDefault,
            );

      if (mounted) {
        setState(() => _isLoading = false);

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.address == null
                    ? 'Address added successfully'
                    : 'Address updated successfully',
              ),
              backgroundColor: AppColors.matchaGreen,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Failed to save address'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: isEdit ? 'Edit Address' : 'Add Address',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLabelSection(),
            const SizedBox(height: 24),
            _buildAddressFields(),
            const SizedBox(height: 24),
            _buildDefaultCheckbox(),
            const SizedBox(height: 32),
            CustomButton(
              text: isEdit ? 'Update Address' : 'Save Address',
              onPressed: () {
                _saveAddress();
              },
              isLoading: _isLoading,
              width: double.infinity,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Label *',
          style: AppTypography.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _labelOptions.map((label) {
            final isSelected = _selectedLabel == label;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedLabel = label),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          label == 'Home'
                              ? Icons.home
                              : label == 'Work'
                              ? Icons.work
                              : Icons.location_on,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: AppTypography.body2.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _addressLine1Controller,
          labelText: 'Address Line 1 *',
          hintText: 'House no., Building name',
          prefixIcon: Icons.location_on_outlined,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Address is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _addressLine2Controller,
          labelText: 'Address Line 2 (Optional)',
          hintText: 'Street name, Area',
          prefixIcon: Icons.signpost_outlined,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _cityController,
                labelText: 'City *',
                hintText: 'Enter city',
                prefixIcon: Icons.location_city,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _pincodeController,
                labelText: 'Pincode *',
                hintText: '400001',
                prefixIcon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pincode is required';
                  }
                  if (value.length != 6) {
                    return 'Invalid pincode';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _stateController.text.isEmpty ? null : _stateController.text,
          decoration: InputDecoration(
            labelText: 'State *',
            labelStyle: AppTypography.body2.copyWith(
              color: AppColors.textSecondary,
            ),
            prefixIcon: Icon(Icons.map_outlined, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
          hint: const Text('Select state'),
          items: _indianStates.map((state) {
            return DropdownMenuItem(value: state, child: Text(state));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _stateController.text = value;
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'State is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDefaultCheckbox() {
    return InkWell(
      onTap: () => setState(() => _isDefault = !_isDefault),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _isDefault ? AppColors.primary : AppColors.surface,
                border: Border.all(
                  color: _isDefault ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _isDefault
                  ? const Icon(Icons.check, size: 16, color: AppColors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set as default address',
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This will be your default delivery address',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
