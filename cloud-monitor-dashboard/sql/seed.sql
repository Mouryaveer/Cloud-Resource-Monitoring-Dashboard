USE cloud_monitor;

INSERT INTO organizations (name, subscription_plan) VALUES ('Acme Cloud Ops', 'Pro');

INSERT INTO roles (role_name) VALUES ('Admin'), ('DevOps'), ('Viewer');
INSERT INTO permissions (permission_name) VALUES ('view_dashboard'), ('manage_alerts'), ('manage_billing');
INSERT INTO role_permissions (role_id, permission_id) VALUES (1,1), (1,2), (1,3), (2,1), (2,2), (3,1);

INSERT INTO users (user_name, username, role_id, organization_id)
VALUES ('Mourya', 'mourya', 1, 1), ('Ops User', 'ops', 2, 1);

INSERT INTO cloud_accounts (provider, account_name, organization_id)
VALUES ('AWS', 'acme-prod', 1), ('Azure', 'acme-dr', 1);

INSERT INTO billing (account_id, month, total_cost) VALUES (1, '2026-02', 1299.00), (2, '2026-02', 499.00);
INSERT INTO budgets (billing_id, monthly_limit) VALUES (1, 1500.00), (2, 700.00);

INSERT INTO resources (resource_name, resource_type, project_id, organization_id, account_id)
VALUES
('web-vm-01', 'VM', 'proj-web', 1, 1),
('db-rds-01', 'Database', 'proj-core', 1, 1),
('cache-redis-01', 'Cache', 'proj-core', 1, 2);

INSERT INTO role_resource_mapping (role_id, resource_id) VALUES (1,1), (1,2), (1,3), (2,1), (2,2), (3,1);

INSERT INTO metrics (resource_id, cpu_usage, memory_usage, network_in, network_out, collected_at) VALUES
(1, 42.5, 61.2, 120.1, 98.2, NOW() - INTERVAL 9 MINUTE),
(1, 45.8, 63.0, 130.4, 105.9, NOW() - INTERVAL 7 MINUTE),
(2, 66.1, 74.5, 80.2, 65.4, NOW() - INTERVAL 5 MINUTE),
(2, 71.4, 79.2, 90.5, 70.3, NOW() - INTERVAL 3 MINUTE),
(3, 38.6, 57.8, 40.0, 35.5, NOW() - INTERVAL 1 MINUTE);

INSERT INTO resource_tags (resource_id, tag_key, tag_value)
VALUES (1, 'env', 'prod'), (2, 'tier', 'critical'), (3, 'env', 'staging');

INSERT INTO alert_rules (resource_id, rule_name, threshold_type, threshold_value)
VALUES
(1, 'High CPU', 'cpu_usage', 80),
(2, 'High Memory', 'memory_usage', 75),
(3, 'High Network In', 'network_in', 100);

INSERT INTO alerts (role_id, tag_id, rule_id, severity, status, message)
VALUES
(1, 2, 2, 'HIGH', 'OPEN', 'db-rds-01 memory usage crossed 75%'),
(2, 1, 1, 'MEDIUM', 'ACK', 'web-vm-01 CPU spike observed');

INSERT INTO notifications (role_id, resource_id, channel)
VALUES (1,2,'email'), (2,1,'slack');

INSERT INTO performance_logs (resource_id, alert_id, notes)
VALUES (2,1,'Database memory pressure during report generation');
