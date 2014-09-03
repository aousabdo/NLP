library(SPARQL)
library(ggmap)

endpoint <- "http://semanticweb.cs.vu.nl/lop/sparql/"
options <- NULL

prefix <- c("lop","http://semanticweb.cs.vu.nl/poseidon/ns/instances/",
            "eez","http://semanticweb.cs.vu.nl/poseidon/ns/eez/")

sparql_prefix <- "PREFIX sem: <http://semanticweb.cs.vu.nl/2009/11/sem/> 
                  PREFIX poseidon: <http://semanticweb.cs.vu.nl/poseidon/ns/instances/>
                  PREFIX eez: <http://semanticweb.cs.vu.nl/poseidon/ns/eez/>
                  PREFIX wgs84: <http://www.w3.org/2003/01/geo/wgs84_pos#>
                  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
"

q <- paste(sparql_prefix,
           "SELECT *
   WHERE {
     ?event sem:hasPlace ?place .
     ?place eez:inPiracyRegion ?region .
   }")

res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results

print(head(res))

count_per_region <- table(res$region)
sorted_counts <- sort(count_per_region)

print(sorted_counts)

pie(sorted_counts, col=rainbow(12))


####
q <- paste(sparql_prefix,
           "SELECT *
   WHERE {
     ?event sem:eventType ?event_type .
     ?event sem:hasPlace ?place .
     ?place eez:inPiracyRegion ?region .
   }")
res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results

event_region_table <- table(res$event_type,res$region)

par(mar=c(4,10,1,1))
barplot(event_region_table, col=rainbow(10), horiz=TRUE, las=1, cex.names=0.8)
legend("topright", rownames(event_region_table),
       cex=0.8, bty="n", fill=rainbow(10))


q <- paste(sparql_prefix,
           "SELECT *
   WHERE {
     ?event sem:eventType ?event_type .
     ?event sem:hasPlace ?place .
     ?place wgs84:lat ?lat .
     ?place wgs84:long ?long .
   }")
res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results

qmap('Gulf of Aden', zoom=2) +
        geom_point(aes(x=long, y=lat, colour=event_type), data=res) +
        scale_color_manual(values = rainbow(10))
