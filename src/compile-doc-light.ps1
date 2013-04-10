#Compile-doc-light is a small Powershell script that can be used together with compile-doc structure developed by Daniel Hillerstrom
# 
#The main purpose of the script is to provide Windows users with the ability to compile LaTeX files using compile-doc as it only supports
#Unix based systems, as its scripts are written in bash. This script does not intended to provide all the features of compile-doc just the
#creation of index.tex and compilation on Windows platforms with powershell.
#
# NOTE: "Set-ExecutionPolicy Unrestricted" must be set as this script is not signed in any way, so it can only run in unrestricted mode
#

###########################
# Configuration variables #
###########################
$DEFAULTDOC=""
$LATEX=""
$BIBTEX=""

##########################
#   Internal variables   #
##########################
$global:docName=$DEFAULTDOC
$global:documentRootPath=
$global:indexFilePath=

##########################
#       Procedures       #
##########################
function SetInternalVariables ([string]$cliInput) {
    #If the user passed something on the command line, then they properly want to compile that instead 
    if($cliInput) {
        $docName=$cliInput
    }

    #Some parts of LaTeX appends ending them self, so we need only the name of file without type suffix
    $docName=$docName.TrimStart(".\")
    $docName=$docName.TrimEnd(".tex")
    $global:docName=$docName

    #compile-doc is structured with a document specific folder in Documents per document in root
    $global:documentRootPath="Documents/$docName"
    $global:indexFilePath="$documentRootPath/index.tex"
}

function CheckUserConfiguration () {
    #Checks if the user have installed the compilers set in the Configuration
    if (!(Get-Command $LATEX -errorAction SilentlyContinue)) {
        echo "ERROR: the command `"$LATEX`" was not found in path, please check the configuration variables and your path." 
        exit
    }

    if (!(Get-Command $BIBTEX -errorAction SilentlyContinue)) {
        echo "ERROR: the command `"$BIBTEX`" was not found in path, please check the configuration variables and your path." 
        exit
    }

    #Checks that all the compile-doc files we need for compilation exists
    if (!(Test-path ($docName+".tex"))) {
        echo "ERROR: the document `"$docName`" was not found, please set defaultdoc correctly or pass a document as argument."
        exit    
    }

    if (Test-Path $documentRootPath) {
        #Just ensuring that we do not have index.tex file half filled with old values, easier then refitting the content
        if (Test-Path $indexFilePath) {
            rm $indexFilePath
        }
    }
    else {
        echo "ERROR: no documents folder found for the document `"$docName`", compilation cannot continue." 
        echo $documentRootPath
        exit
    }
}

function ExtractBibTexFileName () {
    return "\bibliography{$documentRootPath/01-Bibliography/references}"
}

function WriteIndexFile ([string]$textToWrite) {
    echo $textToWrite | Out-File $indexFilePath -Append -Encoding OEM
}

function ComposeIndexFile () {
    #Writes the header of the index.tex file
    WriteIndexFile "%WARNING: this script is automatically generated, all edits will be discarded each time the document is compiled by compile-doc-light" 
    WriteIndexFile "\begin{document}" 

    #Writes the input lines of the index.tex file
    $texFiles=Get-ChildItem $documentRootPath *.tex -recurse -name -exclude index.tex

    foreach ($texFile in $texFiles) {
        #The linker of compile-doc.sh called link-doc.sh uses @ as a prefix for files or folder to excluded from index.tex
        if ($texFile.contains("@")) {
            continue 
        }

        $texFile=$texFile -replace "\\","/"
            $texFile="\input{Documents/$docName/" + $texFile + "}" 
            WriteIndexFile $texFile
    }

    #Writes the footer of the index.tex file, bibtex is allways is included as it fails silently if the file was not found
    WriteIndexFile $(ExtractBibTexFileName)
    WriteIndexFile "\end{document}"
}

function CompileDocument () {
    &$LATEX $docName
    &$BIBTEX $docname
    &$LATEX $docName
    &$LATEX $docName
}

function CleanLogFiles () {
    rm *.aux, *.log, *.out, *.bbl, *.blg, *.brf
}

##########################
#     Main Procedure     #
##########################
#Ensures all internal variables are set, and command line arguments are stripped
SetInternalVariables $args[0]

#Ensures that all configuration is set correctly, and commands are available
CheckUserConfiguration

#All latex files from the documents root folder are collected an written to the index file
ComposeIndexFile

#Compiles the document and runs bibtex, makeindex etc
CompileDocument

#Ensures that all the annoying temp files are gone, for good
CleanLogFiles