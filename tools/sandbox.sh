#! /usr/bin/env bash

FIXED_PWD="$(realpath "$PWD")"

bwrap \
  --ro-bind /usr /usr \
  --ro-bind /nix /nix \
  --ro-bind /lib64 /lib64 \
  --ro-bind /run /run \
  --ro-bind /etc/resolv.conf /etc/resolv.conf \
  --ro-bind /etc/ssl /etc/ssl \
  --ro-bind /etc/static/ssl /etc/static/ssl \
  --ro-bind /run/current-system/sw/bin/ /bin \
  --ro-bind "$HOME" "$HOME" \
  --overlay-src "$HOME/.local/" \
  --tmp-overlay "$HOME/.local/" \
  --overlay-src "$HOME/.cache/" \
  --tmp-overlay "$HOME/.cache/" \
  --proc /proc \
  --dev /dev \
  --tmpfs /tmp \
  --bind  "$FIXED_PWD" "$FIXED_PWD" \
  --chdir "$FIXED_PWD" \
  --unshare-pid \
  --unshare-ipc \
  --unshare-uts \
  --hostname nixos \
  --unshare-user \
  --unshare-cgroup \
  --disable-userns \
  --assert-userns-disabled \
  --die-with-parent \
  --setenv PS1 "wrap >" \
  --tmpfs "$HOME/.keepassxc" \
  --tmpfs "$HOME/keys" \
  --tmpfs "$HOME/.pki" \
  --tmpfs "$HOME/.gnupg" \
  --tmpfs "$HOME/.mozilla" \
  --tmpfs "$HOME/.thunderbird" \
  --unshare-net \
  "$@"
