# Set API Key
$API_KEY = "AIzaSyA6TZQvdBgf2TJKbDAdCV71ENt0T3hHA54"

# Define API Endpoint (Correct URL)
$URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateText?key=$API_KEY"

# Example problem statement
$problem = "What is the capital of France?"

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
Write-Output $response
