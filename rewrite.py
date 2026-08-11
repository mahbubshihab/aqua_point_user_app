import os
import re

files_to_process = [
    'features/products/presentation/pages/products_page.dart',
    'features/products/presentation/pages/shop_page.dart',
    'features/products/presentation/widgets/shop_product_card.dart',
    'features/products/presentation/pages/product_detail_page.dart',
    'features/products/presentation/pages/category_shop_page.dart',
    'features/products/presentation/widgets/product_item_card.dart',
    'features/products/presentation/widgets/add_product_modal.dart',
    'features/products/presentation/widgets/cart_bottom_sheet.dart',
    'features/products/presentation/widgets/product_reviews_section.dart',
    'features/products/presentation/cart_manager.dart',
    'features/orders/presentation/pages/cart_page.dart',
    'features/orders/presentation/pages/checkout_page.dart',
    'features/orders/presentation/pages/order_confirmation_page.dart',
]

base_dir = '/Users/mahbubshihab/Development/AQUA_POINT/user_app'

for rel_path in files_to_process:
    backup_path = os.path.join(base_dir, 'lib_backup', rel_path)
    target_path = os.path.join(base_dir, 'lib', rel_path)
    
    with open(backup_path, 'r') as f:
        content = f.read()

    # Colors
    content = content.replace('Color(0xB31E293B)', 'AppColors.surface')
    content = content.replace('Color(0xFF1E293B)', 'AppColors.surface')
    content = content.replace('Color(0xF00D111D)', 'AppColors.surface')
    content = content.replace('Color(0x1F1A2236)', 'AppColors.surface')
    content = content.replace('Color(0x800F172A)', 'AppColors.surface')
    content = content.replace('Color(0xCC0F172A)', 'AppColors.surface')
    content = content.replace('Color(0xFF0F172A)', 'Colors.white')
    content = content.replace('AppColors.cardBackground', 'AppColors.surface')
    content = content.replace('AppColors.inputFill', 'AppColors.background')
    
    # Text colors
    content = content.replace('color: Colors.white,', 'color: AppColors.textPrimary,')
    content = content.replace('color: Colors.white', 'color: AppColors.textPrimary')
    content = content.replace('Colors.white38', 'AppColors.textSecondary')
    content = content.replace('Colors.white60', 'AppColors.textSecondary')
    content = content.replace('Colors.white24', 'AppColors.divider')
    content = content.replace('color: Colors.black', 'color: Colors.white') # on primary buttons
    content = content.replace('color: Colors.black,', 'color: Colors.white,') 
    
    # Backdrop Filter
    content = re.sub(r'BackdropFilter\(\s*filter:\s*ImageFilter\.blur\([^)]+\),\s*child:\s*', '', content)
    # This leaves an extra closing parenthesis for the BackdropFilter which we need to remove carefully.
    # Actually, it's easier to just replace ImageFilter line
    content = content.replace('import \'dart:ui\';\n', '')
    
    # GlassCard
    if 'GlassCard(' in content:
        content = content.replace("import '../../../../core/widgets/glass_card.dart';", "import '../../../../core/widgets/app_card.dart';")
        content = re.sub(r'GlassCard\(', 'AppCard(', content)
        content = re.sub(r'fillColor:\s*[^,]+,', '', content)
        content = re.sub(r'borderWidth:\s*[^,]+,', '', content)
        content = re.sub(r'borderColor:\s*[^,]+,', '', content)
        content = re.sub(r'borderGradient:\s*LinearGradient\([^)]+\),', '', content, flags=re.DOTALL)
        # fix any dangling gradient issues by removing multiline LinearGradient inside GlassCard
        content = re.sub(r'borderGradient:.*?\],.*?\)?,', '', content, flags=re.DOTALL)
    
    # Make sure text styles use the right colors for buttons
    content = content.replace('color: AppColors.primary,', 'color: AppColors.primary,') 
    
    # For AddProductModal, manual fix for BackdropFilter removal
    if 'add_product_modal.dart' in rel_path:
        content = content.replace('BackdropFilter(', 'SizedBox(')
        content = content.replace('filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),', '')

    with open(target_path, 'w') as f:
        f.write(content)
    
    print(f"Processed {rel_path}")

