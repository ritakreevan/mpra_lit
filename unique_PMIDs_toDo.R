library(dplyr)
library(ggplot2)
library(data.table)


## contains all the results for all the search terms
all_search_terms = fread('/Users/rita/Documents/PhD/MPRA/MPRA_lit_review/total_list.csv'
                         ,sep=',',header=T)


## contains PMIDs for the PMIDs that have been added to google form
done_list = fread('/Users/rita/Documents/PhD/MPRA/MPRA_lit_review/done_93.csv'
                          ,sep=',',header=T)

## remove all pmIDs that have been added to goole form, 93 total
nomatch = anti_join(all_search_terms, done_list, by ="PMID")

## keep only unique pmIDs, 267 in total to add to google form
uniqe_PMID = unique(nomatch)
