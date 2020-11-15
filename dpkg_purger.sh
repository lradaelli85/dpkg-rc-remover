#!/usr/bin/env bash
#Author Luca Radaelli
#

packages=($(dpkg -l |grep ^rc |awk '{print $2}'))
reply="Null"
DPKG=$(which dpkg)

if [ ${#packages[@]} -eq 0 ]; then
    echo 'nothing to purge'
    exit 0;
else
    echo -e 'packages in rc state: \n'
    echo -e "${packages[@]} \n"
    for package in ${packages[@]}
    do
        if [ ${reply} != "a" ]; then
            reply="Null"
            until [ ${reply} == "y" ] || [ ${reply} == "n" ] || [ ${reply} == "a" ]
            do
                read -p "Do you want to purge ${package} (y/n/a) [yes/no/all]  " reply
            done
        fi
        case ${reply} in
            y|a)
                echo -e "Purging ${package}.... \n"
                ${DPKG} --purge ${package}
                ;;
            n) echo -e "${package}: Not purged \n"
                ;;
            *) echo "
                Reply y/n/a
                a = Purge all packages in rc state
                y = Purge the selected package
                n = Skip the selected package
                "
                ;;
        esac
    done
fi
