function apu
    function _apu_show_usage
        echo "usage: apu [options]"
        echo ""
        echo "Options and arguments:"
        echo "    -m --mount   : Mounts the APU volume locally using sshfs."
        echo "    -u --unmount : Unmounts all local APU volumes."
        echo "    -s --sync    : Performs an rsync command between the local sync directory"
        echo "                   with the APU instance."
        echo "    -h --help    : Shows this help page."
        functions -e _apu_show_usage  # Erase usage
    end

    # Set mounting variable
    set mount_path "/Volumes/APU"

    # Parse args and give help if error is thrown
    argparse --name=apu 'm/mount' 'u/umount' 's/sync' 'h/help' -- $argv
    or _zhaw_show_usage && return 1

    # Trow error if no flags are set
    if not begin ; set -q _flag_m ; or set -q _flag_u ; or set -q _flag_s ; end
        echo "Error: apu requires at least one option to be selected."
        _zhaw_show_usage && return 1
    end

    # Show help if help is asked for
    if set -q _flag_h
        _zhaw_show_usage && return

    # Mount if flag is set
    else if set -q _flag_m
        echo "Mounting APU volume on "$mount_path"..."
        sshfs ubuntu@160.85.253.47:/home/ubuntu $mount_path
        open $mount_path

    # Unmount APU volume
    else if set -q _flag_u
        echo "Unmounting APU volume..."
        umount -f $mount_path

    # Perform sync
    else if set -q _flag_s
        rsync -avz --delete /Users/Yvan/OneDrive/ZHAW/Sync/ ubuntu@160.85.253.47:/home/ubuntu/sync
    end
end
