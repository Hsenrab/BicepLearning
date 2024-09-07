https://github.com/Hsenrab/BicepLearning.git

API applicaltion for 
lambda store

az group create --n lambda-api-dev --location uksouth
az deployment group create -g lambda-api-dev --template-file ./infrastructure/core.bicep --parameters ./configurations/dev.bicepparam


az group delete --name lambda-api-dev --yes --no-wait