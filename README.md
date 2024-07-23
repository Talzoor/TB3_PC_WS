# TB3_PC_WS
Turtlebot3 ROS2 workspace, PC part

## git setup: 

### install git

```bash  
sudo apt-get -y install git
```

### passkey, [URL](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

create ssh key

```bash  
ssh-keygen -t ed25519 -C "tal.turtlebot.mail@gmail.com"
```

Adding your SSH key to the ssh-agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

show key

```bash
cat ~/.ssh/id_ed25519.pub
```

# add to github : [URL](https://github.com/settings/keys)

### github web login

```bash  
sudo apt-get -y install gh
gh auth login
```

### github clone

make sure to clone ssh address-

```bash  
git clone git@github.com:Talzoor/TB3_PC_WS.git
```