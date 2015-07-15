% { shopt -s nullglob; for file in _surah-titles/*.tex; do printf "\input{$file}\n"; done; }
