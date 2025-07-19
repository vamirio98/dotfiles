# To use proxy for github, add follow to ~/.ssh/config

```
Host github.com
	User git
	Hostname ssh.github.com
	# For Linux
	# if in Hyper-V virutal machine, and NAT to host to browse intenet,
	# <ip> should be the geteway of the SSH Switch
	ProxyCommand netcat -v -x 127.0.0.1:10808 %h %p

	# For Windows
	ProxyCommand connect -S 127.0.0.1:10808 -a none %h %p
```
