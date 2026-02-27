# Cloud Resource Monitoring Dashboard

Python + MySQL web application for centralized cloud resource monitoring.

## Features
- Dashboard cards: total resources, total alerts, open alerts, monthly cost
- CPU/Memory usage chart
- Recent alerts table
- Relational MySQL schema matching your project entities
- Seed data for demo/testing

## Tech Stack
- Python (Flask)
- MySQL
- SQLAlchemy ORM
- Chart.js (frontend chart)

## Project Structure
```
cloud-monitor-dashboard/
├── app/
│   ├── __init__.py
│   ├── models.py
│   └── routes.py
├── sql/
│   ├── schema.sql
│   └── seed.sql
├── static/css/style.css
├── templates/dashboard.html
├── .env.example
├── requirements.txt
└── run.py
```

## Setup
1. Create database/tables:
```bash
mysql -u root -p < sql/schema.sql
mysql -u root -p < sql/seed.sql
```

2. Create virtual environment and install deps:
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

3. Configure environment:
```bash
cp .env.example .env
# edit DATABASE_URL in .env
```

4. Run app:
```bash
python run.py
```
Open: `http://127.0.0.1:5000`

## Notes on Scope
This implementation focuses on **data management + dashboard visualization**. It does **not** include direct cloud API integrations or real-time collectors, aligned with your project scope statement.

## Future Enhancements
- Cloud API connectors (AWS/Azure/GCP)
- Scheduled metric collectors (Celery/cron)
- RBAC login + JWT/session auth
- Advanced reporting exports (PDF/CSV)
- Alert delivery (email/telegram/webhooks)
