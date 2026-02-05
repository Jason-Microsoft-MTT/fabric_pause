targetScope = 'resourceGroup'

@description('Please specify a location')
param location string = resourceGroup().location

@description('Please specify the Fabric capacity administrator')
param admin string

@description('Please specify the Fabric capacity SKU')
param sku string

@description('Allocates a unique name for the Fabric capacity')
param fabricName string


resource fabric 'Microsoft.Fabric/capacities@2023-11-01' = {
  location: location
  name: fabricName
  properties: {
    administration: {
      members: [
        admin
      ]
    }
  }
  sku: {
    name: sku
    tier: 'Fabric'
  }
}

resource logicapp_pause_fabric 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'logicapp-pause-fabric'
  location: location
  dependsOn: [
    fabric
    ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/schemas/2016-06-01/Microsoft.Logic.json'
      contentVersion: '1.0.0.0'
      parameters: {
        '$suspenduri': {
          type: 'String'
        }
        '$getdetailsuri': {
          type: 'String'
        }
      }
      triggers: {
        Every_4_hours: {
          recurrence: {
            frequency: 'Hour'
            interval: 4
            timeZone: 'UTC'
          }
          type: 'Recurrence'
        }
      }
      actions: {
        Condition: {
          actions: {
            Suspend: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  type: 'ManagedServiceIdentity'
                }
                method: 'POST'
                uri: '@parameters(\'$suspenduri\')'
              }
            }
          }
          runAfter: {
            Parse_JSON: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                not: {
                  equals: [
                    '@body(\'Parse_JSON\')?[\'properties\']?[\'state\']'
                    'Paused'
                  ]
                }
              }
            ]
          }
          type: 'If'
        }
        Get_Fabric_Capacity: {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: '@parameters(\'$getdetailsuri\')'
          }
        }
        Parse_JSON: {
          runAfter: {
            Get_Fabric_Capacity: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'Get_Fabric_Capacity\')'
            schema: {
              properties: {
                id: {
                  type: 'string'
                }
                location: {
                  type: 'string'
                }
                name: {
                  type: 'string'
                }
                properties: {
                  properties: {
                    administration: {
                      properties: {
                        members: {
                          items: {
                            type: 'string'
                          }
                          type: 'array'
                        }
                      }
                      type: 'object'
                    }
                    mode: {
                      type: 'string'
                    }
                    provisioningState: {
                      type: 'string'
                    }
                    state: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                sku: {
                  properties: {
                    capacity: {
                      type: 'integer'
                    }
                    name: {
                      type: 'string'
                    }
                    tier: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                tags: {
                  properties: {}
                  type: 'object'
                }
                type: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      outputs: {
      }
    }
    parameters: {
      '$suspenduri': {
        type: 'String'
        value: '${environment().resourceManager}subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Fabric/capacities/${fabricName}/suspend?api-version=2023-11-01'
      }
      '$getdetailsuri': {
        type: 'String'
        value: '${environment().resourceManager}subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Fabric/capacities/${fabricName}?api-version=2023-11-01'
      }
    }
  }
}

// Assign Contributor permissions to the Resource Group, which allows Logic App to access the Fabric resource
resource LogicAppFabricRBAC 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(concat(resourceGroup().id), logicapp_pause_fabric.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalId: reference(logicapp_pause_fabric.id, '2017-07-01', 'full').identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output fabricId string = fabric.id
output fabricName string = fabric.name
output logicappid string = logicapp_pause_fabric.id
output logicappname string = logicapp_pause_fabric.name
