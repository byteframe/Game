Get-WmiObject Win32_process -filter 'name = "OVRServer_x64.exe"' | foreach-object { $_.SetPriority(128) }