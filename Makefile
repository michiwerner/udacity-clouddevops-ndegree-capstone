COMMON_STACK_NAME = devops-capstone-common
JENKINS_STACK_NAME = devops-capstone-jenkins
AWS_REGION ?= eu-central-1
AWS_PROFILE ?= default

provision-common-stack:
	list_stacks_output=`aws cloudformation list-stacks \
		--region $(AWS_REGION) \
		--profile $(AWS_PROFILE) \
		--query "StackSummaries[?StackStatus != 'DELETE_COMPLETE' && StackName == '$(COMMON_STACK_NAME)'] | [0].StackName" \
		--output text`; \
	if [ "$$list_stacks_output" != "None" ]; then \
		aws cloudformation update-stack \
			--stack-name $(COMMON_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--template-body "file://./cloudformation/common/stack.yml" \
			--parameters "file://./cloudformation/common/parameters.json" \
			--output json; \
	else \
		aws cloudformation create-stack \
			--stack-name $(COMMON_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--template-body "file://./cloudformation/common/stack.yml" \
			--parameters "file://./cloudformation/common/parameters.json" \
			--output json; \
	fi
delete-common-stack:
	aws cloudformation delete-stack \
		--stack-name $(COMMON_STACK_NAME) \
		--region $(AWS_REGION) \
		--profile $(AWS_PROFILE)
provision-jenkins-stack:
	list_stacks_output=`aws cloudformation list-stacks \
		--region $(AWS_REGION) \
		--profile $(AWS_PROFILE) \
		--query "StackSummaries[?StackStatus != 'DELETE_COMPLETE' && StackName == '$(JENKINS_STACK_NAME)'] | [0].StackName" \
		--output text`; \
	if [ "$$list_stacks_output" != "None" ]; then \
		aws cloudformation update-stack \
			--stack-name $(JENKINS_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters.json" \
			--output json; \
	else \
		aws cloudformation create-stack \
			--stack-name $(JENKINS_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters.json" \
			--output json; \
	fi
delete-jenkins-stack:
	aws cloudformation delete-stack \
		--stack-name $(JENKINS_STACK_NAME) \
		--region $(AWS_REGION) \
		--profile $(AWS_PROFILE)

	 