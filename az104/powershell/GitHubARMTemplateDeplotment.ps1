connect-azaccount

$Location = "EastUS"
$RGN = "CBT_TEST_LAB_EASTUS"

New-AzResourceGroup -name $RGN -Location $Location



$grg = (Get-AzResourceGroup).ResourceGroupName

New-AzResourceGroupDeployment -name deployment1 -ResourceGroup $grg -TemplateUri "https://raw.githubusercontent.com/MuscleGeek69/azure_cert_journey/main/az104/windows_vm_deploy.json"

start-azvm -Name frontendSERVER -ResourceGroupName $RGN 
