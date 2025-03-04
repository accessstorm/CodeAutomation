# Set API Key (Replace with your actual API key)
$API_KEY = "AIzaSyA6TZQvdBgf2TJKbDAdCV71ENt0T3hHA54"

# Ask user to provide a file
$problemFile = Read-Host "Enter the path to your problem.txt file (press Enter to use default)"

# If user does not provide a file, download a default problem.txt
if (-not $problemFile) {
    Write-Output "No file provided. Downloading default problem.txt..."
    $problemFile = "problem.txt"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourrepo/problem.txt" -OutFile $problemFile
}

# Check if the file exists
if (-Not (Test-Path $problemFile)) {
    Write-Output "Error: The file does not exist. Please provide a valid file."
    exit
}

# Read problem from the file
$problem = Get-Content -Path $problemFile -Raw

# API URL
$URL = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateText?key=$API_KEY"

# Create JSON Payload
$body = @{
    prompt = @{
        text = $problem
    }
} | ConvertTo-Json -Depth 10

# Send request to Gemini API
$response = Invoke-RestMethod -Uri $URL -Method Post -Body $body -ContentType "application/json"

# Display AI response
Write-Output "`nAI Response:"
Write-Output $response.candidates[0].content
