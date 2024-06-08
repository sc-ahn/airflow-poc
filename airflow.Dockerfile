FROM apache/airflow:2.9.1-python3.11
# NOTE: dags editor 사용을 위한 패키지 설치
RUN pip install airflow-code-editor