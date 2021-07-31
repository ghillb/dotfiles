#!/usr/bin/env bash
set -euxo pipefail

sed -i -e '/^#[^!].*/d' -e 's/\(.*[^!]\)#.*[^}]/\1/' $1

