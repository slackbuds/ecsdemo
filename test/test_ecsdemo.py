import json
import os
import requests

HOST = os.environ["HOST"]


def test_actuator_health():
    resp = requests.get(f"{HOST}/actuator/health")
    assert resp

    jresp = json.loads(resp.text)
    assert jresp["status"] == "UP"


def test_hello_world():
    resp = requests.get(f"{HOST}/api/v1/hello")
    assert resp

    assert resp.text == "Hello World!"


def test_hello_test():
    name = "testme"
    resp = requests.get(f"{HOST}/api/v1/hello?name={name}")
    assert resp

    assert resp.text == f"Hello {name}!"


def test_env_plain():
    resp = requests.get(f"{HOST}/api/v1/env")
    assert resp


def test_env_plain_home():
    resp = requests.get(f"{HOST}/api/v1/env?key=HOME")
    assert resp
    assert resp.text[:5] == "HOME="


def test_env_json():
    resp = requests.get(f"{HOST}/api/v1/env", headers={"accept": "application/json"})
    assert resp


def test_env_home_json():
    key = "HOME"
    resp = requests.get(
        f"{HOST}/api/v1/env?key={key}", headers={"accept": "application/json"}
    )
    assert resp

    jresp = json.loads(resp.text)
    assert jresp["HOME"]


def test_env_echo_json():
    resp = requests.post(
        f"{HOST}/api/v1/echo", headers={"foo": "bar"}, json={"foo": "bar"}
    )
    assert resp

    jresp = json.loads(resp.text)
    assert jresp["headers"]
    assert jresp["body"]


def test_env_echo_csv():
    resp = requests.post(f"{HOST}/api/v1/echo", headers={"foo": "bar"}, data="foo,bar")
    assert resp

    jresp = json.loads(resp.text)
    assert jresp["headers"]
    assert jresp["body"]


def test_tables():
    resp = requests.get(f"{HOST}/api/v1/tables")
    assert resp
