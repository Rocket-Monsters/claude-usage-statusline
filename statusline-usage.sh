#!/bin/sh
# Status line: 5h and weekly usage %, time to reset, context size; colored by threshold.
jq -rj '
  def c(p; w; a): if p > a then "191;97;106" elif p >= w then "235;203;139" else "136;192;208" end;
  def paint(rgb; s): "\u001b[38;2;\(rgb)m\(s)\u001b[0m";
  def k: if . >= 1000000 then "\((. / 100000 | round) / 10)M" else "\(. / 1000 | round)k" end;
  def epoch: if type == "number" then . else sub("\\.[0-9]+"; "") | sub("\\+00:00$"; "Z") | fromdateiso8601 end;
  def left: if . == null then "" else ((epoch - now) / 60 | round | if . < 0 then 0 else . end) as $m
    | if $m >= 1440 then " \($m / 1440 | floor)d\($m % 1440 / 60 | floor)h"
      else " \($m / 60 | floor)h\($m % 60 | tostring | if length < 2 then "0" + . else . end)m" end end;
  def win(r; name): if r == null then empty
    else paint(c(r.used_percentage; 80; 95); "\(name) \(r.used_percentage | round)%\(r.resets_at | left)") end;
  (.context_window // {}) as $cw
  | ($cw.used_percentage // 0) as $cp
  | [ win(.rate_limits.five_hour; "5h"),
      win(.rate_limits.seven_day; "wk"),
      paint(c($cp; 50.0001; 70); "ctx \(($cw.total_input_tokens // 0) | k)/\(($cw.context_window_size // 0) | k) \($cp | round)%") ]
  | join("\u001b[2m · \u001b[0m")
'
