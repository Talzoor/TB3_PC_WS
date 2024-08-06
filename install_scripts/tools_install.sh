echo "Hi! make sure your user in the 'sudo' list (try 'sudo ls'), if not-"
echo "su (Enter root user)"
echo "adduser talzoor sudo"
echo "exit"
echo "reboot (Will reboot OS)"
echo ""

echo "Update apt-get"
sudo apt-get update

echo "Installing 'Terminator'"
sudo apt-get install terminator

echo "Installing VSCode"
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install code # or code-insiders

echo "Install git tools"
sudo apt-get install git gh