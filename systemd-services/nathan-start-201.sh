#!/bin/bash

main() {
    while :; do
        # see if vm is running
        vm=201
        qm status $vm | grep stopped
        err1=$?

        ping -c 1 192.168.255.1
        err2=$?

        # restart vm if it is not running and LAN up
        if [ $err1 -eq 0 ]; then        # vm not running
            if [ $err2 -eq 0 ]; then    # LAN up
                echo [$(date)] Starting VM $vm now >> /var/log/nathan-mc-start.log
                qm start $vm
            fi
        fi

        sleep 90
    done
}

main "$@"
