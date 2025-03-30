import 'package:cybersafe_pro/components/bottom_sheets/create_category_bottom_sheet.dart';
import 'package:cybersafe_pro/database/models/category_ojb_model.dart';
import 'package:cybersafe_pro/providers/category_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/card/card_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryManagerTabletLayout extends StatefulWidget {
  const CategoryManagerTabletLayout({super.key});

  @override
  State<CategoryManagerTabletLayout> createState() => _CategoryManagerTabletLayoutState();
}

class _CategoryManagerTabletLayoutState extends State<CategoryManagerTabletLayout> {
  final TextEditingController _categoryNameController = TextEditingController();
  CategoryOjbModel? _editingCategory;
  
  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý danh mục'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Form thêm/sửa danh mục
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _categoryNameController,
                          decoration: InputDecoration(
                            labelText: _editingCategory == null ? 'Thêm danh mục mới' : 'Sửa danh mục',
                            hintText: 'Nhập tên danh mục',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.folder),
                            suffixIcon: _categoryNameController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _categoryNameController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _categoryNameController.text.isEmpty
                          ? null
                          : () => _addOrUpdateCategory(),
                        icon: Icon(
                          _editingCategory == null ? Icons.add : Icons.check,
                        ),
                        label: Text(
                          _editingCategory == null ? 'Thêm' : 'Cập nhật',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                        ),
                      ),
                      if (_editingCategory != null) ...[
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: _cancelEdit,
                          icon: const Icon(Icons.cancel),
                          label: const Text('Hủy'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Danh sách các danh mục
              Expanded(
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    final categories = categoryProvider.categoryList;
                    
                    if (categories.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_off,
                              size: 64.sp,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Không có danh mục nào',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                _categoryNameController.text = '';
                                _editingCategory = null;
                                setState(() {});
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Thêm danh mục đầu tiên'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: categories.length,
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = categories[oldIndex];
                          categoryProvider.reorderCategory(oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final accountCount = category.accounts.length;
                          
                          return Card(
                            key: ValueKey(category.id),
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 2,
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.folder,
                                color: Theme.of(context).colorScheme.primary,
                                size: 32.sp,
                              ),
                              title: Text(
                                category.categoryName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '$accountCount tài khoản',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Chỉnh sửa',
                                    onPressed: () => _editCategory(category),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Xóa',
                                    onPressed: accountCount > 0
                                      ? null
                                      : () => _showDeleteConfirmationDialog(category),
                                  ),
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: const Icon(Icons.drag_handle),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addOrUpdateCategory() {
    final categoryProvider = context.read<CategoryProvider>();
    
    if (_editingCategory == null) {
      // Thêm danh mục mới
      final newCategory = CategoryOjbModel(categoryName: _categoryNameController.text.trim());
      categoryProvider.createCategory(newCategory);
    } else {
      // Cập nhật danh mục đã có
      _editingCategory!.categoryName = _categoryNameController.text.trim();
      categoryProvider.updateCategory(_editingCategory!);
    }
    
    // Đặt lại trạng thái
    _categoryNameController.clear();
    _editingCategory = null;
    setState(() {});
    
    // Ẩn bàn phím
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _editCategory(CategoryOjbModel category) {
    _editingCategory = category;
    _categoryNameController.text = category.categoryName;
    setState(() {});
    
    // Focus vào input
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _cancelEdit() {
    _editingCategory = null;
    _categoryNameController.clear();
    setState(() {});
    
    // Ẩn bàn phím
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _showDeleteConfirmationDialog(CategoryOjbModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa danh mục'),
        content: Text(
          'Bạn có chắc chắn muốn xóa danh mục "${category.categoryName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              context.read<CategoryProvider>().deleteCategory(category);
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}