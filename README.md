# WSG Scrapper

This small ruby script scraps the Web Sustainability Guidelines (aka WSG) for it's titles and the corresponding ratings (Impact and Effort). The scrapping of data is then saved in a .csv-file `wsg-titles-impacts-efforts.csv`.

## Setup
Make sure you have Ruby installed. This script is tested with ruby version `ruby 3.0.6p216 (2023-03-30 revision 23a532679b) [arm64-darwin23]` on a MacBook Pro running MacOS 14.0.

Clone the repo, then in your terminal go to the folder and run:
```
bundle install
```
to install all the gems.

## Run the script
```
ruby main.rb
```