$taggableArray = "$(taggable)".Split(',')

foreach ($resource in
    ((az resource list --query "[?tags.CreatedOnDate == null]") | ConvertFrom-Json | Where { $taggableArray -contains $_.Type }))
    {
       if($resource.CreatedTime -eq $null) {
            Write-Host -Message "--- CreatedTime is not available on $( $resource.Name ) --- "
            continue
        }

        $resourceTags = ($resource.Tags | ConvertTo-Json | ConvertFrom-Json -AsHashTable) ?? @{}

        $createdTime = [Datetime]::ParseExact($resource.CreatedTime,'MM/dd/yyyy HH:mm:ss',$null).ToString('MM/dd/yyyy')

        $resourceTags += @{CreatedOnDate=$createdTime}

        Set-AzResource -Tag $resourceTags -ResourceId $resource.Id -Force -ErrorAction continue
        Write-Host  "Resource $( $resource.Name ) has had tags applied"
        Write-Host  ' '
}





$resource = ((az resource list -n "$(ResourceName)") | ConvertFrom-Json)[0]

$resourceTags = ($resource.Tags | ConvertTo-Json | ConvertFrom-Json -AsHashTable) ?? @{}

$resourceTags += @{"$(TagName)"="$(TagValue)"}


Set-AzResource -Tag $resourceTags -ResourceId $resource.Id -Force -ErrorAction continue
Write-Host  "Resource $( $resource.Name ) has had tags applied"

