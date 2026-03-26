# EnviroTrack — End-to-End DevOps Project

This repository demonstrates a production-style DevOps workflow for deploying a containerized Python API with CI/CD, infrastructure provisioning, configuration management, and monitoring.

## Project Structure

```text
envirotrack-devops/
├── .gitlab-ci.yml
├── README.md
├── ansible/
│   └── playbook.yml
├── app/
│   ├── Dockerfile
│   ├── main.py
│   ├── requirements.txt
│   └── test_main.py
└── terraform/
    ├── main.tf
    ├── network.tf
    ├── outputs.tf
    ├── terraform.tfvars.example
    ├── variables.tf
    └── versions.tf
```

## What This Project Demonstrates

- GitLab CI pipeline with lint, test, build, provision, and deploy stages
- FastAPI service packaged as a Docker container
- Terraform provisioning for an AWS EC2 deployment target
- Ansible-based host configuration and container deployment
- Zabbix agent installation for monitoring readiness

## Pipeline Flow

1. Lint the Python code with `flake8`
2. Run automated API tests with `pytest`
3. Build and push a Docker image to the GitLab container registry
4. Run Terraform plan for infrastructure changes
5. Deploy the built image to the target host using Ansible

## Prerequisites

- GitLab project with Container Registry enabled
- AWS credentials configured in CI/CD variables
- SSH private key stored in `SSH_PRIVATE_KEY`
- `DEPLOY_TARGET_IP` variable pointing to the EC2 host
- Optional `TF_VAR_key_name` and `TF_VAR_allowed_cidr` Terraform variables
- Optional `ZABBIX_SERVER_IP` variable for monitoring configuration

## Local Usage

### Run the app locally

```bash
cd app
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

Visit:

- `http://localhost:8000/health`
- `http://localhost:8000/metrics`
- `http://localhost:8000/obligations`

### Build locally with Docker

```bash
cd app
docker build -t envirotrack-api .
docker run -p 8000:8000 envirotrack-api
```

### Test Terraform

```bash
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan
```

To override defaults without editing the source files, copy `terraform/terraform.tfvars.example`
to `terraform/terraform.tfvars` and adjust the values for your environment.

### Test Ansible

```bash
cd ansible
ansible-playbook -i "HOST_IP," playbook.yml -u ubuntu --private-key ~/.ssh/your-key.pem --extra-vars "app_image=envirotrack-api zabbix_server_ip=10.0.0.50"
```

## CI/CD Variables To Configure

- `CI_REGISTRY_USER`
- `CI_REGISTRY_PASSWORD`
- `SSH_PRIVATE_KEY`
- `DEPLOY_TARGET_IP`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `ZABBIX_SERVER_IP`

## Suggested Next Upgrades

- Add separate `dev`, `stage`, and `prod` environments
- Use remote Terraform state with locking
- Add Trivy or Snyk image scanning
- Add rollback support and manual approval gates
- Move secrets to AWS Secrets Manager or Vault
