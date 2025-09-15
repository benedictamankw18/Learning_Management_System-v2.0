@echo off
echo Updating Learning Management System files...

echo Making backups of original files...
copy "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx" "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx.bak"
copy "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx.cs" "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx.cs.bak"

echo Replacing files with fixed versions...
move /y "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx.new" "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx"
move /y "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx.cs.new" "e:\Learning Management System\Learning Management System\authUser\Admin\Course.aspx.cs"

echo Files updated successfully!
pause
