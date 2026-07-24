import os
import re
import shutil

# Map of old file to new file
file_map = {
    'app_color_tokens.dart': 'core/theme/app_color_tokens.dart',
    'app_dimensions.dart': 'core/theme/app_dimensions.dart',
    'app_text_styles.dart': 'core/theme/app_text_styles.dart',
    'status_color_resolver.dart': 'core/theme/status_color_resolver.dart',
    
    'router.dart': 'router/router.dart',
    'app_widget.dart': 'app_widget.dart',
    
    'login_screen.dart': 'features/auth/presentation/screens/login_screen.dart',
    'device_mismatch_screen.dart': 'features/auth/presentation/screens/device_mismatch_screen.dart',
    'hardware_binding_screen.dart': 'features/auth/presentation/screens/hardware_binding_screen.dart',
    
    'siswa_dashboard_screen.dart': 'features/dashboard/presentation/screens/siswa_dashboard_screen.dart',
    'guru_dashboard_screen.dart': 'features/dashboard/presentation/screens/guru_dashboard_screen.dart',
    'admin_dashboard_screen.dart': 'features/dashboard/presentation/screens/admin_dashboard_screen.dart',
    
    'barcode_display_screen.dart': 'features/attendance/presentation/screens/barcode_display_screen.dart',
    'biometric_verify_screen.dart': 'features/attendance/presentation/screens/biometric_verify_screen.dart',
    'scanner_screen.dart': 'features/attendance/presentation/screens/scanner_screen.dart',
    'attendance_list_screen.dart': 'features/attendance/presentation/screens/attendance_list_screen.dart',
    'approval_card_screen.dart': 'features/attendance/presentation/screens/approval_card_screen.dart',
    'manual_override_screen.dart': 'features/attendance/presentation/screens/manual_override_screen.dart',
    
    'freeze_management_screen.dart': 'features/management/presentation/screens/freeze_management_screen.dart',
    'kurikulum_screen.dart': 'features/management/presentation/screens/kurikulum_screen.dart',

    'admin_repository.dart': 'features/management/data/repositories/admin_repository.dart',
    'admin_providers.dart': 'features/management/presentation/providers/admin_providers.dart',

    'siswa_repository.dart': 'features/attendance/data/repositories/siswa_repository.dart',
    'student_attendance.dart': 'features/attendance/domain/entities/student_attendance.dart',
    'siswa_providers.dart': 'features/attendance/presentation/providers/siswa_providers.dart',

    'guru_repository.dart': 'features/attendance/data/repositories/guru_repository.dart',
    'guru_providers.dart': 'features/attendance/presentation/providers/guru_providers.dart',
}

def move_files():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file in file_map:
                old_path = os.path.join(root, file)
                new_path = os.path.join('lib', os.path.normpath(file_map[file]))
                
                # if already in new place, skip
                if os.path.abspath(old_path) == os.path.abspath(new_path):
                    continue
                    
                os.makedirs(os.path.dirname(new_path), exist_ok=True)
                shutil.move(old_path, new_path)
                print(f"Moved {old_path} -> {new_path}")

def fix_imports():
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.dart') and '.dart_tool' not in root and '.pub-cache' not in root and 'build' not in root:
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                modified = False
                # replace imports
                for filename, new_rel_path in file_map.items():
                    # Regex to match: import '.../filename';
                    # We will replace it with import 'package:attendance_app/new_rel_path';
                    pattern = r"import\s+['\"](?:[^'\"]*/)?" + re.escape(filename) + r"['\"];"
                    replacement = f"import 'package:attendance_app/{new_rel_path.replace(chr(92), '/')}';"
                    
                    new_content = re.sub(pattern, replacement, content)
                    if new_content != content:
                        content = new_content
                        modified = True
                        
                if modified:
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(content)

move_files()
fix_imports()

print("Done")
