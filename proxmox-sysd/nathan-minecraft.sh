#!/bin/bash

main() {
#    # run server on boot
#    tmux new-session -d -s minecraft
#    tmux send-keys -t minecraft 'cd ~/minecraft-server; java -Xmx6000M -Xms6000M -jar server.jar nogui' Enter

#    shutdown --no-wall 4:00

    # check network and shut down if no network
    while :; do
        check_network
        err=$?

        # log and restart the network service and interfaces if no network at all
        if [ $err -eq 1 ]; then
            echo [$(date)] Network down, shutting down now >> /var/log/nathan-minecraft.log
            shutdown now
        fi

        sleep 90
    done
}

check_network() {
    for i in {1..5}; do
        ping -c 1 192.168.255.1
        if [ $? -eq 0 ]; then return  0; fi
    done

    return 1
}

main "$@"
