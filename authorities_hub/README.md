# Linked Data Authorities
Instructions on how to get started for the *Linked Data Authorities* hackathon at Brown University as part of Discovery Days (June/2017)

    Channel B: Linked Data Authorities (data provided) — leveraging authorities
    to provide users with another robust method for exploring our data and
    finding materials of interest - https://library.brown.edu/create/discoveryday/agenda/

We'll have a public Fuseki endpoint available during the hackathon so you don't have to download or install Fuseki.

The URL for the public endpoint is http://to-be-determined:3030/dataset.html?tab=query&ds=/testdb

If you have access to this endpoint you can just execute the *Sample Queries* indicated below. If not, take a look at the [Fuseki document](https://github.com/Brown-University-Library/DiscoveryDays/blob/master/authorities_hub/fuseki.md) for instructions on how to install Fuseki in your machine and populate it with the demo data before executing the Sample queries below.


## Sample Queries
[This spreadsheet](https://docs.google.com/spreadsheets/d/1LOkagwolY_bzn1shNTTQ7HbK87nhxAyl5wb36sJU6eU/edit?usp=sharing) has a list of the names included in the sample data.

To run the queries go to http://to-be-determined:3030/dataset.html?tab=query&ds=/testdb and use the following SPARQL queries to navigate through the information:

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
