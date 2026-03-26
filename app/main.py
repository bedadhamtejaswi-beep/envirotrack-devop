from fastapi import FastAPI

app = FastAPI(title="EnviroTrack API", version="1.0.0")

OBLIGATIONS = [
    {
        "site_id": "TX-REM-001",
        "program": "Groundwater Remediation",
        "owner": "Operations",
        "status": "active",
        "risk_score": 82,
    },
    {
        "site_id": "LA-REM-014",
        "program": "Air Quality Monitoring",
        "owner": "Compliance",
        "status": "under_review",
        "risk_score": 61,
    },
    {
        "site_id": "OK-REM-031",
        "program": "Waste Handling Controls",
        "owner": "Field Services",
        "status": "active",
        "risk_score": 74,
    },
]


@app.get("/health")
def health_check():
    return {"status": "ok", "service": "envirotrack-api"}


@app.get("/metrics")
def metrics():
    active_count = sum(1 for item in OBLIGATIONS if item["status"] == "active")
    average_risk = sum(item["risk_score"] for item in OBLIGATIONS) / len(OBLIGATIONS)
    return {
        "tracked_sites": len(OBLIGATIONS),
        "active_obligations": active_count,
        "average_risk_score": round(average_risk, 2),
    }


@app.get("/obligations")
def list_obligations():
    return {"items": OBLIGATIONS}
