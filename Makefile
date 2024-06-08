DC=docker-compose -f airflow-docker-compose.yaml
MAKEFLAGS += --silent
path := .

.PHONY: prepare ps build up down restart logs shell rib todo lint clean help

help: ## 지금 보고계신 도움말
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	echo "make build && make up 실행후"
	echo "localhost:8080에 접속하세요"
	echo "ID: airflow"
	echo "PW: airflow"

prepare: ## 초기화단계에 필요한 작업
	mkdir -p logs dags plugins
	$(DC) run -d postgres
	$(DC) run -d redis
	$(DC) run -d airflow-webserver
	$(DC) run -d airflow-scheduler
	$(DC) run -d airflow-worker
	$(DC) run -d airflow-triggerer
	$(DC) run -d airflow-cli
	$(DC) run -d flower

build:
	$(DC) build

down: ## 컨테이너 종료
	$(DC) down

up: prepare ## 컨테이너 실행
	$(DC) up -d

init-airflow-db: ## Airflow DB 초기화
	$(DC) up airflow-init

info: ## Airflow 정보
	./airflow airflow info

get-pools: ## Airflow Pools 정보
	curl -X GET --user "airflow:airflow" "http://localhost:8080/api/v1/pools"
