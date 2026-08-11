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
    target_path = os.path.join(base_dir, 'lib', rel_path)
    if not os.path.exists(target_path): continue
    
    with open(target_path, 'r') as f:
        content = f.read()

    # Add import if missing
    if 'package:google_fonts/google_fonts.dart' not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:google_fonts/google_fonts.dart';")

    # Replace all TextStyle with GoogleFonts.inter
    content = content.replace('TextStyle(', 'GoogleFonts.inter(')

    # Use GoogleFonts.outfit for fontSize >= 16 or bold titles.
    # We will use regex to find GoogleFonts.inter(...) and check if fontSize is >= 16.
    def replace_heading(match):
        text = match.group(0)
        # Look for fontSize: XX
        fs_match = re.search(r'fontSize:\s*([\d.]+)', text)
        if fs_match:
            size = float(fs_match.group(1))
            if size >= 16:
                return text.replace('GoogleFonts.inter', 'GoogleFonts.outfit')
        return text

    # It's hard to match nested parentheses, so let's just do a rough replace on common patterns
    # A simple regex for the start of the style until fontSize
    # Or just replace manually where fontSize >= 16.
    lines = content.split('\n')
    for i in range(len(lines)):
        if 'GoogleFonts.inter' in lines[i]:
            # scan next 5 lines for fontSize
            for j in range(i, min(i+5, len(lines))):
                fs_match = re.search(r'fontSize:\s*([\d.]+)', lines[j])
                if fs_match:
                    size = float(fs_match.group(1))
                    if size >= 16:
                        lines[i] = lines[i].replace('GoogleFonts.inter', 'GoogleFonts.outfit')
                    break
                
    content = '\n'.join(lines)
    
    with open(target_path, 'w') as f:
        f.write(content)
    
    print(f"Processed fonts in {rel_path}")

