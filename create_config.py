import os
import sys

# Create the config directory
config_dir = r'c:\Users\Korisnik\Desktop\pravna\pravna-team7\src\config'
os.makedirs(config_dir, exist_ok=True)

# Create the __init__.py file
init_file = os.path.join(config_dir, '__init__.py')
with open(init_file, 'w') as f:
    pass

print(f"Successfully created directory: {config_dir}")
print(f"Successfully created file: {init_file}")
