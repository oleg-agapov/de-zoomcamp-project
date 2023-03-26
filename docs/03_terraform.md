# Terraform setup

1. From inside the `/terraform` folder execute the following commands:

    ```bash
    terraform init

    terraform fmt

    terraform plan
    ```

1. Apply your changes to production with:

    ```bash
    terraform apply
    ```

    Type `yes` when prompted to confirm.

1. If you want to remove everything, run:

    ```bash
    terraform destroy
    ```