#! /bin/bash
STACK_NAME=carlosmanso
REGION=us-east-1
CLI_PROFILE=default
# AWS_ID=`aws sts get-caller-identity`
# BUCKET_NAME=$REGION"-codepipeline-"$AWS_ID
EC2_INSTANCE_TYPE=t2.micro

echo -e "\n=========== Desplegando  setup.yml ================="

aws cloudformation deploy \
	--region $REGION \
	--profile $CLI_PROFILE \
	--stack-name $STACK_NAME-setup \
	--template-file setup.yml \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM \

echo -e "\n=========== Desplegando  main.yml ================="

aws cloudformation deploy \
	--region $REGION \
	--profile $CLI_PROFILE \
	--stack-name $STACK_NAME \
	--template-file main.yml \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM \
	--parameter-override EC2InstanceType=$EC2_INSTANCE_TYPE

	if [$? -eq 0]; then
		aws cloudformation list-exports \
		--profile default \
		--query "Exports[?Name=='EndPoint'].Value"
	fi



