$headers = @{}
$headers.add("Authorization", "Basic YWRtaW46YWRtaW4=")

$response = Invoke-RestMethod 'http://localhost:3001/api/search' -Method 'GET' -Headers $headers

foreach($item in $response)
{
	$url = 'http://localhost:3001/api/dashboards/uid/' + $item.uid
	write-host $url
	$dashboard = Invoke-RestMethod $url -Method 'GET' -Headers $headers
	write-host "---------"
	
	$filename = $item.uri -replace "db/", ""
	$filename += ".json"
	write-host $filename
	
	$path = "grafana_dashboards"
	if(-not (test-path $path))
	{
		New-Item -Path $path -ItemType Directory
	}
	
	$dashboard.dashboard | ConvertTo-Json -Depth 100 | out-file $path/$filename -Encoding UTF8NoBOM
}
