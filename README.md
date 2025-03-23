# FolderShadow (Doesnt Work)

**Preserve full folder paths when copying files or folders — directly from the right-click context menu.**  
A Windows batch script that lets you replicate entire directory structures of selected items and back them up with one click.

---

## 🧠 Features

- 🗂️ Copy files or folders with **full directory structure** intact  
- 💾 Saves everything into a structured backup folder on your Desktop  
- 📁 Reconstructs original paths for easy restoration  
- ⚡ Uses `robocopy` with multithreading for performance  
- 🔐 Runs with elevation for access to protected directories  
- 📜 Minimal footprint: one standalone `.bat` file

---

## 🛠 Setup

1. 📄 Place the `CopyWithStructure.bat` script in a permanent location (e.g. `C:\Scripts\CopyWithStructure.bat`)
2. 🧾 Add it to the Windows context menu:

### Context Menu:
Use the provided `.reg` files to have the option show up in your context menu.
* `For Files.reg`: Show context menu when you select files.
* `For Folders.reg`: Show context menu when you select folders.
* `For Both.reg`: Show context menu when you select either.
