#!/bin/zsh
# core.sh
# Current Working Version

init_tag_structure() {
    local tag_type="$1"
    local num_items="$2"

    # Use typeset to declare the associative array in zsh
    typeset -A TAG_STRUCTURE
    TAG_STRUCTURE[type]="$tag_type"
    TAG_STRUCTURE[num_items]="$num_items"

    case "$tag_type" in
        instructions|context|filetree|codebase)
            TAG_STRUCTURE[content]="{{CONTENT}}"
            ;;
        document|example|code)
            for i in {1..$num_items}; do
                TAG_STRUCTURE[source_$i]="{{SOURCE_$i}}"
                TAG_STRUCTURE[content_$i]="{{CONTENT_$i}}"
            done
            if [[ "$tag_type" == "example" ]]; then
                TAG_STRUCTURE[meta]="{{META}}"
            fi
            ;;
        reasoning)
            for i in {1..$num_items}; do
                TAG_STRUCTURE[thinking_$i]="{{THINKING_$i}}"
                TAG_STRUCTURE[planning_$i]="{{PLANNING_$i}}"
            done
            TAG_STRUCTURE[action]="{{ACTION}}"
            ;;
        *)
            error_exit "Unknown tag type '$tag_type'"
            ;;
    esac
}

# The rest of the file remains the same, but ensure to use zsh-compatible syntax
# For example, replace `seq` with zsh range syntax where applicable

make_xtags() {
    local tag_type="$1"
    local num_items="${2:-1}"

    init_tag_structure "$tag_type" "$num_items"

    local content=""
    case "$tag_type" in
        instructions|context|filetree|codebase)
            content="<$tag_type>\n${TAG_STRUCTURE[content]}\n</$tag_type>\n"
            ;;
        document)
            content="<documents>\n"
            for i in {1..$num_items}; do
                content+="    <document index=\"$i\">\n"
                content+="        <src>${TAG_STRUCTURE[source_$i]}</src>\n"
                content+="        <content>\n${TAG_STRUCTURE[content_$i]}\n        </content>\n"
                content+="    </document>\n"
            done
            content+="</documents>\n"
            ;;
        example)
            content="<examples>\n"
            content+="    <meta>${TAG_STRUCTURE[meta]}</meta>\n"
            for i in {1..$num_items}; do
                content+="    <example index=\"$i\">\n"
                content+="      ${TAG_STRUCTURE[content_$i]}\n"
                content+="    </example>\n"
            done
            content+="</examples>\n"
            ;;
        code)
            content="<code>\n"
            for i in {1..$num_items}; do
                content+="    <file index=\"$i\">\n"
                content+="        <src>${TAG_STRUCTURE[source_$i]}</src>\n"
                content+="        <content>\n${TAG_STRUCTURE[content_$i]}\n        </content>\n"
                content+="    </file>\n"
            done
            content+="</code>\n"
            ;;
        reasoning)
            content="<reasoning>\n"
            for i in {1..$num_items}; do
                content+="    <step index=\"$i\">\n"
                content+="        <thinking>\n${TAG_STRUCTURE[thinking_$i]}\n        </thinking>\n"
                content+="        <planning>\n${TAG_STRUCTURE[planning_$i]}\n        </planning>\n"
                content+="    </step>\n"
            done
            content+="    <action>\n${TAG_STRUCTURE[action]}\n    </action>\n"
            content+="</reasoning>\n"
            ;;
        *)
            error_exit "Unknown tag type '$tag_type'"
            ;;
    esac

    echo -E "$content"
}

# The fill_tags function remains largely the same, but ensure to use zsh-compatible syntax
fill_tags() {
    local tag_type="${TAG_STRUCTURE[type]}"
    local num_items="${TAG_STRUCTURE[num_items]}"
    shift 2

    case "$tag_type" in
        instructions|context|filetree|codebase)
            if [[ $# -eq 0 ]]; then
                return 0
            fi
            TAG_STRUCTURE[content]=$(<"$1")
            ;;
        document|code)
            for i in {1..$num_items}; do
                if [[ $# -ge $i ]]; then
                    local file="${argv[$i]}"
                    TAG_STRUCTURE[source_$i]=$(basename "$file")
                    TAG_STRUCTURE[content_$i]=$(<"$file")
                fi
            done
            ;;
        example)
            TAG_STRUCTURE[meta]="$1"
            shift
            for i in {1..$num_items}; do
                if [[ $# -ge $i ]]; then
                    local file="${argv[$i]}"
                    TAG_STRUCTURE[content_$i]=$(<"$file")
                fi
            done
            ;;
        reasoning)
            for i in {1..$num_items}; do
                if [[ $# -ge $((2*i-1)) ]]; then
                    TAG_STRUCTURE[thinking_$i]="${argv[$((2*i-1))]}"
                    TAG_STRUCTURE[planning_$i]="${argv[$((2*i))]}"
                fi
            done
            if [[ $# -ge $((2*num_items+1)) ]]; then
                TAG_STRUCTURE[action]="${argv[$((2*num_items+1))]}"
            fi
            ;;
        *)
            error_exit "Unknown tag type '$tag_type'"
            ;;
    esac
}