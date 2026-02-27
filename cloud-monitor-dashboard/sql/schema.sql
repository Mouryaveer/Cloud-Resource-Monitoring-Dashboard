CREATE DATABASE IF NOT EXISTS cloud_monitor;
USE cloud_monitor;

CREATE TABLE organizations (
  organization_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  subscription_plan VARCHAR(50) NOT NULL
);

CREATE TABLE roles (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE permissions (
  permission_id INT AUTO_INCREMENT PRIMARY KEY,
  permission_name VARCHAR(80) UNIQUE NOT NULL
);

CREATE TABLE role_permissions (
  role_id INT NOT NULL,
  permission_id INT NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
);

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(120) NOT NULL,
  username VARCHAR(80) UNIQUE NOT NULL,
  role_id INT NOT NULL,
  organization_id INT NOT NULL,
  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  FOREIGN KEY (organization_id) REFERENCES organizations(organization_id)
);

CREATE TABLE cloud_accounts (
  account_id INT AUTO_INCREMENT PRIMARY KEY,
  provider VARCHAR(50) NOT NULL,
  account_name VARCHAR(120) NOT NULL,
  organization_id INT NOT NULL,
  FOREIGN KEY (organization_id) REFERENCES organizations(organization_id)
);

CREATE TABLE billing (
  billing_id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT NOT NULL,
  month CHAR(7) NOT NULL,
  total_cost DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (account_id) REFERENCES cloud_accounts(account_id)
);

CREATE TABLE budgets (
  budget_id INT AUTO_INCREMENT PRIMARY KEY,
  billing_id INT NOT NULL,
  monthly_limit DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (billing_id) REFERENCES billing(billing_id)
);

CREATE TABLE resources (
  resource_id INT AUTO_INCREMENT PRIMARY KEY,
  resource_name VARCHAR(120) NOT NULL,
  resource_type VARCHAR(50) NOT NULL,
  project_id VARCHAR(50) NOT NULL,
  organization_id INT NOT NULL,
  account_id INT NOT NULL,
  FOREIGN KEY (organization_id) REFERENCES organizations(organization_id),
  FOREIGN KEY (account_id) REFERENCES cloud_accounts(account_id)
);

CREATE TABLE role_resource_mapping (
  role_id INT NOT NULL,
  resource_id INT NOT NULL,
  PRIMARY KEY (role_id, resource_id),
  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);

CREATE TABLE metrics (
  metric_id INT AUTO_INCREMENT PRIMARY KEY,
  resource_id INT NOT NULL,
  cpu_usage FLOAT NOT NULL,
  memory_usage FLOAT NOT NULL,
  network_in FLOAT NOT NULL,
  network_out FLOAT NOT NULL,
  collected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);

CREATE TABLE resource_tags (
  tag_id INT AUTO_INCREMENT PRIMARY KEY,
  resource_id INT NOT NULL,
  tag_key VARCHAR(50) NOT NULL,
  tag_value VARCHAR(120) NOT NULL,
  FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);

CREATE TABLE alert_rules (
  rule_id INT AUTO_INCREMENT PRIMARY KEY,
  resource_id INT NOT NULL,
  rule_name VARCHAR(120) NOT NULL,
  threshold_type VARCHAR(50) NOT NULL,
  threshold_value FLOAT NOT NULL,
  FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);

CREATE TABLE alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  role_id INT NOT NULL,
  tag_id INT,
  rule_id INT NOT NULL,
  severity VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  message VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  FOREIGN KEY (tag_id) REFERENCES resource_tags(tag_id),
  FOREIGN KEY (rule_id) REFERENCES alert_rules(rule_id)
);

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  role_id INT NOT NULL,
  resource_id INT NOT NULL,
  channel VARCHAR(30) NOT NULL,
  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);

CREATE TABLE performance_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  resource_id INT NOT NULL,
  alert_id INT,
  notes VARCHAR(255) NOT NULL,
  recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES resources(resource_id),
  FOREIGN KEY (alert_id) REFERENCES alerts(alert_id)
);
