@echo off
if -%1- == -- (
echo Comment is required
exit
)
git add -A
git commit -m %1
git push
git status
