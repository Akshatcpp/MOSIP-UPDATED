# OCR Document Processor

A complete, competition-ready OCR application built for the MOSIP hackathon. This application uses TrOCR (Transformers-based OCR) for accurate text extraction from both printed and handwritten documents, with an intuitive web interface for document upload, text extraction, manual correction, and verification.

## Project Architecture

```
.
├── backend/                # Flask Python API
│   ├── app.py             # Main Flask application
│   └── requirements.txt   # Python dependencies
├── src/                    # React + Vite frontend
│   ├── components/
│   ├── lib/
│   ├── main.tsx
│   └── App.tsx
├── public/                 # Static assets
├── Dockerfile              # Multi-stage Docker build (frontend + backend)
├── .env.example            # Environment variables template
├── package.json            # Frontend dependencies and scripts
└── README.md               # This file
```

## Tech Stack

- Frontend: React, TypeScript, Vite, Tailwind CSS, Radix UI, React Query
- Backend: Python, Flask, Hugging Face Transformers (TrOCR), PyTorch, Pillow, pdf2image, python-Levenshtein

## Local Setup

Prerequisites:
- Node.js 18+
- Python 3.10+
- Poppler tools (for PDF to image conversion)
  - Ubuntu/Debian: `sudo apt-get install -y poppler-utils`
  - macOS: `brew install poppler`
  - Windows: Install Poppler for Windows and add its bin folder to PATH

1) Configure environment
- Copy .env.example to .env and adjust if needed

2) Backend
- python -m venv venv
- source venv/bin/activate  (Windows: venv\Scripts\activate)
- pip install -r backend/requirements.txt
- python backend/app.py

3) Frontend
- npm install
- npm run dev

Frontend: http://localhost:8080
Backend API: http://localhost:5000/api

## API Documentation

1) POST /api/extract
- Form: multipart/form-data
- Field: file (image or PDF)
- Response: { success, raw_text, extracted_data }

2) POST /api/verify
- Form: multipart/form-data
- Fields: file (image or PDF), form_data (JSON string)
- Response: { success, verification_results, overall_accuracy, ground_truth, raw_text }

## Docker Deployment

- docker build -t ocr-app .
- docker run -p 5000:5000 ocr-app

The container serves the Flask API at /api and the built React app as static files.

## Notes

- Models used: microsoft/trocr-base-handwritten and microsoft/trocr-base-printed.
- Verification uses Levenshtein distance for confidence scoring.
- The frontend supports manual correction of extracted data before verification.

