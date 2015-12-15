if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  echo -e "Starting to update gh-pages\n"

  #go to home and setup git
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"

  #using token clone gh-pages branch
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/hospitalhub/hospitalpage.git gh-pages > /dev/null

  #resize images
  sudo apt-get insatll imagemagick
  convert '*.png[650>]' -crop 640x480+0+0 -set filename:f '%t' '%[filename:f].png'

  #go into diractory and copy data we're interested in to that directory
  cd gh-pages
  cp -Rf $HOME/*.png images
  cp -Rf $HOME/*.markdown _posts

  #add, commit and push files
  git add -f .
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null

  echo -e "Done magic with pages\n"
fi
