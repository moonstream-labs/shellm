#!/bin/zsh
# core.sh
# Current Working Version

indent() {
	local content="$1"
	local levels="$2"
	local spaces=${(l:$((levels * 4)):: :)}
	print -r -- "$content" | sed "s/^/$spaces/"
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
        document|example|file)
            for i in {1..$num_items}; do
                TAG_STRUCTURE["source_$i"]=""
                TAG_STRUCTURE["content_$i"]=""
            done
            if [[ "$tag_type" == "example" ]]; then
                TAG_STRUCTURE[meta]="$meta"
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
            content=$(cat <<EOF
<$tag_type>
${TAG_STRUCTURE[content]}
</$tag_type>
EOF
)
            ;;
        version)
            content="<$tag_type>${TAG_STRUCTURE[content]}</$tag_type>"
            ;;
        document)
            content="<documentation type=\"\" id=\"\">" 
            for i in {1..$num_items}; do
                content+=$(cat <<EOF

    <document src="${TAG_STRUCTURE["source_$i"]}">
$(indent "${TAG_STRUCTURE["content_$i"]}" 2)
    </document>
EOF
)
            done
            content+=$'\n</documentation>'
            ;;
        example)
            content="<examples>"
            for i in {1..$num_items}; do
                content+=$(cat <<EOF

    <example index="$i">
$(indent "${TAG_STRUCTURE["content_$i"]}" 2)
    </example>
EOF
)
            done
            content+=$'\n</examples>'
            ;;
        file)
            content="<codebase type=\"\" id=\"\">"
            for i in {1..$num_items}; do
                content+=$(cat <<EOF

    <file src="${TAG_STRUCTURE["source_$i"]}">
$(indent "${TAG_STRUCTURE["content_$i"]}" 2)
    </file>
EOF
)
            done
            content+=$'\n</codebase>'
            ;;
        reasoning)
            content="<reasoning index=\"\">"
            for i in {1..$num_items}; do
                content+=$(cat <<EOF

    <thinking step="$i">
$(indent "{{THINKING}}" 2)
    </thinking>
EOF
)
            done
			content+=$'\n    <reflection>\n        {{REFLECTION}}\n    </reflection>'
            content+=$'\n</reasoning>'
            ;;
        *)
            error_exit "Unknown tag type '$tag_type'"
            ;;
    esac

    print -r -- "$content"
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
        document|file)
            for i in {1..$num_items}; do
                if [[ $# -ge $i ]]; then
                    local src="${argv[$i]}"
                    TAG_STRUCTURE["source_$i"]=$(basename "$src")
                    TAG_STRUCTURE["content_$i"]=$(<"$src")
                fi
            done
            ;;
        example)
            TAG_STRUCTURE[meta]="$meta"
            for i in {1..$num_items}; do
                if [[ $# -ge $i ]]; then
                    local src="${argv[$i]}"
                    TAG_STRUCTURE["content_$i"]=$(<"$src")
                fi
            done
            ;;
        reasoning)
            for i in {1..$num_items}; do
                if [[ $# -ge $((2*i-1)) ]]; then
                    TAG_STRUCTURE["thinking_$i"]="${argv[$((2*i-1))]}"
                fi
            done
            ;;
        *)
            error_exit "Unknown tag type '$tag_type'"
            ;;
    esac
}