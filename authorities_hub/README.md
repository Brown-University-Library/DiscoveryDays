# Linked Data Authorities

Instructions on how to get started for the *Linked Data Authorities* hackathon at Brown University as part of Discovery Days (June/2017)

    Channel B: Linked Data Authorities (data provided) — leveraging authorities
    to provide users with another robust method for exploring our data and
    finding materials of interest - https://library.brown.edu/create/discoveryday/agenda/


## Clone this repository
To clone this repo from the Terminal

```
git clone https://github.com/Brown-University-Library/DiscoveryDays.git
cd DiscoveryDays/authorities_hub/
```


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
Open a new Terminal window, navigate to the folder where you cloned this Git repository and run the following command to add some demo data to you Fuseki installation:
```
curl -v -X PUT -d @demo_triples.ttl -H "Content-Type: text/turtle" http://localhost:3030/testdb?default
```

Fuseki provides a Ruby script `s-put` to upload data, but this only works if you have Ruby installed on you machine:
```
bin/s-put http://localhost:3030/testdb default demo_triples.ttl
```


## Queries

Go to http://TBD:3030/dataset.html?tab=query&ds=/testdb and use the following SPARQL queries to navigate through the information:

All people in our data set
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?s
WHERE {
  ?s rdf:type <http://schema.org/Person> .
}
```

Everything we know about Adam Smith from VIAF
```
SELECT ?p ?o
WHERE {
  <http://viaf.org/viaf/49231791> ?p ?o .
}
```

Data for other resources marked as SameAs Adam Smith
```
SELECT ?sa ?p ?o
WHERE {
  <http://viaf.org/viaf/49231791> <http://schema.org/sameAs> ?sa .
  ?sa ?p ?o .
}
```

Other resources that are SameAs our VIAF Adam Smith
```
SELECT DISTINCT ?sa
WHERE {
  <http://viaf.org/viaf/49231791> <http://schema.org/sameAs> ?sa .
  ?sa a ?o
}
```


Dealing with strings in multiple languages
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?s ?label
WHERE {
  ?s rdf:type <http://schema.org/Person> .
  optional {
    ?s <http://www.w3.org/2004/02/skos/core#prefLabel> ?label .
    FILTER langMatches( lang(?label), "en-US" )
  }
  optional {
    ?s rdfs:label ?label .
    FILTER langMatches( lang(?label), "en" )
  }   
}
```


## Other scripts

The scripts below are meant to be run from the Terminal on your local Fusek instance.

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
curl -v -X PUT -d @simple.nt -H "Content-Type: text/turtle" http://localhost:3030/testdb?default
```

Add sample data to Fuseki:
```
curl -v -X PUT -d @demo_triples.ttl -H "Content-Type: text/turtle" http://localhost:3030/testdb?default
```


## Exporting all data
To export all the data in your Fuseki installation to a Turtle file. You can use this file to import the data in a different Fuseki instance:

```
curl -H "Accept: text/turtle" -X POST -d @select_all_graph.sparql http://localhost:3030/testdb/sparql > all_triples.ttl
```


## Where to find more information

**Christina Harlow's Code4Lib 2015 talk "Get Your Recon"**
http://2016.code4lib.org/Get-Your-Recon

Talks about the problems of doing matching records to authority records at
a massive scale (e.g. hundreds of thousands names). Also addresses the process
of assigning a "score" when a match is found to decide if further review is needed
before accepting the match.


**Ted Lawless's Code4Lib 2015 talk "Build your own identity hub"**
http://2016.code4lib.org/Build-your-own-identity-hub

Talks about the idea of creating small identity hubs for apps inside our
organizations (limited in scope) and focus on important collections. Have our apps
connect to this central hub and reduce silos within the organization. Then publish
this data as Linked Data Fragments for other to take advantage of.


**Linked Data Fragments**
http://linkeddatafragments.org/

Given that Linked Data can be daunting to implement (to large in scope) Ruben Verborgh
and others are suggesting a middle of the road approach. Something between data dumps
(low tech) and full SPARQL end-points (high tech) that they call "Linked Data Fragment"


    Linked Data Fragments is a conceptual framework that provides a uniform view on
    all possible interfaces to RDF, by observing that each interface partitions a
    dataset into its own specific kind of fragments. http://linkeddatafragments.org/concept/

    A Linked Data Fragment (LDF) of a Linked Data dataset is a resource consisting of
    those triples of this dataset that match a specific selector, together with
    metadata and hypermedia controls. http://linkeddatafragments.org/in-depth/

This short video (15 min) is a good introduction: http://videolectures.net/iswc2014_verborgh_querying_datasets/

They provide a server that you can use to host the data locally (and make it
available to others too?). They claim that although their throughput is a bit slow
it is constant (i.e. it does not slow down more as the number of clients grows)

They handle things like pagination to allow the streaming of the data to the
clients.


**Book: Linked Data for Libraries, Archives and Museums**
By Seth van Hooland and Ruben Verborgh
http://freeyourmetadata.org/

On the Reconciliation chapter the authors present a relatively simple approach to leverage traditional controlled vocabularies (classification schemes, subject headings, and thesauri) in the context of Linked Data. The basic approach is a low-cost blend of string matching and SKOS (Simple Knowledge Organization System) that they have used and gave them good results. They contrast this with large and expensive initiatives to create full blown ontologies.
