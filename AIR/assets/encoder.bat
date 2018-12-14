:: https://ffmpeg.org/ffmpeg.html
:: ffmpeg [global_options] {[input_file_options] -i ‘input_file’} ... {[output_file_options] ‘output_file’} ... 

@echo off
set PAUSE_ERRORS=1
set FFMPEG_PATH=D:\ffmpeg\bin

GOTO EndComment1





:menu
echo ***************************************************************
echo What do you want to do?
echo.
echo  [1] check ffmpeg version
echo  [2] convert to h.264
echo.

:choice
echo ***************************************************************
set /P C=[Choice]: 
echo.

if %C%==1 goto check_ffmpeg_version
if %C%==2 goto convertOptions


:check_ffmpeg_version
cls
"%FFMPEG_PATH%"\ffmpeg.exe -version
goto menu




:EndComment1



:convertOptions
cls
echo input video file name
SET /P input_file=input file name: 

cls
echo output video file name
SET /P output_file=output file name: 

set input_width=1920
set input_height=1080
set input_crf=25
set SPEED=slow

goto convert

:convert
cls
:: https://www.virag.si/2012/01/web-video-encoding-tutorial-with-ffmpeg-0-9/
:: -i [input file] - this specifies the name of input file
:: -codec:v libx264 - tells FFmpeg to encode video to H.264 using libx264 library
:: -profile:v high - sets H.264 profile to “High” as per Step 2. Other valid options are baseline, main
:: -preset slow - sets encoding preset for x264 – slower presets give more quality at same bitrate, but need more time ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo (never use this one)
:: -b:v - sets video bitrate in bits/s
:: -maxrate and -bufsize - forces libx264 to build video in a way, that it could be streamed over 500kbit/s line considering device buffer of 1000kbits
:: -vf scale - applies “scale” filter, which resizes video to desired resolution. “720:480” would resize video to 720x480, “-1” means “resize so the aspect ratio for 380p you set “scale=-1:380”, for 720p “scale=-1:720” etc
:: -vf >> read https://trac.ffmpeg.org/wiki/FilteringGuide
:: -threads 0 - tells libx264 to choose optimal number of threads to encode, which will make sure all your processor cores in the computer are used
:: -codec:a libfdk_aac - tells FFmpeg to encode audio to AAC using libfdk-aac library
:: -b:a - sets audio bitrate in bits/s
:: -an - disables audio, audio processing has no effect on first pass so it’s best to disable it to not waste CPU
:: -crf http://slhck.info/articles/crf - between 0 and 51, where lower values would result in better quality
::"%FFMPEG_PATH%\ffmpeg.exe" -i %input_file% -codec:v libx264 -profile:v main -preset %SPEED% -b:v 500k -maxrate 500k -bufsize 1000k -vf scale=%input_width%:%input_height% -threads 0 -crf 25 -codec:a mp3 -ar 44100 -b:a 64k -ac 2 -y -f m4v %output_file%
  "%FFMPEG_PATH%\ffmpeg.exe" -i %input_file% -codec:v libx264 -profile:v high -preset %SPEED% -b:v 1000k -maxrate 1000k -bufsize 1000k -vf scale=%input_width%:%input_height% -threads 0 -crf %input_crf% %output_file%
::"%FFMPEG_PATH%\ffmpeg.exe" -i %input_file% -codec:v libx264 -profile:v main -preset %SPEED% -b:v 500k -maxrate 500k -bufsize 200k -vf "rotate=PI:bilinear=0, scale=%input_width%:%input_height%" -threads 0 -crf %input_crf% %output_file%
::"%FFMPEG_PATH%\ffmpeg.exe" -i %input_file% -codec:v libx264 -profile:v main -preset %SPEED% -b:v 500k -maxrate 500k -bufsize 200k -vf "transpose=1, scale=%input_width%:%input_height%" -threads 0 -crf %input_crf% %output_file%
pause

:exit
exit