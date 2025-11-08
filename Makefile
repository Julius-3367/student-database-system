# Makefile - simple migration helper
MYSQL_USER ?= root
MYSQL_HOST ?= localhost
MYSQL_PORT ?=3306

.PHONY: migrate seed all

migrate:
	@echo "Running migrations..."
	@for f in migrations/*.sql; do \
		echo "-> $$f"; \
		mysql -u $(MYSQL_USER) -h $(MYSQL_HOST) -P $(MYSQL_PORT) -p < $$f; \
	done

seed:
	@echo "Seeding database..."
	@mysql -u $(MYSQL_USER) -h $(MYSQL_HOST) -P $(MYSQL_PORT) -p < student_records_seed.sql

all: migrate seed
	@echo "Migrations and seed complete."