@echo off
cls
echo Setting Environment
echo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
echo Building for DOS Microstation v5.0
call basepath
echo Setting DOS UStation 5.0 environment
set MS=%md50path%
set MS_EXE=%md50path%\mdl
set MS_MDL=%md50path%\mdl
set BMAKE_OPT=-I$(MS)\mdl\include
rem path %path%;%md50path%\mdl\bin
echo 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
echo Building MDL application
bmakewin %1 -dobj=obj\ place.mke



