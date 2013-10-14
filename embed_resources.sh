#! /bin/bash

BaseDir="$(dirname $(readlink -f $0))"
SrcDir="$BaseDir/resources"
DstDir="$BaseDir/src/resources"
PkgName="res"
Prefix="./resources/"

if [ -d "$DstDir" ]; then
  echo "destination $DstDir already exists" 1>&2
  exit 1
fi

mkdir -p "$DstDir"
cd "$SrcDir"
awsres -r "$PkgName" -p "$Prefix" -o "$DstDir" -R .
