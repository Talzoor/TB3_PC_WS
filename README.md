# TB3_PC_WS
Turtlebot3 ROS2 workspace, PC part

## git setup (passkey): [URL](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

	
	#create ssh key
	ssh-keygen -t ed25519 -C "tal.turtlebot.mail@gmail.com"
	#Adding your SSH key to the ssh-agent
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_ed25519
	#show key
	cat ~/.ssh/id_ed25519.pub
	# add to github : https://github.com/settings/keys