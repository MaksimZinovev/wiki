#!/bin/sh
# Refresh the progress stat card in the plan before commit.
# Runs on any platform with sh + grep + awk + sed (Git Bash on Windows).
PLAN="plans/personal-wiki-setup-plan.md"

# Only touch the commit when the plan itself is staged (skip with --force for manual runs)
if [ "$1" != "--force" ]; then
  git diff --cached --name-only | grep -qx "$PLAN" || exit 0
fi
[ -f "$PLAN" ] || exit 0

done_n=$(grep -cE '^- \[x\]' "$PLAN" || true)
todo_raw=$(grep -cE '^- \[ \]' "$PLAN" || true)

# Superseded = pending [ ] items below a "- [x] ... below —" marker, until next ### heading
sup=$(awk '/^### /{s=0} /^- \[x\].*below/{s=1;next} s&&/^- \[ \]/{n++} END{print n+0}' "$PLAN")

total_raw=$((done_n + todo_raw))
todo=$((todo_raw - sup))
total=$((total_raw - sup))
pct=$(( total > 0 ? done_n * 100 / total : 0 ))

sed -i -E \
  -e "s|^(      \['Total tasks', ')[0-9]+(', ')[^']*(')|\1$total\2$total_raw raw - $sup superseded\3|" \
  -e "s|^(      \['Completed', ')[0-9]+(', ')[^']*(')|\1$done_n\2$pct% of plan\3|" \
  -e "s|^(      \['Remaining', ')[0-9]+(')|\1$todo\2|" \
  "$PLAN"

git add "$PLAN"
