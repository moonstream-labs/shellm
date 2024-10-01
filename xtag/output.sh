#!/bin/zsh
# output.sh
# Current Working Version

handle_output() {
    local content="$1"
    local save_path="$2"
    local multi_save_dir="$3"

    if [[ -n "$save_path" ]]; then
        save_single_file "$content" "$save_path"
        print "Output saved to $save_path"
    elif [[ -n "$multi_save_dir" ]]; then
        save_multiple_files "$content" "$multi_save_dir"
        print "Output saved as multiple files in $multi_save_dir"
    else
        print -n "$content" | pbcopy
    fi
}

# Save output to a single file
save_single_file() {
    local content="$1"
    local save_path="$2"
    print -n "$content" > "$save_path"
}

# Save output as multiple files
save_multiple_files() {
    local content="$1"
    local save_dir="$2"
    local examples_dir="$save_dir/examples"
    local i=1

    while [[ -d "$examples_dir" ]]; do
        examples_dir="${save_dir}/examples_$i"
        ((i++))
    done

    mkdir -p "$examples_dir"

    print -n "$content" | awk '
    /<(example|document|file)[ >]/,/<\/(example|document|file)>/ {
        if ($0 ~ /<(example|document|file)[ >]/) {
            close(file);
            match($0, /index="([0-9]+)"/, arr);
            file = "'"$examples_dir"'/" substr($1,2) "_" arr[1] ".xml";
        }
        print > file;
    }
    '
}