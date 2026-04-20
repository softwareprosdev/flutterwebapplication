# First, let's check if there's an existing remote and set it up properly
cd /home/windows11/Documents/CryptoMeccaWallet

# Set the remote
git remote add origin https://github.com/softwareprosdev/flutterwebapplication.git

# Rename branch to main
git branch -M main

# Now push - you'll need to authenticate
git push -u origin main