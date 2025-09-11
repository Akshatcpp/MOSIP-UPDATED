# Start Development Servers
Write-Host "🚀 Starting OCR Document Processor Development Environment" -ForegroundColor Green
Write-Host ""

# Function to start backend
function Start-Backend {
    Write-Host "📡 Starting Backend Server (Port 3001)..." -ForegroundColor Blue
    Start-Process pwsh -ArgumentList "-NoExit", "-Command", "cd backend; npm run dev" -WindowStyle Normal
}

# Function to start frontend  
function Start-Frontend {
    Write-Host "🌐 Starting Frontend Server (Port 8080)..." -ForegroundColor Cyan
    Start-Process pwsh -ArgumentList "-NoExit", "-Command", "npm run dev" -WindowStyle Normal
}

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js is not installed. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Check if backend dependencies are installed
if (Test-Path "backend/node_modules") {
    Write-Host "✅ Backend dependencies found" -ForegroundColor Green
} else {
    Write-Host "📦 Installing backend dependencies..." -ForegroundColor Yellow
    cd backend
    npm install
    cd ..
}

# Check if frontend dependencies are installed
if (Test-Path "node_modules") {
    Write-Host "✅ Frontend dependencies found" -ForegroundColor Green
} else {
    Write-Host "📦 Installing frontend dependencies..." -ForegroundColor Yellow
    npm install
}

Write-Host ""
Write-Host "🏃‍♂️ Starting servers..." -ForegroundColor Yellow

# Start backend first
Start-Backend
Start-Sleep -Seconds 3

# Start frontend
Start-Frontend

Write-Host ""
Write-Host "🎉 Development environment started!" -ForegroundColor Green
Write-Host "📱 Frontend: http://localhost:8080" -ForegroundColor Cyan
Write-Host "🔧 Backend API: http://localhost:3001/api" -ForegroundColor Blue
Write-Host "❤️  Health Check: http://localhost:3001/api/health" -ForegroundColor Magenta
Write-Host ""
Write-Host "Press any key to stop all servers..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Cleanup - stop all node processes
Write-Host "🛑 Stopping servers..." -ForegroundColor Red
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "✅ All servers stopped" -ForegroundColor Green
