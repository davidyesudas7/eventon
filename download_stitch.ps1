$inputFile = "C:\Users\aseer\.gemini\antigravity-ide\brain\a1821e3a-a6ea-4c2e-9696-5360da383202\.system_generated\steps\5\output.txt"
$outputDir = "C:\Users\aseer\Desktop\flutter projects\eventon\stitch_downloads"

if (-Not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$content = Get-Content -Path $inputFile -Raw
$regex = '{"screens":\[.*\]}'
if ($content -match $regex) {
    $jsonStr = $matches[0]
    $data = $jsonStr | ConvertFrom-Json
    
    foreach ($screen in $data.screens) {
        $title = $screen.title
        if (-not $title) { $title = "Untitled" }
        $safeTitle = $title -replace '[\\/*?:"<>|]', ''
        $safeTitle = $safeTitle -replace ' ', '_'
        
        Write-Host "Processing: $title"
        
        if ($null -ne $screen.screenshot -and $null -ne $screen.screenshot.downloadUrl) {
            $url = $screen.screenshot.downloadUrl
            $filepath = Join-Path $outputDir "$safeTitle.png"
            Write-Host "Downloading image: $filepath"
            Invoke-WebRequest -Uri $url -OutFile $filepath
        }
        
        if ($null -ne $screen.htmlCode -and $null -ne $screen.htmlCode.downloadUrl) {
            $url = $screen.htmlCode.downloadUrl
            $ext = ".html"
            if ($screen.htmlCode.mimeType -eq 'text/markdown') {
                $ext = ".md"
            }
            $filepath = Join-Path $outputDir "$safeTitle$ext"
            Write-Host "Downloading code: $filepath"
            Invoke-WebRequest -Uri $url -OutFile $filepath
        }
    }
} else {
    Write-Host "Could not find JSON in output file"
}
