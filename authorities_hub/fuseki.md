## Download and install Fuseki
Pre-requisites. Fuseki requires Java to be installed on your machine. To verify that you have
Java installed on your box issue the following command from the Terminal

```
java -version
```

You should see something along the lines of `java version 1.8.0_91`. If not, you'll need to install Java (TODO: Add instructions to install Java -- sad face)

Complete instructions to install Fuseki: https://jena.apache.org/documentation/serving_data/#download-fuseki1

Short instructions for Mac/Linux (if you are comfortable with the Terminal)
```
# Download Fuseki
curl http://apache.mirrors.lucidnetworks.net/jena/binaries/apache-jena-fuseki-2.6.0.tar.gz > apache-jena-fuseki-2.6.0.tar.gz
tar xvzf apache-jena-fuseki-2.6.0.tar.gz
cd apache-jena-fuseki-2.6.0
```

Start the server and name our database "testdb"
```
# On Mac/Linux
mkdir testdb
./fuseki-server --update --loc=testdb /testdb

# On Windows
mkdir testdb
fuseki-server --update --loc=testdb /testdb

# On Windows (plan B)
mkdir testdb
java -jar fuseki-server.jar
```

If Fuseki started you should see something along the lines of:

    [2017-06-01 09:53:41] Server     INFO  Running in read-only mode for /testdb
    [2017-06-01 09:53:41] Server     INFO  Fuseki 2.6.0
    ...

Leave this Terminal window running, browse to http://localhost:3030 and click on the "query" button next to the "/testdb"

Ta-da! You are ready to start submitting SPARQL queries...but we need to add some data first.


## Adding sample data
Open a new Terminal window and clone this repository (make sure to leave the window with Fuseki running open)
```
git clone https://github.com/Brown-University-Library/DiscoveryDays.git
cd DiscoveryDays/authorities_hub/
```

and then run the following command to add some demo data to yourFuseki installation:
```
curl -v -X PUT -d @./data/demo_triples.ttl -H "Content-Type: text/turtle" http://localhost:3030/testdb?default
```

Fuseki provides a Ruby script `s-put` to upload data, but this only works if you have Ruby installed on you machine:
```
bin/s-put http://localhost:3030/testdb default ./data/demo_triples.ttl
```


## Other scripts
The scripts below are meant to be run from the Terminal on your local Fuseki instance.

Select all triples:
```
curl -X POST -d @select_all.sparql http://localhost:3030/testdb/sparql

curl "http://localhost:3030/testdb/sparql?query=SELECT+?subject+?predicate+?object+WHERE+\{++?subject+?predicate+?object+\}+LIMIT+25"
```

Select all triples as a Graph, this is useful to re-import the data into Fuseki.
```
curl -X POST -d @select_all_graph.sparql http://localhost:3030/testdb/sparql
```

Delete all triples from your Fuseki instance.
```
curl -X POST -d @delete_all.sparql http://localhost:3030/testdb/update
```

Add a single triple to Fuseki (used for troubleshooting)
```
curl -v -X PUT -d @./data/simple.nt -H "Content-Type: text/turtle" http://localhost:3030/testdb?default
```

Add sample data to Fuseki:
```
curl -v -X PUT -d @./data/demo_triples.ttl -H "Content-Type: text/turtle" http://localhost:3030/testdb?default
```


## Exporting all data
To export all the data in your Fuseki installation to a Turtle file. You can use this file to import the data in a different Fuseki instance:

```
curl -H "Accept: text/turtle" -X POST -d @select_all_graph.sparql http://localhost:3030/testdb/sparql > ./data/all_triples.ttl
```
