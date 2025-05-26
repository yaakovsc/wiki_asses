# Wiki.js Deployment on AWS using Terraform

## **Prerequisites**
- **AWS Account** with IAM permissions to create resources (VPC, ECS, RDS, S3, etc.).
- **Terraform v1.0+** installed locally.
- **AWS CLI** configured with credentials for programmatic access.

---

## **Setup Instructions**

### **1. Clone the Repository**
```bash
git clone https://github.com/yaakovsc/wiki-js-aws.git
cd wiki-js-aws
```

### **2. Initialize Terraform**
```bash
terraform init
```

### **3. Deploy Infrastructure**
Replace placeholders with your values (e.g., ACM certificate ARN for HTTPS):

```bash
terraform apply \
  -var="acm_cert_arn=<your_acm_certificate_arn>"
```

### **4. Access Wiki.js**
After deployment, retrieve the ALB DNS name from Terraform outputs:

```bash
echo "ALB DNS: $(terraform output -raw alb_dns)"
```
Open the ALB DNS URL in a browser to complete the Wiki.js web UI setup.

---

## **Teardown Instructions**
To destroy all resources and avoid AWS charges:

```bash
terraform destroy
```

## **Security Considerations**
### **Encryption**
- **RDS/S3**: Encrypted at rest using AWS KMS.
- **HTTPS**: TLS/SSL termination at the ALB using an ACM certificate.

### **IAM Roles**
- **Least Privilege**: ECS tasks only have read/write access to the designated S3 bucket and Secrets Manager.

### **Secrets Management**
- **Database Credentials**: Stored in AWS Secrets Manager (auto-generated during deployment).
- **No Hardcoded Secrets**: Passwords are dynamically injected into ECS tasks.

### **Network Security**
**Security Groups**:
- **ALB**: Only allows inbound HTTPS (443).
- **ECS**: Only allows traffic from the ALB on port 3000.
- **RDS**: Restricted to ECS tasks on port 5432.

### **Monitoring**
- **CloudWatch Alarms**: Triggered for unauthorized access attempts, high error rates, or resource exhaustion

---
## **Scaling Strategies**
### **ECS Auto Scaling**
- **CPU/Memory-Based Scaling**: Automatically adjusts the number of ECS tasks based on utilization thresholds.
- **Multi-AZ Deployment**: Tasks distributed across Availability Zones for redundancy.

### **RDS Read Replicas**
- **Manual Provisioning**: Add read replicas via AWS Console/Terraform if read-heavy traffic increases.

### **ALB Traffic Distribution**
- **Load Balancing**: Routes traffic evenly across ECS tasks in multiple AZs.
- **Health Checks**: Automatically replaces unhealthy tasks.

---
## **Observability**
### **CloudWatch Logs**
- **ECS Task Logs**: Container stdout/stderr streams.
- **ALB Access Logs**: Track HTTP requests and errors.

### **Metrics**
- **ECS**: CPU/Memory usage, task count.
- **RDS**: Storage, CPU, connections.
- **ALB**: Request count, latency, 4xx/5xx errors.

### **Alarms**
#### **High Priority**:
- High CPU/Memory Utilization (>70%)
- RDS Free Storage < 20%
- ALB 5xx Errors > 10/minute
#### **Alert Channels**: 
- Configure SNS notifications for alarms.

---

### **High-Level Overview**
<img width="586" alt="image" src="https://github.com/user-attachments/assets/48bb9386-33f0-45b8-a131-efcd36ee0474" />

### **VPC & Networking Layout**
<img width="474" alt="image" src="https://github.com/user-attachments/assets/879e29d5-a539-4d31-8f1f-e9db9454bd4b" />

### **Compute & Storage Layer**
<img width="474" alt="image" src="https://github.com/user-attachments/assets/4af12d7d-3c6f-4533-a08f-36af400cff72" />

### **Security Architecture**
<img width="474" alt="image" src="https://github.com/user-attachments/assets/5a06c489-5a7b-45bf-8657-22ee103f27a8" />

### **Observability & Monitoring**
<img width="474" alt="image" src="https://github.com/user-attachments/assets/1f4df58f-290a-4a6b-8962-6c1a3680255c" />

### **Data Flow Diagram**
<img width="394" alt="image" src="https://github.com/user-attachments/assets/88158ddb-d780-4ef0-8403-c537d12763aa" />

### **High Availability (HA) Design**
<img width="372" alt="image" src="https://github.com/user-attachments/assets/1b9a26e3-fe94-4143-94d5-8284416ab0a2" />

---
## **Troubleshooting**
### **ECS Tasks Not Starting**:
- Check task logs**: aws logs tail /ecs/wiki.
- Validate Secrets Manager permissions for the ECS task role.

### **ALB 502 Errors**:
- Ensure ECS tasks are healthy and listening on port 3000.
- Verify security group rules between ALB and ECS.

### **RDS Connection Failures**:
- Check if the RDS security group allows traffic from ECS tasks on 5432.
