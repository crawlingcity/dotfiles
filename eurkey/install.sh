#!/bin/zsh

set -eu

script_dir=${0:A:h}
source_dir="${script_dir}/files"
user_home=$(cd ~ && pwd -P)
target_dir="${user_home}/Library/Keyboard Layouts"

if [[ -z "${user_home}" ]]; then
  print -u2 "Could not determine the current user's home directory."
  exit 1
fi

layout_files=(
  EurKEY.keylayout
  EurKEY.icns
)

install -d -m 0755 "${target_dir}"

changed=false
for layout_file in "${layout_files[@]}"; do
  source_file="${source_dir}/${layout_file}"
  target_file="${target_dir}/${layout_file}"

  if [[ -f "${target_file}" ]] && cmp -s "${source_file}" "${target_file}"; then
    print "Already current: ${target_file}"
    continue
  fi

  install -m 0644 "${source_file}" "${target_file}"
  print "Installed: ${target_file}"
  changed=true
done

if [[ "${changed}" == true ]]; then
  print
  print "Log out and back in so macOS reloads keyboard layouts."
  print "Then open System Settings > Keyboard > Text Input > Edit,"
  print "add EurKEY v1.2, and select it as your input source."
fi
