#The service, %UPTIME_SERVICENAME%, has entered the %UPTIME_SERVICESTATE% state, and has been so for %UPTIME_DURATION%. its host, %UPTIME_HOSTNAME%, is in the %UPTIME_HOSTSTATE% status. >> c:\uptime\scripts\hipchat_message_output.txt
#set up variables from UIM

$UPTIME_SERVICENAME = Get-ChildItem Env:UPTIME_SERVICENAME | select -expand value;
$UPTIME_SERVICESTATE = Get-ChildItem Env:UPTIME_SERVICESTATE | select -expand value;
$UPTIME_DURATION = Get-ChildItem Env:UPTIME_DURATION | select -expand value;
$UPTIME_HOSTNAME = Get-ChildItem Env:UPTIME_HOSTNAME | select -expand value;
$UPTIME_HOSTSTATE = Get-ChildItem Env:UPTIME_HOSTSTATE | select -expand value;

switch ($UPTIME_SERVICESTATE) 
    { 
        OK {"green"} 
        CRIT {"red"} 
        WARN {"orange"} 
        default {"black"}
    }
	
$payload = @{
	color= switch ($UPTIME_SERVICESTATE) 
		{ 
			OK {"green"} 
			CRIT {"red"} 
			WARN {"orange"} 
			default {"black"}
		}
	message='The service, ' + $UPTIME_SERVICENAME + ', has entered the ' + $UPTIME_SERVICESTATE + ' state, and has been so for ' + $UPTIME_DURATION + '. Its host, ' + $UPTIME_HOSTNAME +', is in the ' + $UPTIME_HOSTSTATE + ' state.'
	notify='false'
	message_format='text'
}

$json = $payload | ConvertTo-Json
$response = Invoke-RestMethod 'https://yoururlhere.com' -Method POST -Body $json -ContentType 'application/json'