# Uputstvo za pokretanje

## Backend (FastAPI)

1. **Navigacija do backend foldera:**
```bash
cd backend
```

2. **Instalacija dependencies:**
```bash
pip install -r requirements.txt
```

3. **Pokretanje servera:**
```bash
uvicorn app.main:app --reload
```

Backend će biti dostupan na: **http://localhost:8000**
API dokumentacija: **http://localhost:8000/docs**

## Frontend (Angular)

1. **Navigacija do frontend foldera:**
```bash
cd frontend
```

2. **Instalacija Node.js dependencies:**
```bash
npm install
```

3. **Pokretanje Angular dev servera:**
```bash
npm start
# ili
ng serve
```

Frontend će biti dostupan na: **http://localhost:4200**

## Pristup aplikaciji

Nakon pokretanja oba servera:
1. Otvori browser na **http://localhost:4200**
2. Navigacija:
   - **Zakoni** - pregled glava i članaka Krivičnog zakonika
   - **Presude** - pregled sudskih presuda sa detaljima

## API Endpoints

### Zakoni
- `GET /api/laws/chapters` - lista glava
- `GET /api/laws/chapters/{number}` - detalji glave
- `GET /api/laws/articles/{number}` - pojedinačni član
- `GET /api/laws/search?q=...` - pretraga

### Presude
- `GET /api/verdicts` - lista presuda
- `GET /api/verdicts/{case_id}` - detalji presude
- `GET /api/verdicts/search/?q=...` - pretraga

## Troubleshooting

### Backend ne radi
- Proveri da li si u `backend/` folderu
- Proveri da li su dependencies instalirani: `pip list | grep fastapi`
- Proveri da li port 8000 nije zauzet

### Frontend ne radi
- Proveri da li si u `frontend/` folderu
- Proveri da li je Node.js instaliran: `node --version`
- Instaliraj Angular CLI globalno: `npm install -g @angular/cli`
- Obriši `node_modules` i instaliraj ponovo: `rm -rf node_modules && npm install`

### CORS greške
- Proveri da li backend radi na portu 8000
- CORS je konfigurisan za `http://localhost:4200` u `backend/app/main.py`
