unset NVM_AUTO_VERSION

function nvm_auto() {

  local dir="$PWD" version

  until [[ -z "$dir" ]]; do
    if { read -r version <"$dir/.nvmrc"; } 2>/dev/null || [[ -n "$version" ]]; then
      if [[ "$version" == "$NVM_AUTO_VERSION" ]]; then return
      else
        NVM_AUTO_VERSION="$version"
        nvm use "$version" > /dev/null
        return $?
      fi
    fi

    dir="${dir%/*}"
  done

  if [[ -n "$NVM_AUTO_VERSION" ]]; then
    nvm use default
    unset NVM_AUTO_VERSION
  fi
}

# if [[ -n "$ZSH_VERSION" ]]; then
  if [[ ! "$preexec_functions" == *nvm_auto* ]]; then
    preexec_functions+=("nvm_auto")
  fi
# elif [[ -n "$BASH_VERSION" ]]; then
#   trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_auto' DEBUG
# fi
