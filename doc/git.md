# add follow to ~/.gitconfig

```
[http "https://github.com"]
	proxy = socks5s://127.0.0.1:10808
[alias]
	st = status -bs
	br = branch
	co = checkout
	ci = commit
	cp = cherry-pick
	lg = log --color --graph --pretty=format:'%Cblue%h%Creset %s %C(yellow)(%ar)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit
```
