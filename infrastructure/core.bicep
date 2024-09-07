param location string
param  prefix string

param vnetSettings object = {
  addressPrefixes: [
    '10.0.0.0/20'
  ]
  subnets: [
    {
      name: 'default'
      addressPrefix: '10.0.0.0/20'
      }

  ]
}


resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${prefix}-default-nsg'
  location: location
  properties: {
    securityRules: [
      
    ]
  }
}


resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: '${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetSettings.addressPrefixes
    }
    subnets: [  for subnet in vnetSettings.subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        networkSecurityGroup: {
          id: networkSecurityGroup.id
        }
      }
    }]
  }
}


resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-09-15' = {
  name: '${prefix}cosmosdbaccount'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    enableMultipleWriteLocations: false
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

resource sqlDb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-09-15' = {
  name: '${prefix}-sqldb'
  parent: cosmosDbAccount
  properties: {
    resource: {
      id: '${prefix}-sqldb'
    }
    options: {
    }
  }
}


resource sqlContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-09-15' = {
  name: '${prefix}-container'
  parent: sqlDb
  properties: {
    resource: {
      id: '${prefix}-container'
      partitionKey: {
        paths: [
          '/id'
        ]
      }
    }
    options: {
    }
  }
}
