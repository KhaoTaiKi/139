@echo off
chcp 65001 >nul
ruby -x "%~f0" %*
exit /b %ERRORLEVEL%

#!/usr/bin/env ruby
exec Gem.ruby, File.expand_path("rails", __dir__), "server", *ARGV
