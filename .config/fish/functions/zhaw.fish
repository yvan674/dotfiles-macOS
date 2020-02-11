function zhaw
    function _zhaw_show_usage
        echo "usage: zhaw [options]"
        echo ""
        echo "Options and arguments:"
        echo "    -b server          : Selects the corresponding dgx server. E.g. if"
        echo "                         server=1, selects dgx. If server=2, selects dgx2."
        echo "                         Defaults to dgx if flag not given."
        echo "    -f, --forward port : Forwards the given ssh port on the cluster to"
        echo "                         localhost:8888. Defaults to 9177"
        echo "    -t, --tensorboard  : Forwards the tensorboard port (9175) on the dgx2 to"
        echo "                         localhost:5000."
        echo "    -s, --sync         : Performs an rsync command between the local sync"
        echo "                         directory with the cluster."
        echo "    -k, --kill         : Kills any port forwarding sessions. This is a mutually"
        echo "                         exclusive option from the rest of the options. This is"
        echo "                         always executed first."
        echo "    -m, --mount [path] : Mounts the selected path on the DGX server on the local"
        echo "                         machine. Defaults to /cluster/home/saty."
        echo "    -u, --unmount      : Forcibly unmounts all DGX volumes which are locally"
        echo "                         mounted."
        echo "    -h, --help         : Shows this help page."
        functions -e _zhaw_show_usage  # Erase usage
	end

    # Set the variables
    set server "dgx"
    set port "9177"
    set path "/cluster/home/saty/"
    set mount "/Volumes/DGX"(random 0 9)
    
    # Parse args and give help if error is thrown
    argparse --name=zhaw 'b=' 'f/forward=' 't/tensorboard' 's/sync' 'k/kill' 'm/mount=?' 'u/unmount' 'h/help' -- $argv
    or _zhaw_show_usage && return 1

    # Show usage is no flags are sety
    if not begin ; set -q _flag_b ; or set -q _flag_f ; or set -q _flag_t ; or set -q _flag_s ; or set -q _flag_k ; or set -q _flag_h ; or set -q _flag_m ; or set -q _flag_u ; end
        echo Error: zhaw requires at least one option to be selected.
        _zhaw_show_usage && return 1
    end

    # Show help if the flag is set and nothing else
    if set -q _flag_h
        _zhaw_show_usage && return
    end

    # Kill flag is mutex with everything else
    if set -q _flag_k
        # First get the currently running ssh jobs
        set running_jobs (jobs | grep -E 'ssh -L 127.0.0.1:(5000|8888):0.0.0.0:\S* -N saty@' | awk '{print $2}')
        if test -n "$running_jobs"
            begin 
                echo Killing $running_jobs
                and echo $running_jobs | xargs kill
                and return
            end
        else
            echo "No zhaw jobs are running"
            return
        end
    end

    # Parse server arg
    if set -q _flag_b
        if not set -q _flag_f
            echo "Error: option flag -b does nothing without either option flag -f"
            return 1
        end
        if [ -n "$_flag_b" ]
            if test $_flag_b -gt 1
                set server dgx$_flag_b
            end
        else
            set server dgx2
        end
    end

    # Parse forwarding arg
    if set -q _flag_f
        if [ -n "$_flag_f" ]
            set port $_flag_f
        end
    end

    # Parse mounting arg
    if set -q _flag_m
        if [ -n "$_flag_m" ]
            set path $_flag_m
        end
    end

    # Now do cases. First is both forwarding and tensorboard
    if begin ; set -q _flag_f ; and set -q _flag_t ; end
        echo 'Forwarding Tensorboard port from '(set_color red)'dgx2'(set_color normal)' and forwarding port '(set_color red)$port(set_color normal)' from '(set_color red)$server(set_color normal)' server'
        ssh -L 127.0.0.1:8888:0.0.0.0:$port -N saty@$server.cloudlab.zhaw.ch &
        ssh -L 127.0.0.1:5000:0.0.0.0:9175 -N saty@dgx2.cloudlab.zhaw.ch &
    
    # Then if only forwarding
	else if set -q _flag_f
		echo "Forwarding port "(set_color red)$port(set_color normal)" from "(set_color red)$server(set_color normal)" server"
        ssh -L 127.0.0.1:8888:0.0.0.0:$port -N saty@$server.cloudlab.zhaw.ch &

    # And if only tensorboard
	else if set -q _flag_t
		echo "Forwarding Tensorboard port from dgx2 server"
        ssh -L 127.0.0.1:5000:0.0.0.0:9175 -N saty@dgx2.cloudlab.zhaw.ch &

    # The case for sync
    else if set -q _flag_s
		rsync -avz --delete /Users/Yvan/OneDrive/ZHAW/Sync/ saty@dgx2.cloudlab.zhaw.ch:/cluster/home/saty/sync

    # The case for mounting
    else if set -q _flag_m
        echo "Mounting "$path" on "$mount"..."
        sshfs saty@dgx.cloudlab.zhaw.ch:$path $mount
        open $mount

    # The case for unmounting
    else if set -q _flag_u
        echo "Unmounting all DGX volumes..."
        ls -1 /Volumes | grep "DGX" | sed 's/^/\/Volumes\//' | xargs unmount -f
	end
end
