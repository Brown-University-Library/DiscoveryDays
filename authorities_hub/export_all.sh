# exports all data as a Graph 
curl -H "Accept: text/turtle" \
  -X POST \
  -d @select_all_graph.sparql http://localhost:3030/testdb/sparql
