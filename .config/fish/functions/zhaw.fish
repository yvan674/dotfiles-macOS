function zhaw
    if [ -z "$argv" ]
		echo -e "\033]50;SetProfile=DGX2\a" && ssh saty@dgx2.cloudlab.zhaw.ch && echo -e "\033]50;SetProfile=Default\a"
	else if [ "$argv[1]" = "1" ]
        echo -e "\033]50;SetProfile=DGX\a" && ssh saty@dgx.cloudlab.zhaw.ch && echo -e "\033]50;SetProfile=Default\a"
	else if [ "$argv[1]" = "sh" ]
		echo "Forwarding port "$argv[2]" from dgx2 server" && ssh -L 127.0.0.1:8888:0.0.0.0:$argv[2] -N saty@dgx2.cloudlab.zhaw.ch
	else if [ "$argv[1]" = "sh1" ]
		echo "Forwarding port "$argv[2]" from dgx server" && ssh -L 127.0.0.1:8888:0.0.0.0:$argv[2] -N saty@dgx.cloudlab.zhaw.ch
	else if [ "$argv[1]" = "tb" ]
		echo "Forwarding Tensorboard port from dgx2 server" && ssh -L 127.0.0.1:5000:0.0.0.0:9175 -N saty@dgx2.cloudlab.zhaw.ch
	else if [ "$argv[1]" = "tb1" ]
		echo "Forwarding Tensorboard port from dgx1 server" && ssh -L 127.0.0.1:5000:0.0.0.0:9175 -N saty@dgx.cloudlab.zhaw.ch
    else if [ "$argv[1]" = "sync" ]
		rsync -avz --delete /Users/Yvan/OneDrive/ZHAW/Sync/ saty@dgx2.cloudlab.zhaw.ch:/cluster/home/saty/sync
	else
		echo "Illegal arguments given"
	end
end
