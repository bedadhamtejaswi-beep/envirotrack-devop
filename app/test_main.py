from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_metrics():
    response = client.get("/metrics")
    assert response.status_code == 200
    payload = response.json()
    assert payload["tracked_sites"] == 3
    assert "average_risk_score" in payload


def test_obligations():
    response = client.get("/obligations")
    assert response.status_code == 200
    payload = response.json()
    assert "items" in payload
    assert len(payload["items"]) == 3
