#!/usr/bin/env bash
git add .
git commit -m 'updating sdk url'
git push
git push origin premain:carpe-new-paytheorystudy -f
git push origin premain:carpe-new-paytheory -f
git push origin premain:carpe-new-paytheorylab -f
git push origin premain:carpe-old-paytheory -f
git push origin premain:carpe-old-paytheorylab -f
git push origin premain:carpe-old-paytheorystudy -f