#!/bin/sh

# Define the GitHub repository to clone
REPO_URL="https://github.com/melvyndekort/systemsetup.git"


# Function to install packages using the appropriate package manager
install_packages() {
  if command -v apt >/dev/null 2>&1; then
    # Ubuntu/Debian systems
    echo "Detected Ubuntu/Debian system. Installing packages with apt..."
    sudo apt update
    sudo apt install -y ansible git gnupg make
  elif command -v pacman >/dev/null 2>&1; then
    # Arch Linux systems
    echo "Detected Arch Linux system. Installing packages with pacman..."
    sudo pacman -Syu --noconfirm ansible git gnupg sudo make
  else
    echo "Unsupported package manager. Please install ansible, git, and gnupg manually."
    exit 1
  fi
}


# Function to create my user
create_user() {
  GROUPS=$(grep -E '^sudo:|^wheel:|^adm:' /etc/group | awk -F: '{print $1}' | paste -sd ',')
  if ! grep -q melvyn /etc/passwd; then
    useradd -m -d /home/melvyn -G $GROUPS melvyn
    echo "User melvyn created."
  else
    echo "User melvyn already exists."
  fi
}


# Function to fetch GPG keys from YubiKey and set ultimate trust
configure_gpg() {
  echo "Fetching keys from YubiKey as melvyn..."

  # Create a temporary file for fetch commands
  FETCH_COMMANDS=$(mktemp)
  cat <<EOF >"$FETCH_COMMANDS"
fetch
EOF

  # Run the fetch command as the 'melvyn' user
  sudo -u melvyn gpg --batch --command-file "$FETCH_COMMANDS" --edit-card
  rm -f "$FETCH_COMMANDS"

  # Get the fetched key ID
  KEY_ID=$(sudo -u melvyn gpg --list-keys --with-colons | awk -F: '/^pub/ {print $5}' | head -n 1)

  if [ -z "$KEY_ID" ]; then
    echo "No key fetched from YubiKey. Please check your configuration."
    exit 1
  fi

  echo "Fetched key ID: $KEY_ID"

  # Create a temporary file for trust commands
  TRUST_COMMANDS=$(mktemp)
  cat <<EOF >"$TRUST_COMMANDS"
trust
5
y
EOF

  # Set the fetched key as ultimately trusted
  sudo -u melvyn gpg --batch --command-file "$TRUST_COMMANDS" --edit-key "$KEY_ID"
  rm -f "$TRUST_COMMANDS"

  echo "Key $KEY_ID has been fetched and set as ultimately trusted."
}


# Configure SSH auth
configure_ssh() {
  echo "Configuring SSH authentication using gpg..."
  cat << EOF > /home/melvyn/.gnupg/gpg-agent.conf
enable-ssh-support
default-cache-ttl 34560000
max-cache-ttl 34560000
EOF

  cat << EOF > /home/melvyn/.gnupg/sshcontrol
5488B187EFAE4A482A6E5BC37C66EC4C5C2DA32E
1D0FCC6D76758AAFD91D30F2B60F773F06C53C0E
EOF

  chown -R melvyn: /home/melvyn/.gnupg/*
}


# Function to clone the systemsetup repository
clone_repository() {
  echo "Cloning repository: $REPO_URL"
  sudo -u melvyn git clone "$REPO_URL" /home/melvyn/systemsetup
  if [ $? -eq 0 ]; then
    echo "Repository cloned successfully."
  else
    echo "Failed to clone repository."
    exit 1
  fi
}


# Function to prepare ansible on the local machine
prepare_ansible() {
  cd /home/melvyn/systemsetup

  echo "Installing Ansible dependencies..."
  sudo -u melvyn ansible-galaxy install --force -r requirements.yml
}


# Function to run ansible on the local machine
run_ansible() {
  cd /home/melvyn/systemsetup

  echo "Running Ansible..."
  sudo -u melvyn ansible-playbook \
	--vault-password-file vault_pass.sh \
	--extra-vars @files/vault.yml \
	--extra-vars @files/vars.yml \
	--connection=local \
	--inventory inventory.ini \
	--limit pblaptop \
	site.yml
}


# Main script execution
install_packages
create_user
configure_gpg
clone_repository
prepare_ansible
#run_ansible
