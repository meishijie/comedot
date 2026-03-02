import sys
import re
import os

def check_tscn_for_inline_comments(file_path):
    if not os.path.exists(file_path):
        print(f"Error: File not found {file_path}")
        sys.exit(1)
        
    inline_comment_pattern = re.compile(r'^[^#\n]+#')
    has_errors = False
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            # If the line has actual code before the #, it's an inline comment
            if inline_comment_pattern.search(line):
                # Ignore string literals that might contain #, simple check:
                if '"' not in line.split('#')[0]:
                    print(f"🛑 [FATAL] Inline comment detected in {file_path} at line {line_num}:")
                    print(f"   > {line}")
                    print(f"   Godot C++ INI parser WILL SILENTLY CRASH HERE and drop all subsequent properties in this Node!")
                    has_errors = True
                    
    if has_errors:
        print("\n❌ tscn_guard validation FAILED. Please remove the inline comments entirely.")
        sys.exit(1)
    else:
        print(f"✅ {file_path} passed tscn_guard validation. No inline comments found.")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 tscn_guard.py <file.tscn>")
        sys.exit(1)
        
    check_tscn_for_inline_comments(sys.argv[1])
