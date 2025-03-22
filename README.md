# Cloud Architecture for a Scalable Data Processing System Using Terraform

## Objective

Design, implement, and deploy a scalable cloud-based solution for a data aggregation
system using Terraform for infrastructure as code (IaC). The system should handle data
ingestion, processing, and storage securely and efficiently.

### Reference Architecture Design

#### 5 Logical Layers Composed of Purpose-Built Components

- Source: Devices or applications that produce real-time data at high velocity
- Stream ingestion: Data from tens of thousands of data sources can be collected and ingested in real time
- Stream storage: Data is stored in the order received for a set time and can be replayed indefinitely during that time
- Stream processing: Records are read in the order they’re produced, allowing for real-time analytics or streaming ETL
- Destination: Data lake Data warehouse Database OpenSearch Event driven Applications

![reference-architecture-design](architecture/data-batch-and-stream-reference-architecture.drawio.svg)

#### Pipeline Overview

The batch processing pipeline consists of six key stages:

1. Data Ingestion (Extract)
2. Data Transformation (Transform)
3. Data Storage (Load)
4. Orchestration & Automation
5. Monitoring & Optimization
6. Security & Governance

#### 1. Efficient Data Ingestion (Extract)

Ingesting large datasets efficiently is the first challenge in building a robust data pipeline. A pipeline must handle massive volumes of data reliably, even during spikes in traffic.

#### 2. Scalable and Fault-Tolerant Data Transformation (Transform)

Data transformation is where raw data is cleaned, filtered, aggregated, and prepared for analysis. The transformation stage should be designed to handle large-scale distributed processing with minimal operational overhead.

#### 3. Efficient and Optimized Data Storage (Load)

Once the data has been processed, it must be stored in a way that supports efficient querying and long-term storage while minimizing cost.

#### 4. Advanced Orchestration & Automation

Data pipelines require robust orchestration to ensure smooth operation, automatic failure recovery, and minimal manual intervention.

#### 5. Monitoring and Continuous Optimization

Monitoring the pipeline’s performance and resource usage is critical for detecting issues early and ensuring optimal performance.

#### 6. Enterprise-Grade Security & Governance

Ensuring data security and regulatory compliance is critical for any data processing pipeline. Governance must be in place to control access and ensure data is protected throughout its lifecycle.

### Cloud Data Architecture Diagram

![cloud-diagram](architecture/data-batch-and-stream-architecture-diagram.drawio.svg)

### Github strategy

Ensure secure repository adding github branch rule require a pull request before merging rule to prevent changes direct to main with at least 1 approval(s) from other collaborators of the repo.

![github-workflow-diagram](architecture/terraform-pipeline-workflow.drawio.svg)

**CI/CD Pipeline:**

The GitHub Actions workflow automates the following:

- **`terraform tflint`:** Validate the Terraform linter files.
- **`terraform tfsec`:** Checks the Terraform security.
- **`terraform init`:** Initializes the Terraform working directory.
- **`terraform plan`:** Generates a Terraform plan on pull requests. The plan is also added as a comment to the pull request.
- **`terraform apply`:** Applies the Terraform plan automatically when changes are merged into the `main` branch.
- **`terraform destroy`:** Destroys the Terraform plan automatically following the schedule rule.

#### Using OIDC (OpenID Connect) in GitHub Actions

OpenID Connect (OIDC) offers a more secure way to authenticate GitHub Actionswith AWS. Instead of storing long-term credentials, GitHub dynamically generates ashort-lived token that AWS verifies via a trust relationship. This token allows GitHubto assume an IAM role temporarily, limiting the scope and duration of AWS access [aws-authorization-strategy](architecture/AWSAuthorizationStrategy.md)

#### DevOps aws role to authorize github actions

Create a new rol for OIDC connection with the following policies:

![image](https://github.com/user-attachments/assets/443f1643-5dc8-40f4-b7c2-e6db3df675d4)


##### Custom policies:
custom-mock-data-generation-policy
```javascript
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "CustomRoleLambdaS1",
			"Effect": "Allow",
			"Action": [
				"lambda:CreateFunction",
				"lambda:GetFunction",
				"lambda:ListVersionsByFunction",
				"lambda:GetFunctionCodeSigningConfig",
				"lambda:DeleteFunction",
				"lambda:AddPermission",
				"lambda:GetPolicy",
				"lambda:RemovePermission",
				"lambda:CreateEventSourceMapping",
				"lambda:GetEventSourceMapping",
				"lambda:ListTags",
				"lambda:DeleteEventSourceMapping"
			],
			"Resource": [
				"*"
			]
		},
		{
			"Sid": "CustomRoleEventS1",
			"Effect": "Allow",
			"Action": [
				"events:PutRule",
				"events:DescribeRule",
				"events:ListTagsForResource",
				"events:DeleteRule",
				"events:PutTargets",
				"events:ListTargetsByRule",
				"events:RemoveTargets"
			],
			"Resource": [
				"*"
			]
		}
	]
}
```
custom-role-kms-key-rotation-policy
```javascript
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "CustomEnableKeyRotationS1",
			"Effect": "Allow",
			"Action": [
				"kms:EnableKeyRotation",
				"kms:ScheduleKeyDeletion"
			],
			"Resource": "*"
		}
	]
}
```

### S3 bucket processed data 
![image](https://github.com/user-attachments/assets/5021f199-6849-476e-81f1-05542b61c14a)

### DynamoDB processed data
![image](https://github.com/user-attachments/assets/2f491ed9-60bf-4444-97e6-3f41554b167b)

### API get average temperature request
![image](https://github.com/user-attachments/assets/661bb57c-ceb4-4759-9ffb-24e72a2e33dd)

