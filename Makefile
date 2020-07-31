provision-common:
	aws cloudformation create-stack \
    	--stack-name devops-capstone \
    	--region eu-central-1 \
    	--template-body "file://./cloudformation/common/stack.yml" \
    	--parameters "file://./cloudformation/common/parameters.json" \
    	--output json
	 