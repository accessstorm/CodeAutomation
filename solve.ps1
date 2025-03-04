<#
.SYNOPSIS
Solves problems using the Google Gemini AI API from PowerShell.

.DESCRIPTION
This script takes a problem description from a file (either user-provided or a default one from the internet),
sends it to the Google Gemini AI API, and displays the AI-generated solution.

.EXAMPLE
Run from PowerShell:
irm "https://raw.githubusercontent.com/yourrepo/solve.ps1" | iex

It will prompt you for a problem.txt file path or use the default online problem.txt.
#>

# **IMPORTANT: Replace with your actual Gemini API key!**
$GeminiApiKey = "AIzaSyA6TZQvdBgf2TJKbDAdCV71ENt0T3hHA54"
# Gemini API Endpoint (replace if needed, this is a placeholder example)
$GeminiApiEndpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$GeminiApiKey"
# Default problem.txt URL (replace with your desired default problem.txt location)
$DefaultProblemUrl = "https://raw.githubusercontent.com/yourrepo/default_problem.txt"

# Prompt user for file path
$filePath = Read-Host "Enter the path to your problem.txt file (press Enter to use default)"

if (-not $filePath) {
    # Use default problem if Enter is pressed
    Write-Output "Using default problem from: $DefaultProblemUrl"
    try {
        $problemText = Invoke-WebRequest -Uri $DefaultProblemUrl -UseBasicParsing | Select-Object -ExpandProperty Content
    }
    catch {
        Write-Error "Error downloading default problem.txt: $_"
        return # Exit script if default download fails
    }
} else {
    # Use user-provided file
    if (!(Test-Path -Path $filePath -PathType Leaf)) {
        Write-Error "Error: File not found at path: $filePath"
        return # Exit script if file not found
    }
    try {
        $problemText = Get-Content -Path $filePath -Raw
    }
    catch {
        Write-Error "Error reading file '$filePath': $_"
        return # Exit script if file reading fails
    }
}

Write-Output "Problem Text:"
Write-Output "--------------------"
Write-Output $problemText
Write-Output "--------------------"

# Prepare request body for Gemini API (adjust based on actual Gemini API requirements)
$requestBody = @{
    contents = @(
        @{
            parts = @(
                @{
                    text = $problemText
                }
            )
        }
    )
} | ConvertTo-Json

# Headers for the Gemini API request (content type and API key are crucial)
$headers = @{
    "Content-Type" = "application/json"
}

try {
    Write-Output "Sending problem to Gemini..."
    $response = Invoke-RestMethod -Uri $GeminiApiEndpoint -Method Post -Body $requestBody -Headers $headers
    Write-Output "nAI Response:"
    if ($response.candidates -and $response.candidates.Count -gt 0 -and $response.candidates[0].content) {
        Write-Output $response.candidates[0].content.parts[0].text # Adjust path based on actual API response structure
    } else {
        Write-Warning "No valid solution found in Gemini response."
        Write-Output "Full Gemini Response (for debugging):"
        $response | ConvertTo-Json -Depth 5 # Output full response if no solution found
    }
}
catch {
    Write-Error "Error communicating with Gemini API: $_"
    if ($_.Exception.Response -and $_.Exception.Response.Content) {
        Write-Error "API Error Details: $($_.Exception.Response.Content)" # Show API error response if available
    }
}