$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$scriptPath = Join-Path $PSScriptRoot "rails"
& (Get-Command ruby).Source $scriptPath server @args
