#!/bin/bash

main() {
    while :; do
        check_network
        err=$?

        # log if something happened
        if [ $err -ne 0 ]; then 
            echo [$(date)] Network down, ERROR is $err >> /var/log/nathan-net-reconnect.log
        fi

        # restart the network service and interfaces if something bad happened

        # soft restart of interfaces
        if [ $err -eq 1 ]; then ifreload -a; fi

        # hard restart
        if [ $err -eq 2 ]; then systemctl restart networking; fi

        sleep 90
    done
}

check_network() {
    ping -c 1 9.9.9.9
    if [ $? -eq 0 ]; then return $?; fi

    ping -c 1 208.67.222.222
    if [ $? -eq 0 ]; then return $?; fi

    ping -c 1 1.1.1.1
    if [ $? -eq 0 ]; then return $?; fi

    ping -c 1 8.8.8.8
    if [ $? -eq 0 ]; then return $?; fi

    ping -c 1 192.168.255.1
    if [ $? -eq 0 ]; then return  1; fi

    return 2
}

main "$@"
