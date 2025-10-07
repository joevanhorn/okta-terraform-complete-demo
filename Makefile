.PHONY: help init plan apply destroy clean test

help:
	@echo "Available targets:"
	@echo "  init     - Initialize Terraform"
	@echo "  plan     - Run Terraform plan"
	@echo "  apply    - Apply Terraform changes"
	@echo "  destroy  - Destroy Terraform resources"
	@echo "  test     - Run tests"
	@echo "  clean    - Clean generated files"

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

destroy:
	cd terraform && terraform destroy

test:
	pytest tests/ -v

clean:
	rm -rf generated/ cleaned/ imported/
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type f -name "*.tfplan" -delete
