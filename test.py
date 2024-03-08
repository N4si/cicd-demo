import pytest
from app import app
from urllib.parse import quote

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_app_is_working(client):
    response = client.get('/')
    assert response.status_code == 200
    expected_output = quote("Hello CI CD World!")
    assert expected_output.encode('utf-8') in response.data
