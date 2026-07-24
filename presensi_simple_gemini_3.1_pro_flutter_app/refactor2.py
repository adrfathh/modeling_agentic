import os
import re
import shutil

# Map of old file to new file
file_map = {
    'guru_attendance.dart': 'features/attendance/domain/entities/guru_attendance.dart',
    'attendance_timeline_entry.dart': 'features/attendance/domain/entities/attendance_timeline_entry.dart',
    
    'attendance_summary_counter.dart': 'core/widgets/attendance_summary_counter.dart',
    'date_range_navigator.dart': 'core/widgets/date_range_navigator.dart',
    'donut_chart_widget.dart': 'core/widgets/donut_chart_widget.dart',
    'offline_banner.dart': 'core/widgets/offline_banner.dart',
    'segmented_tab_bar.dart': 'core/widgets/segmented_tab_bar.dart',
    'status_chip.dart': 'core/widgets/status_chip.dart',
    'status_dot.dart': 'core/widgets/status_dot.dart',
    'vertical_attendance_timeline.dart': 'core/widgets/vertical_attendance_timeline.dart',
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
