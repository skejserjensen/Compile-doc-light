# Compile-doc-light 
Compile-doc-light is a very simple Powershell implementation of the compile script bundle with the [compile-doc](https://github.com/dhil/compile-doc) LaTeX structure. The script contains the primary functions from compile-doc.sh and link-doc.sh, which is compilation of LaTeX and BibTex, and automatically linking of documents not excluded with the @ symbol. 

## Installation
1. Configure Powershell to allow unsigned scripts to be run, using the following command.
```
Set-ExecutionPolicy Unrestricted
```

2. Copy the script to the root of your compile-doc installation and set your default document and preferred LaTeX compiler in the top of the script. 

##License
The program is license under version 3 of the GPL, and a copy of the license is bundled with the program.
