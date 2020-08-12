COMMON_STACK_NAME ?= devops-capstone-common
JENKINS_STACK_NAME ?= devops-capstone-jenkins
CLUSTER_STACK_NAME ?= devops-capstone-cluster
CLUSTER_NAME ?= devops-capstone-eks-cluster
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
			--parameters "file://./cloudformation/common/parameters.json"; \
	else \
		aws cloudformation create-stack \
			--stack-name $(COMMON_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--template-body "file://./cloudformation/common/stack.yml" \
			--parameters "file://./cloudformation/common/parameters.json"; \
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
			--capabilities CAPABILITY_NAMED_IAM \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters.json"; \
	else \
		aws cloudformation create-stack \
			--stack-name $(JENKINS_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--capabilities CAPABILITY_NAMED_IAM \
			--template-body "file://./cloudformation/jenkins/stack.yml" \
			--parameters "file://./cloudformation/jenkins/parameters.json"; \
	fi
delete-jenkins-stack:
	aws cloudformation delete-stack \
		--stack-name $(JENKINS_STACK_NAME) \
		--region $(AWS_REGION) \
		--profile $(AWS_PROFILE)
provision-cluster-stack:
	list_stacks_output=`aws cloudformation list-stacks \
		--region $(AWS_REGION) \
		--profile $(AWS_PROFILE) \
		--query "StackSummaries[?StackStatus != 'DELETE_COMPLETE' && StackName == '$(CLUSTER_STACK_NAME)'] | [0].StackName" \
		--output text`; \
	if [ "$$list_stacks_output" != "None" ]; then \
		aws cloudformation update-stack \
			--stack-name $(CLUSTER_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
			--template-body "file://./cloudformation/cluster/stack.yml" \
			--parameters "file://./cloudformation/cluster/parameters.json"; \
	else \
		aws cloudformation create-stack \
			--stack-name $(CLUSTER_STACK_NAME) \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
			--template-body "file://./cloudformation/cluster/stack.yml" \
			--parameters "file://./cloudformation/cluster/parameters.json"; \
	fi
delete-cluster-stack:
	aws cloudformation delete-stack \
		--stack-name $(CLUSTER_STACK_NAME) \
		--region $(AWS_REGION) \
		--profile $(AWS_PROFILE)
grant-kubernetes-access-to-jenkins:
	aws eks --region $(AWS_REGION) update-kubeconfig --name $(CLUSTER_NAME)
	jenkins_ec2_role_arn=`aws cloudformation list-exports \
			--region $(AWS_REGION) \
			--profile $(AWS_PROFILE) \
			--query "Exports[?Name == 'CapstoneJenkinsEC2RoleArn'] | [0].Value" | sed -e 's/"//g'`; \
	cat aws-auth.tpl.yml | sed -e "s%ROLE_ARN%$$jenkins_ec2_role_arn%g" | kubectl apply -f -
