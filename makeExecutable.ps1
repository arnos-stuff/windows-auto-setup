# PS2EXE-GUI v0.5.0.28 by Ingo Karstein, reworked and GUI support by Markus Scholtes

# Usage:

# Invoke-ps2exe [-inputFile] '<filename>' [[-outputFile] '<filename>']
#               [-prepareDebug] [-x86|-x64] [-lcid <id>] [-STA|-MTA] [-noConsole] [-UNICODEEncoding]
#               [-credentialGUI] [-iconFile '<filename>'] [-title '<title>'] [-description '<description>']
#               [-company '<company>'] [-product '<product>'] [-copyright '<copyright>'] [-trademark '<trademark>']
#               [-version '<version>'] [-configFile] [-noOutput] [-noError] [-noVisualStyles] [-exitOnCancel]
#               [-DPIAware] [-winFormsDPIAware] [-requireAdmin] [-supportOS] [-virtualize] [-longPaths]

#        inputFile = Powershell script that you want to convert to executable (file has to be UTF8 or UTF16 encoded)
#       outputFile = destination executable file name or folder, defaults to inputFile with extension '.exe'
#     prepareDebug = create helpful information for debugging
#       x86 or x64 = compile for 32-bit or 64-bit runtime only
#             lcid = location ID for the compiled executable. Current user culture if not specified
#       STA or MTA = 'Single Thread Apartment' or 'Multi Thread Apartment' mode
#        noConsole = the resulting executable will be a Windows Forms app without a console window
#  UNICODEEncoding = encode output as UNICODE in console mode
#    credentialGUI = use GUI for prompting credentials in console mode
#         iconFile = icon file name for the compiled executable
#            title = title information (displayed in details tab of Windows Explorer's properties dialog)
#      description = description information (not displayed, but embedded in executable)
#          company = company information (not displayed, but embedded in executable)
#          product = product information (displayed in details tab of Windows Explorer's properties dialog)
#        copyright = copyright information (displayed in details tab of Windows Explorer's properties dialog)
#        trademark = trademark information (displayed in details tab of Windows Explorer's properties dialog)
#          version = version information (displayed in details tab of Windows Explorer's properties dialog)
#       configFile = write a config file (<outputfile>.exe.config)
#         noOutput = the resulting executable will generate no standard output (includes verbose and information channel)
#          noError = the resulting executable will generate no error output (includes warning and debug channel)
#   noVisualStyles = disable visual styles for a generated windows GUI application (only with -noConsole)
#     exitOnCancel = exits program when Cancel or "X" is selected in a Read-Host input box (only with -noConsole)
#         DPIAware = if display scaling is activated, GUI controls will be scaled if possible
# winFormsDPIAware = if display scaling is activated, WinForms use DPI scaling (requires Windows 10 and .Net 4.7 or up)
#     requireAdmin = if UAC is enabled, compiled executable run only in elevated context (UAC dialog appears if required)
#        supportOS = use functions of newest Windows versions (execute [Environment]::OSVersion to see the difference)
#       virtualize = application virtualization is activated (forcing x86 runtime)
#        longPaths = enable long paths ( > 260 characters) if enabled on OS (works only with Windows 10 or up)

Invoke-PS2EXE -inputFile mvsc.ps1 -outputFile 'msvc-installer.exe' -noError -title 'MVSC Installer' -MTA -description 'Installs MS Visual Studio Build Tools C++ using the provided official link by microsoft' -UNICODEEncoding -WarningAction SilentlyContinue -ErrorAction Inquire ;