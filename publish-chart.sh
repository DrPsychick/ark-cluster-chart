#!/bin/sh

function bumpChartVersion() {
  v=$(grep '^version:' charts/$1/Chart.yaml | awk -F: '{print $2}' | tr -d ' ')
  patch=${v/*.*./}
  nv=${v/%$patch/}$((patch+1))
  sed -i"" -e "s/version: .*/version: $nv/" charts/$1/Chart.yaml
}

git checkout gh-pages
git pull

(
cd charts
for c in ark-cluster; do
  [ -n "$(git status -s charts/$c/Chart.yaml)" ] && bumpChartVersion $c
  helm package $c
  mv ./$c-*.tgz ../docs/
done
)

helm repo index ./docs --url https://drpsychick.github.io/ark-server-charts/

git add docs
git commit -m "publish charts" -av
git push
