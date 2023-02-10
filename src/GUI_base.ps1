# Force elevated instance
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# Import dependencies for GUI-based application
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# GUI variables
$WUMG_Font = "Microsoft Sans Serif, 12"
$WUMG_BackColor = "#222233"
$WUMG_ForeColor = "#FFFFFF"

# Functions
function WUMG_Log([string]$WUMG_LogMessage) {
  $WUMG_LogDate = Get-Date -Format "dd/MM/yy HH:mm"
  $WUMG_LogOutput = "[$WUMG_LogDate][LOG]: $WUMG_LogMessage"
  Write-Host $WUMG_LogOutput -ForegroundColor Blue
}
function WUMG_Warn([string]$WUMG_LogMessage) {
  $WUMG_LogDate = Get-Date -Format "dd/MM/yy HH:mm"
  $WUMG_LogOutput = "[$WUMG_LogDate][WARN]: $WUMG_LogMessage"
  Write-Host $WUMG_LogOutput -ForegroundColor DarkYellow
}

function WUMG_FEL_Function {
  WUMG_Log("Pressed Enable Feature button")
  If ($WUMG_FEL_Dropdown.SelectedIndex -eq 0) {
    WUMG_Log("Enabling Group Policy Editor...")
    Set-Location ./function
    cmd.exe /c enable_gpedit.bat
    Set-Location ../
    WUMG_Log("Enabled Group Policy Editor.")
  }
  If ($WUMG_FEL_Dropdown.SelectedIndex -eq 1) {
    WUMG_Log("Option 2, unknown")
  }
}

# Create main GUI
[System.Windows.Forms.Application]::EnableVisualStyles()
$WinUtilitiesMainGUI = New-Object system.Windows.Forms.Form
$WinUtilitiesMainGUI.ClientSize = '500,300'
$WinUtilitiesMainGUI.text = "WinUtilities"
$WinUtilitiesMainGUI.BackColor = $WUMG_BackColor
$WinUtilitiesMainGUI.Icon = New-Object system.drawing.icon ("./GUI_icon.ico")

# Create feature enable list
$WUMG_FEL_Features = @("Group Policy Editor",'Hp')
$WUMG_FEL_Label = New-Object system.Windows.Forms.Label
$WUMG_FEL_Label.text = "Feature Enabling"
$WUMG_FEL_Label.AutoSize = $true
$WUMG_FEL_Label.Font = $WUMG_Font
$WUMG_FEL_Label.ForeColor = $WUMG_ForeColor
$WUMG_FEL_Label.location = New-Object System.Drawing.Point(5, 5)
$WUMG_FEL_Dropdown = New-Object system.Windows.Forms.ComboBox
$WUMG_FEL_Dropdown.text = ""
$WUMG_FEL_Dropdown.width = 170
$WUMG_FEL_Dropdown.autosize = $true
$WUMG_FEL_Features | ForEach-Object {[void] $WUMG_FEL_Dropdown.Items.Add($_)}
$WUMG_FEL_Dropdown.SelectedIndex = 0
$WUMG_FEL_Dropdown.Font = $WUMG_Font
$WUMG_FEL_Dropdown.location = New-Object System.Drawing.Point(150, 0)
$WUMG_FEL_Button = New-Object system.Windows.Forms.Button
$WUMG_FEL_Button.BackColor = $WUMG_ForeColor
$WUMG_FEL_Button.ForeColor = "#000000"
$WUMG_FEL_Button.text = "Enable Feature"
$WUMG_FEL_Button.AutoSize = $false
$WUMG_FEL_Button.width = 170
$WUMG_FEL_Button.height = 30
$WUMG_FEL_Button.location = New-Object System.Drawing.Point(320, 0)
$WUMG_FEL_Button.Font = $WUMG_Font
$WUMG_FEL_Button.Add_Click({ WUMG_FEL_Function })
$WinUtilitiesMainGUI.controls.AddRange(@($WUMG_FEL_Label, $WUMG_FEL_Dropdown, $WUMG_FEL_Button))

# Show the entire GUI
[void]$WinUtilitiesMainGUI.ShowDialog()