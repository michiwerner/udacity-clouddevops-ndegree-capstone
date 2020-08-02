common_stack_name = devops-capstone-common
jenkins_stack_name = devops-capstone-jenkins
aws_region = eu-central-1

provision-common-stack:
	list_stacks_output=`aws cloudformation list-stacks \
		--region $(aws_region) \
		--output json \
		| jq -r '.StackSummaries[] | select(.StackStatus != "DELETE_COMPLETE") | select(.StackName == "$(common_stack_name)") | .StackName'`; \
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
provision-jenkins-stack:
	list_stacks_output=`aws cloudformation list-stacks \
		--region $(aws_region) \
		--output json \
		| jq -r '.StackSummaries[] | select(.StackStatus != "DELETE_COMPLETE") | select(.StackName == "$(jenkins_stack_name)") | .StackName'`; \
	if [ -n "$$list_stacks_output" ]; then \
		aws cloudformation update-stack \
			--stack-name $(jenkins_stack_name) \
			--region $(aws_region) \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters.json" \
			--output json; \
	else \
		aws cloudformation create-stack \
			--stack-name $(jenkins_stack_name) \
			--region $(aws_region) \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters.json" \
			--output json; \
	fi
delete-jenkins-stack:
	aws cloudformation delete-stack \
		--stack-name $(jenkins_stack_name) \
		--region $(aws_region)
	
	 