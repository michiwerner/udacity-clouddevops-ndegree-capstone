common_stack_name = devops-capstone-common
jenkins_stack_name = devops-capstone-jenkins
aws_region = eu-central-1
ubuntu_ami_name = ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20200716
ubuntu_ami_id = $(shell aws ec2 describe-images --region $(aws_region) --filters \
		"Name=architecture,Values=x86_64" \
		"Name=is-public,Values=true" \
		"Name=name,Values=$(ubuntu_ami_name)" \
		--query 'Images[0].[ImageId]' \
		--output text \
	)

provision-common-stack:
	list_stacks_output=`aws cloudformation list-stacks \
		--region $(aws_region) \
		--query "StackSummaries[?StackStatus != 'DELETE_COMPLETE' && StackName == '$(common_stack_name)'] | [0].StackName" \
		--output text`; \
	if [ -n "$$list_stacks_output" ]; then \
		aws cloudformation update-stack \
			--stack-name $(common_stack_name) \
			--region $(aws_region) \
			--template-body "file://./cloudformation/common/stack.yml" \
			--parameters "file://./cloudformation/common/parameters.json" \
			--output json; \
	else \
		aws cloudformation create-stack \
			--stack-name $(common_stack_name) \
			--region $(aws_region) \
			--template-body "file://./cloudformation/common/stack.yml" \
			--parameters "file://./cloudformation/common/parameters.json" \
			--output json; \
	fi
delete-common-stack:
	aws cloudformation delete-stack \
		--stack-name $(common_stack_name) \
		--region $(aws_region)
cloudformation/jenkins/parameters-$(aws_region).json:
	sed -e 's/<<<AMI_ID>>>/$(ubuntu_ami_id)/' ./cloudformation/jenkins/parameters.tpl.json > ./cloudformation/jenkins/parameters-$(aws_region).json
provision-jenkins-stack: cloudformation/jenkins/parameters-$(aws_region).json
	list_stacks_output=`aws cloudformation list-stacks \
		--region $(aws_region) \
		--output json \
		| jq -r '.StackSummaries[] | select(.StackStatus != "DELETE_COMPLETE") | select(.StackName == "$(jenkins_stack_name)") | .StackName'`; \
	if [ -n "$$list_stacks_output" ]; then \
		aws cloudformation update-stack \
			--stack-name $(jenkins_stack_name) \
			--region $(aws_region) \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters-$(aws_region).json" \
			--output json; \
	else \
		aws cloudformation create-stack \
			--stack-name $(jenkins_stack_name) \
			--region $(aws_region) \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters-$(aws_region).json" \
			--output json; \
	fi
delete-jenkins-stack:
	aws cloudformation delete-stack \
		--stack-name $(jenkins_stack_name) \
		--region $(aws_region)
	
	 