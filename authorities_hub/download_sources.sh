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
