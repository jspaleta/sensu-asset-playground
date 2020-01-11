#clean out the locally installed gems, installed for testing
rm -rf asset/gem/*

#clean out dist
rm -rf dist/*

# make the asset
cd asset
tar cvzf ../dist/bundler-inline-check-uptime.tar.gz bin/ gem/ rubyexec/  

# generate the sha512 file
cd ../dist
sha512sum bundler-inline-check-uptime.tar.gz > sha512sum.txt
