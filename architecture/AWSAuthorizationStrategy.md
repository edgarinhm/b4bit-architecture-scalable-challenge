# Key Technologies

This pipeline is an efficient way to automate the deployment of your application to AWS without manually connecting to EC2 instances. By using AWS SSM, youincrease the security of your deployment process by eliminating the need for SSHaccess, while GitHub Actions makes the automation of the pipeline seamless.

- GitHub Actions: Automates workflows like CI/CD within GitHub repositories.
- AWS SSM (Systems Manager): Provides a secure way to execute commands on EC2 instances without needing direct SSH access

## Using OIDC (OpenID Connect) in GitHub Actions

OpenID Connect (OIDC) offers a more secure way to authenticate GitHub Actionswith AWS. Instead of storing long-term credentials, GitHub dynamically generates ashort-lived token that AWS verifies via a trust relationship. This token allows GitHubto assume an IAM role temporarily, limiting the scope and duration of AWS access.

1. Create an identity provider:
   - In AWS IAM, create a indentity provider. select token.actions.githubusercontent.com.
2. Create an IAM Role with OIDC Trust Policy:
   - In AWS IAM, create a new role. Under Trust Relationships, configure it to trust GitHub’s OIDC provider.
The trust policy should look something like this:

    ```Javascript
    {
        "Version":"2012-10-17",
        "Statement":[
        {
        "Effect":"Allow",
        "Principal":{
            "Federated":"arn:aws:iam::YOUR_AWS_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
            },
        "Action":"sts:AssumeRoleWithWebIdentity",
        "Condition":{
            "StringEquals":{
                "token.actions.githubusercontent.com:sub":"repo:your-repo-name:ref:refs/heads/main"
                }
            }
        }]
    }
    ````

3. Assign Permissions to the Role:
   - Attach the necessary AWS policies (e.g., S3 access) to the IAM role.

4. Modify Your Workflow to Use OIDC:
   - In your GitHub Actions workflow, configure the aws-actions/configure-aws-credentials action to assume the role using OIDC:

    ```yaml
    name: Deploy to AWS using OIDC

    on:
    push:
        branches:
        - main

    jobs:
    deploy:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout code
            uses: actions/checkout@v4

        - name: Configure AWS credentials using OIDC
            uses: aws-actions/configure-aws-credentials@v2
            with:
            role-to-assume: arn:aws:iam::123456789012:role/my-github-actions-role
            aws-region: us-west-2

        - name: Deploy to S3
            run: aws s3 sync ./build s3://my-bucket
    ```
