split("\n") | . as $lines
| $lines | map(select(startswith("?"))) | length | if . == 0 then "" else "\\e[1;92m+\(.)\\e[0m" end | . as $num_added
| $lines | map(select(startswith("C"))) | length | if . == 0 then "" else "\\e[1;94m~\(.)\\e[0m" end | . as $num_changed
| $lines | map(select(startswith("R"))) | length | if . == 0 then "" else "\\e[1;91m-\(.)\\e[0m" end | . as $num_deleted
| "\($num_added)\($num_changed)\($num_deleted)"
