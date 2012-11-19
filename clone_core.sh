#!/bin/sh -ex
# Helper script to clone a new version of Core
# Usage: $0 108.07.01 108.08.00 0
# (to clone 108.07.01 to 108.08.00-pre0)
fromv=$1
tov=$2
pre=$3

if [ ! -z "${pre}" ]; then
  tov_full="$tov_full-pre${pre}"
else
  tov_full=${tov}
fi

repo=~/.opam/repo/default/packages

pkgs="async async_core async_extra async_unix bin_prot comparelib core core_extended fieldslib pa_ounit pipebang sexplib type_conv typehashlib variantslib"

for pkg in ${pkgs}; do
  src=${repo}/${pkg}.${fromv}
  dst=packages/${pkg}.${tov_full}
  rm -rf ${dst}
  cp -r ${src} ${dst}
  echo archive: \"https://ocaml.janestreet.com/ocaml-core/${tov_full}/individual/${pkg}-${tov_full}.tar.gz\" > ${dst}/url
  sed -i.bak -e "s/${fromv}/${tov_full}/g" ${dst}/opam
  rm -f ${dst}/opam.bak
done

opam-mk-repo --generate-checksums
