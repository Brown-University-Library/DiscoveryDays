# StackLife
Instructions on how to get started for the *StackLife* hackathon at Brown University as part of Discovery Days (June/2017)

    Channel A: StackLife (data provided) — integrating virtual browse in discovery systems

A good place to start is Harvard's original prototype: http://stacklife.harvard.edu/

Source code can be found [here](https://github.com/harvard-lil/stacklife). This has instructions on how to get it running locally in your box (it requires PHP, MySQL, and Apache).

You can also take a look at [StackView](https://github.com/harvard-lil/stackview/), a jQuery plug-in to display the data.


## Demos
A few sites using StackLife

* Harvard's original prototype: http://stacklife.harvard.edu/
* Brown: https://search.library.brown.edu/catalog/b3130393?nearby=y
* Cornell: http://stackview.library.cornell.edu/

A few sites using something similar to allow browsing
* NCSU: http://catalog.lib.ncsu.edu/browse?callNumber=TK5105.888+.B46+1999&format=covers
* Stanford: https://searchworks.stanford.edu/browse?barcode=36105008570488&start=2766559&view=gallery


## Play with the code locally
For the hackathon we'll use a fork of StackView that has a quick and easy way to play with StackView with live data coming from the Brown University Library web site.

The demo with the live data requires that you have Node.js installed on your machine. To verify that you do run the following command from the Terminal:

```
node --version
```

You should see something along the lines of `v6.2.2`. If you see `command not found` it means Node.js is not installed on your machine and you'll need to get it from https://nodejs.org/.

Once you've verified that Node.js is installed on your machine, follow these steps to get the sample code running:

```
cd
git clone https://github.com/hectorcorrea/stackview.git
cd stackview 
node server.js
```

Then browse to http://localhost:8000/demo/basic.html this will show you StackView running with two hardcoded items. You can see the data for the hard-code items in file demo/basic.html.

Then browse to http://localhost:8000/demo/brown.html, this will show you StackView running and fetching data from the Brown University Library API. Ideally you should implement a similar API at your institution to get the same behavior.
