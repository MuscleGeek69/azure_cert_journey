param publicIPAddresses_srqh1_s2s_pip_name string = 'srqh1-s2s-pip'
param virtualNetworks_default_s2s_network_name string = 'default_s2s_network'
param virtualNetworkGateways_default_s2s_vpn_name string = 'default-s2s-vpn'

resource publicIPAddresses_srqh1_s2s_pip_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_srqh1_s2s_pip_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: ''
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_default_s2s_network_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_default_s2s_network_name}/GatewaySubnet'
  properties: {
    addressPrefix: '192.168.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_default_s2s_network_name_resource
  ]
}

resource virtualNetworks_default_s2s_network_name_vm_subnets_192_168_0_0_24 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_default_s2s_network_name}/vm-subnets-192.168.0.0-24'
  properties: {
    addressPrefix: '192.168.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: []
}

resource virtualNetworks_default_s2s_network_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_default_s2s_network_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'vm-subnets-192.168.0.0-24'
        id: virtualNetworks_default_s2s_network_name_vm_subnets_192_168_0_0_24.id
        properties: {
          addressPrefix: '192.168.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_default_s2s_network_name_GatewaySubnet.id
        properties: {
          addressPrefix: '192.168.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
