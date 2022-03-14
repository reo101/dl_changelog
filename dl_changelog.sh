#!/usr/bin/env bash

TARGET="${TARGET:-$HOME/Downloads}"
PREFER_WGET="${PREFER_WGET:-no}"

declare -a base_urls=('https://cdn.changelog.com/uploads/podcast/<id>/the-changelog-<id>.mp3'
                      'https://cdn.changelog.com/uploads/gotime/<id>/go-time-<id>.mp3'
                      'https://cdn.changelog.com/uploads/rfc/<id>/request-for-commits-<id>.mp3'
                      'https://cdn.changelog.com/uploads/founderstalk/<id>/founders-talk-<id>.mp3'
                      'https://cdn.changelog.com/uploads/spotlight/<id>/spotlight-<id>.mp3'
                      'https://cdn.changelog.com/uploads/jsparty/<id>/js-party-<id>.mp3'
                      'https://cdn.changelog.com/uploads/practicalai/<id>/practical-ai-<id>.mp3'
                      )

download_podcast() {
    base_url="${base_urls[$((${1} - 1))]}"

    printf "\nEnter one or more episodes to download (comma separated, no spaces):\n"

    IFS=',' read -r -a episodes

    for episode in "${episodes[@]}"
    do
        download_url=$(echo "${base_url}" | sed "s/<id>/${episode}/g")

        printf "\nDownloading episode %s\n" "${download_url##*/}"

        if [[ "${PREFER_WGET}" == "yes" ]]; then
            wget -q --show-progress --progress=bar:force:noscroll \
                --directory-prefix "${TARGET}" "${download_url}"
        else
            curl --progress-bar --styled-output --remote-name \
                --output-dir "${TARGET}" --location "${download_url}"
        fi
    done
}

print_menu() {
    cat <<- EOF
Which podcast would you like to download?
(1) - The Changelog
(2) - Go Time
(3) - Request for Commits
(4) - Founders Talk
(5) - Spotlight
(6) - JS Party
(7) - Practical AI
EOF
}

main() {
    print_menu

    read option

    download_podcast option
}

main
