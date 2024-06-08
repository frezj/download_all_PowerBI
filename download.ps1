# Just use powershell. You will have pop-up to login in your account
#
# Install the MicrosoftPowerBIMgmt module
Install-Module -Name MicrosoftPowerBIMgmt

# Connect to Power BI Service Account
Connect-PowerBIServiceAccount
Login-PowerBIServiceAccount
Login-PowerBI

# Get all workspaces
$workspace = Get-PowerBIWorkspace 

# Loop through every workspace
Foreach($j in $workspace) {   
    # Create a directory for each workspace
    New-Item -Path "C:\\PBIBackups\\" -Name $j.Name -ItemType "directory" 

    # Store reports inside the workspace in a variable
    $report = Get-PowerBIReport -Workspace $j 

    # Loop through every report in the workspace
    Foreach ($i in $report) {
        $name = "C:\\PBIBackups\\" + $j.Name + "\\" + $i.Name + ".pbix"
        # Adding the file format, commonly .pbix

        # Check if the report exists in the folder and delete it (It will be downloaded again in the next step)
        If(Test-Path $name) {
            Remove-Item $name 
            Write-Host $name - "Item removed correctly"
        }

        # Export the .pbix file
        Export-PowerBIReport -Id $i.Id -OutFile $name

        # Prompt the name of the report to check if it's downloaded correctly
        Write-Host $i.Name - "Downloaded correctly"
    }
}
