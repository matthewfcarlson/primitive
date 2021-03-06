@cho off

@setlocal
set start=%time%
set input_video=test3.mp4
set fps=27
set polygons=300

mkdir video_pre
echo Removing old files
del -f video_pre\*.*

echo Getting frames
@ffmpeg\ffmpeg.exe -i %input_video% -r %fps% "video_pre\frame%%04d.png"
echo Got frames

mkdir video_post
del -rf video_post\*.*
main.exe -i "video_pre\frame%%04d.png" -o "video_post\post-frame%%04d.png" -n %polygons% -video
main.exe -i "video_pre\frame%%04d.png" -o "video_post\post-nv-frame_nv%%04d.png" -n %polygons% 

echo Done Processing
echo Recombining frames
@ffmpeg\ffmpeg -framerate %fps% -i video_post\post-frame%%04d.png -c:v libx264 -vf "fps=25,format=yuv420p" output.mp4
@ffmpeg\ffmpeg -framerate %fps% -i video_post\post-nv-frame%%04d.png -c:v libx264 -vf "fps=25,format=yuv420p" output_nv.mp4
-vf "fps=25,format=yuv420p"
echo Done

set end=%time%
set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours%
if 1%ms% lss 100 set ms=0%ms%

:: mission accomplished
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs% 
echo command took %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)