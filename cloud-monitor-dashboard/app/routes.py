from flask import Blueprint, render_template
from sqlalchemy import func
from . import db
from .models import Resource, Metric, Alert, Billing

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def dashboard():
    total_resources = db.session.query(func.count(Resource.resource_id)).scalar() or 0
    total_alerts = db.session.query(func.count(Alert.alert_id)).scalar() or 0
    open_alerts = db.session.query(func.count(Alert.alert_id)).filter(Alert.status == 'OPEN').scalar() or 0
    monthly_cost = db.session.query(func.sum(Billing.total_cost)).scalar() or 0

    latest_metrics = (
        db.session.query(Metric)
        .order_by(Metric.collected_at.desc())
        .limit(10)
        .all()
    )

    cpu_values = [m.cpu_usage for m in reversed(latest_metrics)]
    mem_values = [m.memory_usage for m in reversed(latest_metrics)]
    labels = [m.collected_at.strftime('%H:%M') for m in reversed(latest_metrics)]

    recent_alerts = (
        db.session.query(Alert)
        .order_by(Alert.created_at.desc())
        .limit(8)
        .all()
    )

    return render_template(
        'dashboard.html',
        total_resources=total_resources,
        total_alerts=total_alerts,
        open_alerts=open_alerts,
        monthly_cost=float(monthly_cost),
        labels=labels,
        cpu_values=cpu_values,
        mem_values=mem_values,
        recent_alerts=recent_alerts,
    )
