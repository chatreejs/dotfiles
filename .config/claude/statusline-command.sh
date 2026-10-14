#!/usr/bin/env bash
# Claude Code status line - Dracula theme
# Format: model sonnet 4.6 | ctx: 18k/272k [bar] 7% | tokens ↑40k ↓8.1k | 5h 1% [bar] resets 1m | 7d 20% [bar] resets 3d

input=$(cat)

# ── ANSI helpers ─────────────────────────────────────────────────────────────
reset="\033[0m"

# Dracula palette (24-bit true color)
# #bd93f9 Purple  – model label/name
purple="\033[38;2;189;147;249m"
# #8be9fd Cyan    – "ctx:" label, "resets" label
cyan="\033[38;2;139;233;253m"
# #f8f8f2 Foreground – general text / numbers
white="\033[38;2;248;248;242m"
# #50fa7b Green   – bar low, up-arrow (input tokens)
green="\033[38;2;80;250;123m"
# #f1fa8c Yellow  – bar mid, rate-limit / cost segment
yellow="\033[38;2;241;250;140m"
# #ff5555 Red     – bar high
red="\033[38;2;255;85;85m"
# #ff79c6 Pink    – "tokens" label
pink="\033[38;2;255;121;198m"
# #ffb86c Orange  – down-arrow (output tokens)
orange="\033[38;2;255;184;108m"
# #6272a4 Comment – separators
gray="\033[38;2;98;114;164m"

# ── Helper: format large numbers as e.g. 40k, 1.2m ──────────────────────────
fmt_num() {
  local n=$1
  if   [ "$n" -ge 1000000 ] 2>/dev/null; then printf "%.1fm" "$(echo "scale=1; $n/1000000" | bc)"
  elif [ "$n" -ge 1000    ] 2>/dev/null; then printf "%.0fk"  "$(echo "scale=0; $n/1000"    | bc)"
  else echo "$n"
  fi
}

# ── Helper: colored progress bar (width=8) ───────────────────────────────────
# Usage: make_bar <pct_integer> <low_color> <mid_color> <high_color>
make_bar() {
  local pct=${1:-0}
  local lo=$2 mid=$3 hi=$4
  local width=8
  local filled=$(( pct * width / 100 ))
  [ $filled -gt $width ] && filled=$width

  # choose bar colour based on percentage
  local bar_color
  if   [ $pct -ge 80 ]; then bar_color=$hi
  elif [ $pct -ge 50 ]; then bar_color=$mid
  else                        bar_color=$lo
  fi

  local bar=""
  local i=0
  while [ $i -lt $filled ]; do
    bar="${bar}█"
    i=$(( i + 1 ))
  done
  while [ $i -lt $width ]; do
    bar="${bar}░"
    i=$(( i + 1 ))
  done

  printf "${bar_color}%s${reset}" "$bar"
}

# ── Parse JSON fields ─────────────────────────────────────────────────────────
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
# Shorten to something like "Sonnet 4.6"
short_model=$(echo "$model_name" | sed 's/Claude //I' | sed 's/claude //I')

ctx_used_pct=$(echo "$input"  | jq -r '.context_window.used_percentage       // "0"' | xargs printf "%.0f")
ctx_total=$(echo "$input"     | jq -r '.context_window.context_window_size    // 0')
ctx_input=$(echo "$input"     | jq -r '.context_window.total_input_tokens     // 0')

tok_in=$(echo "$input"        | jq -r '.context_window.current_usage.input_tokens  // 0')
tok_out=$(echo "$input"       | jq -r '.context_window.current_usage.output_tokens // 0')

five_pct=$(echo "$input"      | jq -r '.rate_limits.five_hour.used_percentage  // empty')
five_resets=$(echo "$input"   | jq -r '.rate_limits.five_hour.resets_at        // empty')

week_pct=$(echo "$input"      | jq -r '.rate_limits.seven_day.used_percentage  // empty')
week_resets=$(echo "$input"   | jq -r '.rate_limits.seven_day.resets_at        // empty')

# ── Segment 1: model ─────────────────────────────────────────────────────────
seg_model="${purple}model ${white}${short_model}${reset}"

# ── Segment 2: context window ─────────────────────────────────────────────────
ctx_used_fmt=$(fmt_num "$ctx_input")
ctx_total_fmt=$(fmt_num "$ctx_total")
ctx_bar=$(make_bar "$ctx_used_pct" "$green" "$yellow" "$red")
seg_ctx="${cyan}ctx:${reset} ${white}${ctx_used_fmt}/${ctx_total_fmt}${reset} ${ctx_bar} ${white}${ctx_used_pct}%${reset}"

# ── Segment 3: token counts ───────────────────────────────────────────────────
tok_in_fmt=$(fmt_num "$tok_in")
tok_out_fmt=$(fmt_num "$tok_out")
seg_tokens="${pink}tokens${reset} ${green}↑${tok_in_fmt}${reset} ${orange}↓${tok_out_fmt}${reset}"

# ── Segment 4: 5-hour rate limit (only when data is present) ─────────────────
seg_rate=""
if [ -n "$five_pct" ]; then
  five_pct_int=$(printf "%.0f" "$five_pct")
  rate_bar=$(make_bar "$five_pct_int" "$green" "$yellow" "$red")

  resets_str=""
  if [ -n "$five_resets" ]; then
    now=$(date +%s)
    diff=$(( five_resets - now ))
    if   [ $diff -le 0        ]; then resets_str="now"
    elif [ $diff -lt 60       ]; then resets_str="${diff}s"
    elif [ $diff -lt 3600     ]; then resets_str="$(( diff / 60 ))m"
    elif [ $diff -lt 86400    ]; then resets_str="$(( diff / 3600 ))h$(( (diff % 3600) / 60 ))m"
    else                              resets_str="$(( diff / 86400 ))d"
    fi
  fi

  seg_rate="${yellow}5h${reset} ${white}${five_pct_int}%${reset} ${rate_bar}"
  [ -n "$resets_str" ] && seg_rate="${seg_rate} ${cyan}resets ${white}${resets_str}${reset}"
fi

# ── Segment 5: 7-day rate limit (only when data is present) ──────────────────
seg_week=""
if [ -n "$week_pct" ]; then
  week_pct_int=$(printf "%.0f" "$week_pct")
  week_bar=$(make_bar "$week_pct_int" "$green" "$yellow" "$red")

  week_resets_str=""
  if [ -n "$week_resets" ]; then
    now=$(date +%s)
    diff=$(( week_resets - now ))
    if   [ $diff -le 0        ]; then week_resets_str="now"
    elif [ $diff -lt 60       ]; then week_resets_str="${diff}s"
    elif [ $diff -lt 3600     ]; then week_resets_str="$(( diff / 60 ))m"
    elif [ $diff -lt 86400    ]; then week_resets_str="$(( diff / 3600 ))h$(( (diff % 3600) / 60 ))m"
    else                              week_resets_str="$(( diff / 86400 ))d"
    fi
  fi

  seg_week="${yellow}7d${reset} ${white}${week_pct_int}%${reset} ${week_bar}"
  [ -n "$week_resets_str" ] && seg_week="${seg_week} ${cyan}resets ${white}${week_resets_str}${reset}"
fi

# ── Assemble ──────────────────────────────────────────────────────────────────
sep="${gray} | ${reset}"
line="${seg_model}${sep}${seg_ctx}${sep}${seg_tokens}"
[ -n "$seg_rate" ] && line="${line}${sep}${seg_rate}"
[ -n "$seg_week" ] && line="${line}${sep}${seg_week}"

printf "%b\n" "$line"
