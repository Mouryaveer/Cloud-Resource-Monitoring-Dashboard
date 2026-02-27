from datetime import datetime
from . import db

role_permissions = db.Table(
    'role_permissions',
    db.Column('role_id', db.Integer, db.ForeignKey('roles.role_id'), primary_key=True),
    db.Column('permission_id', db.Integer, db.ForeignKey('permissions.permission_id'), primary_key=True),
)

role_resource_mapping = db.Table(
    'role_resource_mapping',
    db.Column('role_id', db.Integer, db.ForeignKey('roles.role_id'), primary_key=True),
    db.Column('resource_id', db.Integer, db.ForeignKey('resources.resource_id'), primary_key=True),
)

class Organization(db.Model):
    __tablename__ = 'organizations'
    organization_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    subscription_plan = db.Column(db.String(50), nullable=False)

class Role(db.Model):
    __tablename__ = 'roles'
    role_id = db.Column(db.Integer, primary_key=True)
    role_name = db.Column(db.String(50), unique=True, nullable=False)

class Permission(db.Model):
    __tablename__ = 'permissions'
    permission_id = db.Column(db.Integer, primary_key=True)
    permission_name = db.Column(db.String(80), unique=True, nullable=False)

class User(db.Model):
    __tablename__ = 'users'
    user_id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(120), nullable=False)
    username = db.Column(db.String(80), unique=True, nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.role_id'), nullable=False)
    organization_id = db.Column(db.Integer, db.ForeignKey('organizations.organization_id'), nullable=False)

class CloudAccount(db.Model):
    __tablename__ = 'cloud_accounts'
    account_id = db.Column(db.Integer, primary_key=True)
    provider = db.Column(db.String(50), nullable=False)
    account_name = db.Column(db.String(120), nullable=False)
    organization_id = db.Column(db.Integer, db.ForeignKey('organizations.organization_id'), nullable=False)

class Billing(db.Model):
    __tablename__ = 'billing'
    billing_id = db.Column(db.Integer, primary_key=True)
    account_id = db.Column(db.Integer, db.ForeignKey('cloud_accounts.account_id'), nullable=False)
    month = db.Column(db.String(7), nullable=False)
    total_cost = db.Column(db.Numeric(12, 2), nullable=False)

class Budget(db.Model):
    __tablename__ = 'budgets'
    budget_id = db.Column(db.Integer, primary_key=True)
    billing_id = db.Column(db.Integer, db.ForeignKey('billing.billing_id'), nullable=False)
    monthly_limit = db.Column(db.Numeric(12, 2), nullable=False)

class Resource(db.Model):
    __tablename__ = 'resources'
    resource_id = db.Column(db.Integer, primary_key=True)
    resource_name = db.Column(db.String(120), nullable=False)
    resource_type = db.Column(db.String(50), nullable=False)
    project_id = db.Column(db.String(50), nullable=False)
    organization_id = db.Column(db.Integer, db.ForeignKey('organizations.organization_id'), nullable=False)
    account_id = db.Column(db.Integer, db.ForeignKey('cloud_accounts.account_id'), nullable=False)

class Metric(db.Model):
    __tablename__ = 'metrics'
    metric_id = db.Column(db.Integer, primary_key=True)
    resource_id = db.Column(db.Integer, db.ForeignKey('resources.resource_id'), nullable=False)
    cpu_usage = db.Column(db.Float, nullable=False)
    memory_usage = db.Column(db.Float, nullable=False)
    network_in = db.Column(db.Float, nullable=False)
    network_out = db.Column(db.Float, nullable=False)
    collected_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

class ResourceTag(db.Model):
    __tablename__ = 'resource_tags'
    tag_id = db.Column(db.Integer, primary_key=True)
    resource_id = db.Column(db.Integer, db.ForeignKey('resources.resource_id'), nullable=False)
    tag_key = db.Column(db.String(50), nullable=False)
    tag_value = db.Column(db.String(120), nullable=False)

class AlertRule(db.Model):
    __tablename__ = 'alert_rules'
    rule_id = db.Column(db.Integer, primary_key=True)
    resource_id = db.Column(db.Integer, db.ForeignKey('resources.resource_id'), nullable=False)
    rule_name = db.Column(db.String(120), nullable=False)
    threshold_type = db.Column(db.String(50), nullable=False)
    threshold_value = db.Column(db.Float, nullable=False)

class Alert(db.Model):
    __tablename__ = 'alerts'
    alert_id = db.Column(db.Integer, primary_key=True)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.role_id'), nullable=False)
    tag_id = db.Column(db.Integer, db.ForeignKey('resource_tags.tag_id'))
    rule_id = db.Column(db.Integer, db.ForeignKey('alert_rules.rule_id'), nullable=False)
    severity = db.Column(db.String(20), nullable=False)
    status = db.Column(db.String(20), nullable=False, default='OPEN')
    message = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class Notification(db.Model):
    __tablename__ = 'notifications'
    notification_id = db.Column(db.Integer, primary_key=True)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.role_id'), nullable=False)
    resource_id = db.Column(db.Integer, db.ForeignKey('resources.resource_id'), nullable=False)
    channel = db.Column(db.String(30), nullable=False)
    sent_at = db.Column(db.DateTime, default=datetime.utcnow)

class PerformanceLog(db.Model):
    __tablename__ = 'performance_logs'
    log_id = db.Column(db.Integer, primary_key=True)
    resource_id = db.Column(db.Integer, db.ForeignKey('resources.resource_id'), nullable=False)
    alert_id = db.Column(db.Integer, db.ForeignKey('alerts.alert_id'))
    notes = db.Column(db.String(255), nullable=False)
    recorded_at = db.Column(db.DateTime, default=datetime.utcnow)
