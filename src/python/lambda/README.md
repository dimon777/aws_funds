To redeploy pipeline [dev]:

./bundle
export AWS_PROFILE=aws-dev
terraform workspace select aws-dev

cd src/terraform
terraform.exe apply -target=module.lambda