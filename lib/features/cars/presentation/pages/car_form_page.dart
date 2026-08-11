import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/car.dart';
import '../../di/cars_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../car_failure_messages.dart';
import '../controllers/car_form_notifier.dart';
import '../widgets/brand_autocomplete_field.dart';
import '../widgets/car_color_picker.dart';
import '../../../../shared/presentation/delete_confirm_dialog.dart';
import '../../../../shared/presentation/destructive_outlined_icon_button.dart';
import '../../../../shared/presentation/form_actions_bar.dart';

class CarFormPage extends ConsumerStatefulWidget {
  const CarFormPage({this.existing, super.key});

  final CarListItem? existing;

  @override
  ConsumerState<CarFormPage> createState() => _CarFormPageState();
}

class _CarFormPageState extends ConsumerState<CarFormPage> {
  static const _sectionGap = 24.0;

  late final CarFormNotifier _form;
  final _brandController = TextEditingController();
  final _brandFocus = FocusNode();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  bool _brandPrefillDone = false;

  @override
  void initState() {
    super.initState();
    _form = CarFormNotifier(existing: widget.existing);
    final existing = widget.existing;
    if (existing != null) {
      _modelController.text = existing.model ?? '';
      _yearController.text = existing.year?.toString() ?? '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_brandPrefillDone || widget.existing == null) return;
    _brandPrefillDone = true;
    _brandController.text = widget.existing!.brandName;
  }

  @override
  void dispose() {
    _form.dispose();
    _brandController.dispose();
    _brandFocus.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final l10n = AppLocalizations.of(context);
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      final outcome = _form.applyPickedPhoto(bytes);
      if (outcome is CarPhotoPickTooLarge) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.photoTooLarge)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.carPhotoPickError)),
      );
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final outcome = await _form.save(
      brandName: _brandController.text,
      modelText: _modelController.text,
      yearText: _yearController.text,
      saveCar: ref.read(saveCarUseCaseProvider),
    );
    if (!mounted) return;
    switch (outcome) {
      case CarFormSubmitSuccess():
        Navigator.of(context).pop(true);
      case CarFormSubmitSnack(:final snack):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(carFormSnackMessage(l10n, snack))),
        );
      case CarFormSubmitFieldError():
      case CarFormSubmitBusy():
      case CarFormSubmitDeleted():
        break;
    }
  }

  Future<void> _delete() async {
    if (widget.existing == null || _form.saving) return;

    final l10n = AppLocalizations.of(context);
    final confirmed = await showDeleteConfirmDialog(
      context,
      message: l10n.carDeleteConfirm,
    );
    if (confirmed != true || !mounted) return;

    final outcome = await _form.delete(
      deleteCar: ref.read(deleteCarUseCaseProvider),
    );
    if (!mounted) return;
    switch (outcome) {
      case CarFormSubmitDeleted():
        Navigator.of(context).pop(true);
      case CarFormSubmitSnack(:final snack):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(carFormSnackMessage(l10n, snack))),
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final brandRepo = ref.watch(carBrandRepositoryProvider);
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.carEditTitle : l10n.carAddTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: _form,
          builder: (context, _) {
            final photoBytes = _form.photoBytes;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.carPhotoLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: photoBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.memory(
                                photoBytes,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.directions_car_outlined,
                                  size: 48,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: _pickPhoto,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: Text(l10n.carPhotoPick),
                            ),
                          ),
                          if (photoBytes != null) ...[
                            const SizedBox(width: 4),
                            DestructiveOutlinedIconButton(
                              onPressed: _form.clearPhoto,
                              tooltip: l10n.carPhotoRemove,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _sectionGap),
                BrandAutocompleteField(
                  repository: brandRepo,
                  controller: _brandController,
                  focusNode: _brandFocus,
                  errorText: _form.brandError ? l10n.carBrandRequired : null,
                ),
                const SizedBox(height: _sectionGap),
                TextField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    labelText: l10n.carModelLabel,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: _sectionGap),
                TextField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: l10n.carYearLabel,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: _sectionGap),
                CarColorPicker(
                  selectedArgb: _form.colorArgb,
                  onChanged: _form.setColorArgb,
                ),
                const SizedBox(height: _sectionGap),
                FormActionsBar(
                  isSaving: _form.saving,
                  onSave: _save,
                  onDelete: widget.existing != null ? _delete : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
