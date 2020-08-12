# udacity-clouddevops-ndegree-capstone
The capstone project repository for my Udacity Cloud DevOps nanodegree. (Not yet earned!)

## Step 1: Stacks

The setup consists of three stacks: A common stack with the networking components (VPC, subnets, gateways etc.), a jenkins stack that provisions the jenkins EC2 instance, and a cluster stack that provisions the actual EKS kubernetes cluster.

Before executing the following commands in order, please make sure to review both the `Makefile` (especially the variables at the top!) and the `cloudformation/*/parameters.json` files and change parameters as appropriate. Then run the following commands. *After each one wait until the stack creation is complete before running the next.*

1. `make provision-common-stack`
2. `make provision-jenkins-stack`
3. `make provision-cluster-stack`
4. `make grant-kubernetes-access-to-jenkins`

## Step 2: Jenkins Setup (Interactive)

Now that the Jenkins instance is up and running, you will need to execute the following manual steps interactively.

SSH user is `ubuntu`.

1. Navigate to the public IP or public DNS hostname of your Jenkins EC2 instance over HTTPS. These values, including a HTTPS URL for your convenience, are outputs of the Jenkins Cloudformation stack. Alternatively, you can also look them up on the AWS Console's EC2 Instances page.
2. Since the HTTPS certificate is self-signed, depending on your web browser you will either have to confirm that you trust this website, or you can import the certificate as a trusted certificate on the OS level. For the latter, please find the certificate file on the Jenkins VM under the path `/etc/nginx/tls/selfsigned_cert.crt`.
3. Follow the Jenkins Setup procedure. Choose the suggested plugins option.
4. In the Jenkins Admin Area, open the Plugin Manger and install the following plugins: Blue Ocean, variant, pipeline-aws (Pipeline: AWS Steps), Kubernetes Continuous Deploy, docker-build-step.
5. Now you can add the folder where this code resides as a pipeline in jenkins. (e.g. GitHub connection)