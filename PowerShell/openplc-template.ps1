# Step 1: Create first user
$createUserBody = @{
    username = "admin"
    password = "admin123"
    role     = "admin"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://localhost:8443/api/create-user" `
    -Method Post `
    -ContentType "application/json" `
    -Body $createUserBody `
    -SkipCertificateCheck

# Step 2: Login and get JWT token
$loginBody = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "https://localhost:8443/api/login" `
    -Method Post `
    -ContentType "application/json" `
    -Body $loginBody `
    -SkipCertificateCheck

# PowerShell automatically parses JSON responses, so we can grab the property directly
$TOKEN = $response.access_token
Write-Host "Token: $TOKEN"

# Step 3: Use token for authenticated requests
$headers = @{
    Authorization = "Bearer $TOKEN"
}

# Get PLC status
Invoke-RestMethod -Uri "https://localhost:8443/api/status" `
    -Method Get `
    -Headers $headers `
    -SkipCertificateCheck

# Start PLC
Invoke-RestMethod -Uri "https://localhost:8443/api/start-plc" `
    -Method Get `
    -Headers $headers `
    -SkipCertificateCheck

# Stop PLC
Invoke-RestMethod -Uri "https://localhost:8443/api/stop-plc" `
    -Method Get `
    -Headers $headers `
    -SkipCertificateCheck

# Upload program (Multipart Form Data)
# Note: Form parameters in Invoke-RestMethod require PowerShell 6.0+
$form = @{
    file = Get-Item ".\program.zip"
}
Invoke-RestMethod -Uri "https://localhost:8443/api/upload-file" `
    -Method Post `
    -Headers $headers `
    -Form $form `
    -SkipCertificateCheck

# Get compilation status
Invoke-RestMethod -Uri "https://localhost:8443/api/compilation-status" `
    -Method Get `
    -Headers $headers `
    -SkipCertificateCheck

# Get runtime logs
Invoke-RestMethod -Uri "https://localhost:8443/api/runtime-logs" `
    -Method Get `
    -Headers $headers `
    -SkipCertificateCheck

# Ping runtime
Invoke-RestMethod -Uri "https://localhost:8443/api/ping" `
    -Method Get `
    -Headers $headers `
    -SkipCertificateCheck
