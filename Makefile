common_stack_name = devops-capstone
aws_region = eu-central-1

provision-common:
	aws cloudformation create-stack \
    	--stack-name $(common_stack_name) \
    	--region $(aws_region) \
    	--template-body "file://./cloudformation/common/stack.yml" \
    	--parameters "file://./cloudformation/common/parameters.json" \
    	--output json
	 