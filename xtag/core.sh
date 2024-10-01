#!/bin/zsh
# core.sh
# Current Working Version

indent() {
    local content="$1"
    local levels="$2"
    local spaces=$(printf ' %.0s' {1..$((levels * 4))})
    echo "$content" | sed "s/^/$spaces/"
}

# Declare TAG_STRUCTURE as a global associative array
typeset -gA TAG_STRUCTURE

init_tag_structure() {
    local tag_type="$1"
    local num_items="$2"

    # Clear the existing structure
    TAG_STRUCTURE=()

    TAG_STRUCTURE[type]="$tag_type"
    TAG_STRUCTURE[num_items]="$num_items"

    case "$tag_type" in
        instructions|context|repomap|version|codebase)
            TAG_STRUCTURE[content]=""
            ;;
        document|example|code)
            for i in {1..$num_items}; do
                TAG_STRUCTURE["source_$i"]=""
                TAG_STRUCTURE["content_$i"]=""
            done
            if [[ "$tag_type" == "example" ]]; then
                TAG_STRUCTURE[meta]=""
            fi
            ;;
        reasoning)
            for i in {1..$num_items}; do
                TAG_STRUCTURE["thinking_$i"]=""
                TAG_STRUCTURE["planning_$i"]=""
            done
            TAG_STRUCTURE[action]=""
            ;;
        *)
            error_exit "Unknown tag type '$tag_type'"
            ;;
    esac
}

make_xtags() {
    local tag_type="$1"
    local num_items="$2"

    [[ -z "$tag_type" ]] && error_exit "Tag type is empty in make_xtags"

    # Initialize if TAG_STRUCTURE is empty
    if [[ ${#TAG_STRUCTURE} -eq 0 ]]; then
        init_tag_structure "$tag_type" "$num_items"
    fi

    local content=""
    case "$tag_type" in
        instructions|context|repomap|codebase)
            content="<$tag_type>\n${TAG_STRUCTURE[content]}\n</$tag_type>\n"
            ;;
        version)
            content="<$tag_type>${TAG_STRUCTURE[content]}</$tag_type>\n"
            ;;
        document)
            content="<documents>\n"
            for i in {1..$num_items}; do
                content+="    <document index=\"$i\">\n"
                content+="        <src>${TAG_STRUCTURE["source_$i"]}</src>\n"
                content+="        <content>\n$(indent "${TAG_STRUCTURE["content_$i"]}" 3)\n        </content>\n"
                content+="    </document>\n"
            done
            content+="</documents>\n"
            ;;
        example)
            content="<examples>\n"
            content+="    <meta>${TAG_STRUCTURE[meta]}\n\n    </meta>\n"
            for i in {1..$num_items}; do
                content+="    <example index=\"$i\">\n"
                content+="$(indent "${TAG_STRUCTURE["content_$i"]}" 2)\n"
                content+="    </example>\n"
            done
            content+="</examples>\n"
            ;;
        code)
            content="<code>\n"
            for i in {1..$num_items}; do
                content+="    <file index=\"$i\">\n"
                content+="        <src>${TAG_STRUCTURE["source_$i"]}</src>\n"
                content+="        <content>\n$(indent "${TAG_STRUCTURE["content_$i"]}" 3)\n        </content>\n"
                content+="    </file>\n"
            done
            content+="</code>\n"
            ;;
        reasoning)
            content="<reasoning>\n"
            for i in {1..$num_items}; do
                content+="    <step index=\"$i\">\n"
                content+="        <thinking>\n$(indent "${TAG_STRUCTURE["thinking_$i"]}" 3)\n        </thinking>\n"
                content+="        <planning>\n$(indent "${TAG_STRUCTURE["planning_$i"]}" 3)\n        </planning>\n"
                content+="    </step>\n"
            done
            content+="    <action>\n$(indent "${TAG_STRUCTURE[action]}" 2)\n    </action>\n"
            content+="</reasoning>\n"
            ;;
        *)
            error_exit "Unknown tag type '$tag_type'"
            ;;
    esac

    echo -E "$content"
}

fill_tags() {
    local tag_type="$1"
    local num_items="$2"
    shift 2

    [[ -z "$tag_type" ]] && error_exit "Tag type is empty in fill_tags"

    case "$tag_type" in
        instructions|context|repomap|version|codebase)
            if [[ $# -eq 0 ]]; then
                return 0
            fi
            TAG_STRUCTURE[content]=$(<"$1")
            ;;
        document|code)
            for i in {1..$num_items}; do
                if [[ $# -ge $i ]]; then
                    local file="${argv[$i]}"
                    TAG_STRUCTURE["source_$i"]=$(basename "$file")
                    TAG_STRUCTURE["content_$i"]=$(<"$file")
                fi
            done
            ;;
        example)
            TAG_STRUCTURE[meta]="$meta"
            for i in {1..$num_items}; do
                if [[ $# -ge $i ]]; then
                    local file="${argv[$i]}"
                    TAG_STRUCTURE["content_$i"]=$(<"$file")
                fi
            done
            ;;
        reasoning)
            for i in {1..$num_items}; do
                if [[ $# -ge $((2*i-1)) ]]; then
                    TAG_STRUCTURE["thinking_$i"]="${argv[$((2*i-1))]}"
                    TAG_STRUCTURE["planning_$i"]="${argv[$((2*i))]}"
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