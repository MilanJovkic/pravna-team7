@echo off
REM start_servers.bat - starts backend and frontend in separate terminals
REM Usage: double-click or run from project root

cd /d "%~dp0"
set "ROOT=%~dp0"

set DB_HOST=127.0.0.1
set DB_PORT=5433
set DB_NAME=pravna_cbr
set DB_USER=pravna_user
set DB_PASSWORD=pravna_pass

set POSTGRES_HOST=%DB_HOST%
set POSTGRES_PORT=%DB_PORT%
set POSTGRES_DB=%DB_NAME%
set POSTGRES_USER=%DB_USER%
set POSTGRES_PASSWORD=%DB_PASSWORD%

echo Starting PostgreSQL with Docker Compose...
docker compose up -d

echo Waiting for database...
timeout /t 5 >nul

echo Importing cases into database...
call .venv\Scripts\activate.bat
python import_facts_to_db.py

echo Starting Backend in new window...
start "Backend" /D "%ROOT%" cmd /k ".venv\Scripts\activate.bat && uvicorn backend.app.main:app --reload --host 127.0.0.1 --port 8000"

timeout /t 1 >nul

echo Starting Frontend in new window...
start "Frontend" /D "%ROOT%frontend" cmd /k "npm start"

echo Both commands launched. This window can be closed.
exit /b 0
