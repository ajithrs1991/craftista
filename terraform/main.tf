ansible/
├── playbooks/
│   └── deploy_nginx.yml             # Common playbook for all environments
├── inventory/
│   ├── dev_inventory.ini           # Inventory for Dev Environment
│   ├── staging_inventory.ini       # Inventory for Staging Environment
│   └── prod_inventory.ini          # Inventory for Prod Environment
├── roles/
│   └── nginx-docker-deploy/        # Role for deploying NGINX in Docker
│       ├── defaults/
│       │   └── main.yml            # Default variables for the role
│       ├── vars/
│       │   └── main.yml            # Main environment-specific variables
│       ├── tasks/
│       │   └── main.yml            # Main tasks for the role
│       ├── templates/
│       │   └── nginx.conf.j2       # NGINX config template
│       ├── handlers/
│       │   └── main.yml            # Handlers for restarting NGINX container
│       └── meta/
│           └── main.yml            # Metadata for the role
├── group_vars/
│   ├── dev.yml                     # Dev variables for shared environment-specific configurations
│   ├── staging.yml                 # Staging variables for shared environment-specific configurations
│   └── prod.yml                    # Prod variables for shared environment-specific configurations
├── project_vars/
│   ├── project1.yml                # Project1-specific variables
│   ├── project2.yml                # Project2-specific variables
└── requirements.yml                # External role dependencies (if any)


---
- name: Deploy NGINX Docker Container
  hosts: all
  become: true
  vars_files:
    - group_vars/{{ ansible_environment }}.yml    # This loads environment-specific variables (dev, staging, prod)
    - project_vars/{{ project_name }}.yml         # This loads project-specific variables (project1, project2)
  roles:
    - nginx-docker-deploy

pipeline {
    agent any

    environment {
        TF_VAR_project = 'example-project'
        TF_VAR_region = 'us-west-2'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo/terraform.git'
            }
        }

        stage('Init Terraform') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Destroy Terraform (Optional)') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment was successful!'
        }
        failure {
            echo 'Terraform deployment failed.'
        }
    }
}
