echo "Downloading Adam Smith..."
curl http://viaf.org/viaf/49231791/rdf.xml > adam_smith_viaf.xml
# VIAF sameAs points to http://dbpedia.org/page/Adam_Smith
# adjust the URI to point to the ntriples representation
curl http://dbpedia.org/data/Adam_Smith.ntriples > adam_smith_dbpedia.nt
curl http://id.loc.gov/authorities/names/n80032761.rdf > adam_smith_loc.xml

echo "Downloading Robert Burns..."
curl http://viaf.org/viaf/32012434/rdf.xml > robert_burns_viaf.xml
curl http://dbpedia.org/data/Robert_Burns.ntriples > robert_burns_dbpedia.nt
curl http://id.loc.gov/authorities/names/n78088009.rdf > robert_burns_loc.xml

echo "Downloading Robert Fergusson"
curl http://viaf.org/viaf/32790622/rdf.xml > robert_fergusson_viaf.xml
curl http://dbpedia.org/data/Robert_Fergusson.rdf.ntriples > robert_fergusson_dbpedia.nt
curl http://id.loc.gov/authorities/names/n50026891.rdf > robert_fergusson_loc.xml

echo "Downloading James Joyce"
curl http://viaf.org/viaf/44300643/rdf.xml > james_joyce_viaf.xml
curl http://dbpedia.org/data/James_Joyce.rdf.ntriples > james_joyce_dbpedia.nt
curl http://id.loc.gov/authorities/names/n79056824.rdf > james_joyce_loc.xml

echo "Downloading Mary Shelley"
curl http://viaf.org/viaf/6293/rdf.xml > mary_shelley_viaf.xml
curl http://dbpedia.org/data/Mary_Shelley.rdf.ntriples > mary_shelley_dbpedia.nt
curl http://id.loc.gov/authorities/names/n79061063.rdf > mary_shelley_loc.xml
curl http://viaf.org/viaf/48022241/rdf.xml > mary_shelley2_viaf.xml
curl http://id.loc.gov/authorities/names/n78059960.rdf > mary_shelley2_loc.xml

echo "Downloading Miguel de Cervantes"
curl http://viaf.org/viaf/17220427/rdf.xml > miguel_cervantes_viaf.xml
curl http://dbpedia.org/data/Miguel_de_Cervantes.rdf.ntriples > miguel_cervantes_dbpedia.nt
curl http://id.loc.gov/authorities/names/n79100233.rdf > miguel_cervantes_loc.xml
curl http://viaf.org/viaf/100385664/rdf.xml > miguel_cervantes2_viaf.xml
curl http://id.loc.gov/authorities/names/n92020427.rdf > miguel_cervantes2_loc.xml
