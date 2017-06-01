## Discovery Days
Announcement

    Channel B: Linked Data Authorities (data provided) — leveraging authorities
    to provide users with another robust method for exploring our data and
    finding materials of interest - https://library.brown.edu/create/discoveryday/agenda/

## Download and install Fuseki

Pre-requisites. Fuseki requires Java to be installed on your machine. To verify that you have
Java installed on your box issue the following command from the Terminal

```
java -version
```

You should see something along the lines of "java version 1.8.0_91"

Complete instructions to install Fuseki: https://jena.apache.org/documentation/serving_data/#download-fuseki1

Short instructions (if you are comfortable with the Terminal)
```
# Download Fuseki
curl http://apache.mirrors.lucidnetworks.net/jena/binaries/apache-jena-fuseki-2.6.0.zip > apache-jena-fuseki-2.6.0.zip
unzip apache-jena-fuseki-2.6.0
cd apache-jena-fuseki-2.6.0
```

Start the server and name our database "testdb"
```
./fuseki-server --update --loc=./testdb /testdb
```

Go to http://localhost:3030 and click on the "query" button next to the "/testdb"


## Adding sample data
TODO: How do we make the data available to people? Put it on a GitHub repo and have them cURL it?

Run the following from a *new* Terminal window: (I think this only works if you have Ruby)

```
bin/s-put http://localhost:3030/testdb default ~/dev/discoday/adam_smith_dbpedia.nt
```

Or with CURL
```
curl -X POST -d @select_all.sparql http://localhost:3030/testdb/sparql


curl -X POST -d @select_all_graph.sparql http://localhost:3030/testdb/sparql

curl -X POST -d @delete_all.sparql http://localhost:3030/testdb/update

curl -v -X PUT -d @simple.nt -H "Content-Type: text/turtle" http://localhost:3030/testdb?default

curl -v -X PUT -d @adam_smith_dbpedia.nt -H "Content-Type: text/turtle" http://localhost:3030/testdb?default

curl -v -X PUT -d @x.nt -H "Content-Type: text/turtle" http://localhost:3030/testdb?default

```

## Queries

All people in our data set
```
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
SELECT ?s ?label
WHERE {
  ?s rdf:type <http://schema.org/Person> .
  optional {
    ?s <http://www.w3.org/2004/02/skos/core#prefLabel> ?label .
    FILTER langMatches( lang(?label), "en" )
  }
  optional {
    ?s rdfs:label ?label .
    FILTER langMatches( lang(?label), "en" )
  }   
}
```

## Exporting all data
```

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
