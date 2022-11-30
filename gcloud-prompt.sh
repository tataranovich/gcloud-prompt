function __gcloud_ps1() {
    local GCLOUD_PROFILE PROFILE_COLOR GCLOUD_PROJECT GKE_CONTEXT GKE_CLUSTER

    GCLOUD_PROFILE=

    if [ -f ~/.config/gcloud/active_config ]; then
        GCLOUD_PROFILE="$(cat ~/.config/gcloud/active_config)"
        case "${GCLOUD_PROFILE}" in
            *-dev) PROFILE_COLOR='0;32';;
            *-test) PROFILE_COLOR='1;33';;
            *-stage) PROFILE_COLOR='1;33';;
            *-prod) PROFILE_COLOR='0;31';;
            *) PROFILE_COLOR='0;37';;
        esac
        echo -en "\e[${PROFILE_COLOR}m (☁ ${GCLOUD_PROFILE})\e[0m"
        if [ -x "$(which kubectl)" ]; then
            if [ -f ~/.config/gcloud/configurations/config_${GCLOUD_PROFILE} ]; then
                GCLOUD_PROJECT=$(grep ^project ~/.config/gcloud/configurations/config_${GCLOUD_PROFILE} | awk '{print $3}')
                GKE_CONTEXT="$(kubectl config current-context 2>/dev/null)"
                if echo "${GKE_CONTEXT}" | grep -q '^gke_'; then
                    GKE_PROJECT=$(echo "${GKE_CONTEXT}" | sed -e 's/gke_//' -e 's/_.*//')
                    GKE_CLUSTER=$(echo "${GKE_CONTEXT}" | sed -e 's/.*_//')
                    if [ "${GCLOUD_PROJECT}" != "${GKE_PROJECT}" ]; then
                        echo -en "\e[0;31m !${GKE_PROJECT}/${GKE_CLUSTER}!\e[0m"
                    else
                        echo -en "\e[0;32m [${GKE_CLUSTER}]\e[0m"
                    fi
                fi
            fi
        fi
    fi
}
