# Compile-doc-light 
Compile-doc-light is a very simple Powershell implementation of the compile scripts provided by [compile-doc](https://github.com/dhil/compile-doc), so the folder structure can be used in Windows without suffering the pain of running Bash scripts on Windows.

The script implements the primary functions from compile-doc.sh and link-doc.sh, which is compilation of LaTeX, compilation of BibTex, and automatically linking of documents not excluded by putting a @ symbol as the first character in the name of your files and folders.

## Installation
1. Configure Powershell to allow unsigned scripts to be run, using the following command.  
`Set-ExecutionPolicy Unrestricted`

2. Copy the script to your compile-doc installation and set your default document and preferred LaTeX compilers in the top of the script.

## License
The program is licensed under version 3 of the GPL, and a copy of the license is bundled with the program.
