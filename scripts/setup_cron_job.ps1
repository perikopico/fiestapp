# Script PowerShell para configurar el Cron Job en Supabase
# Requiere: PowerShell 5.1+ y tener configurado SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY

param(
    [string]$ServiceRoleKey = "",
    [string]$ProjectRef = "oudofaiekedtaovrdqeo"
)

Write-Host "🚀 Configurando Cron Job en Supabase..." -ForegroundColor Cyan
Write-Host ""

# Verificar si se proporcionó el Service Role Key
if ([string]::IsNullOrEmpty($ServiceRoleKey)) {
    Write-Host "⚠️  No se proporcionó Service Role Key" -ForegroundColor Yellow
    Write-Host "Opciones:" -ForegroundColor Yellow
    Write-Host "  1. Pásalo como parámetro: .\setup_cron_job.ps1 -ServiceRoleKey 'tu-key'" -ForegroundColor Gray
    Write-Host "  2. Configúralo como variable de entorno: `$env:SUPABASE_SERVICE_ROLE_KEY = 'tu-key'" -ForegroundColor Gray
    Write-Host ""
    
    # Intentar leer desde variable de entorno
    $ServiceRoleKey = $env:SUPABASE_SERVICE_ROLE_KEY
    
    if ([string]::IsNullOrEmpty($ServiceRoleKey)) {
        Write-Host "❌ No se encontró Service Role Key. Abortando." -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 Encuentra tu Service Role Key en:" -ForegroundColor Cyan
        Write-Host "   Supabase Dashboard → Settings → API → service_role key" -ForegroundColor Gray
        exit 1
    }
}

Write-Host "✅ Service Role Key encontrado" -ForegroundColor Green
Write-Host ""

# Leer el archivo SQL
$sqlFile = Join-Path $PSScriptRoot "..\docs\migrations\040_setup_cron_job_completo.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "❌ No se encontró el archivo SQL: $sqlFile" -ForegroundColor Red
    exit 1
}

$sqlContent = Get-Content $sqlFile -Raw

# Reemplazar el placeholder con el Service Role Key real
$sqlContent = $sqlContent -replace '\[TU-SERVICE-ROLE-KEY\]', $ServiceRoleKey

Write-Host "📋 SQL preparado. Instrucciones:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Ve a Supabase Dashboard → SQL Editor" -ForegroundColor Yellow
Write-Host "2. Copia y pega el siguiente SQL:" -ForegroundColor Yellow
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host $sqlContent -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Ejecuta el SQL" -ForegroundColor Yellow
Write-Host "4. Verifica que el cron job se creó correctamente" -ForegroundColor Yellow
Write-Host ""

# Opción alternativa: Guardar en un archivo temporal
$tempFile = Join-Path $env:TEMP "setup_cron_job_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql"
$sqlContent | Out-File -FilePath $tempFile -Encoding UTF8

Write-Host "💾 También se guardó en: $tempFile" -ForegroundColor Cyan
Write-Host "   Puedes abrirlo y copiarlo desde ahí" -ForegroundColor Gray
Write-Host ""

# Opción para ejecutar directamente (requiere conexión a Supabase)
Write-Host "❓ ¿Quieres intentar ejecutarlo directamente? (requiere conexión a Supabase)" -ForegroundColor Yellow
$response = Read-Host "Escribe 'si' para intentar, o Enter para saltar"

if ($response -eq 'si' -or $response -eq 'sí' -or $response -eq 'yes' -or $response -eq 'y') {
    Write-Host ""
    Write-Host "⚠️  Ejecución directa requiere configuración adicional." -ForegroundColor Yellow
    Write-Host "   Por ahora, usa el método manual (copiar y pegar en SQL Editor)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "💡 Para ejecutar directamente, necesitarías:" -ForegroundColor Cyan
    Write-Host "   - Instalar psql (PostgreSQL client)" -ForegroundColor Gray
    Write-Host "   - Configurar conexión a Supabase" -ForegroundColor Gray
    Write-Host "   - O usar la API REST de Supabase" -ForegroundColor Gray
}

Write-Host ""
Write-Host "✅ Script completado" -ForegroundColor Green
