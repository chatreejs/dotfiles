# Chatree.js's "Dotfiles"

Hi, there! 👋

I'm Chatree.js, a 25 years old Senior Application Engineer from Thailand

This repository **Dotfiles** contain my personal config files. Here you'll find configs, customizations, themes, and whatever I need to personalize my Linux and mac OS experience.

> ⚠️ Be aware, products can change over time. I do my best to keep up with the latest changes and releases, but please understand that this won’t always be the case.

## Usage

### Use on your machine

1. Clone this repository to your home directory

```bash
git clone https://github.com/chatreejs/dotfiles
```

2. Run boostrap script

```bash
cd dotfiles
chmod +x ./install.sh
./install.sh
```

3. Restart your terminal

### Use as a Container

Run my dotfiles in Linux container using following command

```bash
docker run -it --rm chatreejs/dotfiles:<TAG>
```

#### Available tags

You can use different tags to run different Linux distro

- `ubuntu` - Ubuntu 22.04 (Jammy)
- `debian` - Debian 11 (Bullseye)
- `fedora` - Fedora 34 (Workstation Edition)
- `centos` - CentOS 8
- `alpine` - Alpine 3.14
