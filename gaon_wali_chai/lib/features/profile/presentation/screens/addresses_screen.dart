import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/address_card.dart';
import '../../../../shared/widgets/error_widget.dart' as custom_error;
import '../../../../shared/widgets/confirmation_bottom_sheet.dart';
import '../../data/models/address_model.dart';
import '../../data/repositories/address_repository.dart';

/// Addresses Screen - Manage delivery addresses
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final AddressRepository _addressRepository = AddressRepository();
  List<AddressModel> _addresses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _addressRepository.getAddresses();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (response.success && response.data != null) {
          _addresses = response.data!;
        } else {
          _errorMessage = response.message ?? 'Failed to load addresses';
        }
      });
    }
  }

  Future<void> _deleteAddress(AddressModel address) async {
    final response = await _addressRepository.deleteAddress(address.id);

    if (mounted) {
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${address.label} address deleted'),
            backgroundColor: AppColors.matchaGreen,
          ),
        );
        _loadAddresses();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to delete address'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _navigateToAddEdit({AddressModel? address}) async {
    final result = await Navigator.pushNamed(
      context,
      '/add-edit-address',
      arguments: address,
    );

    if (result == true) {
      _loadAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'My Addresses', showBackButton: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? custom_error.EmptyStateWidget(
              message: _errorMessage!,
              icon: Icons.error_outline,
              actionText: 'Retry',
              onAction: _loadAddresses,
            )
          : _addresses.isEmpty
          ? custom_error.EmptyStateWidget(
              message:
                  'No addresses saved\nAdd your delivery address to continue',
              icon: Icons.location_on_outlined,
              actionText: 'Add Address',
              onAction: () => _navigateToAddEdit(),
            )
          : RefreshIndicator(
              onRefresh: _loadAddresses,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AddressCard(
                      address: address,
                      onEdit: () => _navigateToAddEdit(address: address),
                      onDelete: () => _showDeleteConfirmation(address),
                      showActions: true,
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEdit(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          'Add Address',
          style: AppTypography.button.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(AddressModel address) {
    ConfirmationBottomSheet.show(
      context: context,
      title: 'Delete Address',
      message:
          'Are you sure you want to delete "${address.label}" address?\n\n${address.shortAddress}',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDangerous: true,
      onConfirm: () => _deleteAddress(address),
    );
  }
}
