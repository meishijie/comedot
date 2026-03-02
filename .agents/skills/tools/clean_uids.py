import sys
import re
import os

def clean_uids_from_tscn(file_path):
    if not os.path.exists(file_path):
        print(f"Error: File not found {file_path}")
        sys.exit(1)
        
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Match uid="uid://..." and remove it completely from the tag
    # Example: [ext_resource type="Script" uid="uid://cx4x" path="..."] -> [ext_resource type="Script" path="..."]
    cleaned_content = re.sub(r'\s*uid="uid://[^"]+"\s*', ' ', content)
    
    if content != cleaned_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(cleaned_content)
        print(f"✅ Stripped invalid/cached UIDs out of {file_path}. Handing off to Godot text-path resolution fallback.")
    else:
        print(f"ℹ️ No UIDs modified in {file_path}.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 clean_uids.py <file.tscn>")
        sys.exit(1)
        
    clean_uids_from_tscn(sys.argv[1])
