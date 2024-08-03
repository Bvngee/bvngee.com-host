#!/bin/sh

# USAGE:
# run_with_secrets.sh SECRET1 SECRET2 ... \ COMMAND

# This uses the convention of a SECRETNAME_FILE env var (which is easy to set
# with docker compose secrets) being a path to a plain text file containing the
# value of SECRETNAME. Many programs support reading secrets directly from their _FILE's,
# but some don't; this allows those that don't to still work with only the _FILE env var set.

while [ "$#" -gt 0 ]; do
    if [ "$1" = "\\" ]; then
        shift
        break
    fi
    secret_file_var="${1}_FILE"
    secret_file=$(eval echo \$"$secret_file_var")
    if [ -z "$secret_file" ]; then
        echo "${secret_file_var} env var is not set!"
        exit 1
    elif ! [ -f "${secret_file}" ]; then
        echo "The file referenced by ${secret_file_var} (${secret_file}) does not exist!"
        exit 1
    fi
    export "$1"="$(cat "$secret_file")"
    shift
done

# Execute the remaining arguments as a command
"$@"

# (thanks gpt for the help on this one)
