#!/usr/bin/env bash
# Claude Code status line — Starship-inspired minimal design

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# ── Git branch and repo-relative path ────────────────────────────────────────
git_branch=""
display_path=""
git_root=$(git --no-optional-locks -C "$cwd" rev-parse --show-toplevel 2>/dev/null)

if [ -n "$git_root" ]; then
  repo_name=$(basename "$git_root")
  rel="${cwd#$git_root}"
  display_path="${repo_name}${rel}"
  git_branch=$(git --no-optional-locks -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
    || git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)
else
  home="$HOME"
  tilde_cwd="${cwd/#$home/\~}"
  IFS='/' read -ra parts_arr <<< "$tilde_cwd"
  total=${#parts_arr[@]}
  if [ "$total" -le 3 ]; then
    display_path="$tilde_cwd"
  else
    display_path="${parts_arr[$((total-3))]}/${parts_arr[$((total-2))]}/${parts_arr[$((total-1))]}"
  fi
fi

# ── ANSI colors (bold for labels, normal for values) ─────────────────────────
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# Thin separator used between modules (Starship "❯" style)
SEP=" ${DIM}·${RESET} "

# ── Build output ──────────────────────────────────────────────────────────────
out=""

# Directory — cyan bold, matches Starship default
out="${out}$(printf "${BOLD}${CYAN}${display_path}${RESET}")"

# Git branch — " on  <branch>" in yellow, Starship git_branch style
if [ -n "$git_branch" ]; then
  out="${out}$(printf " ${DIM}on${RESET}  ${YELLOW}${git_branch}${RESET}")"
fi

# Model — dim "via" label + plain value
if [ -n "$model" ]; then
  out="${out}${SEP}$(printf "${DIM}via${RESET} ${model}")"
fi

# Context window — thin dot bar (● filled · empty), color-coded
if [ -n "$used_pct" ]; then
  used_int=${used_pct%.*}

  if [ "$used_int" -ge 90 ]; then
    bar_color="$RED"
  elif [ "$used_int" -ge 75 ]; then
    bar_color="$YELLOW"
  else
    bar_color="$GREEN"
  fi

  filled=$(( used_int * 10 / 100 ))
  empty=$(( 10 - filled ))

  bar=""
  for i in $(seq 1 $filled); do
    bar="${bar}●"
  done
  for i in $(seq 1 $empty); do
    bar="${bar}·"
  done

  out="${out}${SEP}$(printf "${bar_color}${bar}${RESET} ${DIM}${used_int}%%${RESET}")"
fi

printf "%b" "$out"
