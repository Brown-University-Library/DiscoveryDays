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


All people in our data set (partial)
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?s
WHERE {
  ?s rdf:type <http://schema.org/Person> .
}
# Result should include about 10 IDs
```


All people in our dataset. Notice that we account for different predicates to indicate a person (LOC uses PersonalName while dbPedia and VIAF use Person)
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?s
WHERE {
  { ?s rdf:type <http://www.loc.gov/mads/rdf/v1#PersonalName> . }
  UNION
  { ?s rdf:type <http://schema.org/Person> . }
  FILTER (!isBlank(?s))
}
# Result should include about 18 IDs
```


Everything we know about for Adam Smith (VIAF URI http://viaf.org/viaf/49231791)
in our dataset
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?p ?o
WHERE {
  <http://viaf.org/viaf/49231791> ?p ?o .
  FILTER (!isBlank(?o))
}
```


What other resources in our dataset represent the same Adam Smith
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT distinct ?sa  
WHERE {
  <http://viaf.org/viaf/49231791> <http://schema.org/sameAs> ?sa .
  # this second pattern it used to filter to only resources in our dataset
  ?sa rdf:type ?t .
}

# Result should be something like
# <http://dbpedia.org/resource/Adam_Smith>
# <http://id.loc.gov/authorities/names/n80032761> .
```


Everything we know about Adam Smith in our dataset from all sources (i.e. including the data from the sameAs resources)
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?s ?p ?o  
WHERE {
  {
    # Data from VIAF
    BIND( <http://viaf.org/viaf/49231791> as ?s )
    ?s ?p ?o .
  }
  UNION {
    # Data from other sources that VIAF says is the sameAs
    <http://viaf.org/viaf/49231791> <http://schema.org/sameAs> ?s .
    ?s ?p ?o .
  }
}
```


## More queries

Find all the predicates in our dataset
```
SELECT distinct ?p
WHERE {
  ?s ?p ?o .
}
```


All predicates that might represent people entities
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT distinct ?o
WHERE {
  ?s rdf:type ?o .
  FILTER regex(str(?o), "Person") .
}

# Returns something like
# http://www.loc.gov/mads/rdf/v1#PersonalName
# http://id.loc.gov/ontologies/bibframe/Person
# http://xmlns.com/foaf/0.1/Person
# http://schema.org/Person
# http://dbpedia.org/class/yago/Person100007846
# http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#NaturalPerson
# http://dbpedia.org/ontology/Person
```


All people in our dataset from the Library of Congress
```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?s ?p ?o  
WHERE {
  ?s rdf:type <http://www.loc.gov/mads/rdf/v1#PersonalName> .
  FILTER (!isBlank(?s))
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


## Quick and dirty demos

File **demo.rb** is an example of a Ruby program that connects to Fuseki and dumps the results to the console.

File **demo.html** is an example of a web page that connects to Fuseki via JavaScript and dumps the result to the page.


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
