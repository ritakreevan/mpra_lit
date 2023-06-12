## mpra_lit_upsetplot.r
## used to see how many article overlaps with different search terms in pubmed
## pubmed search conducted 01.06.2023
## terms used: massively parallel reporter assay, massively parallel reporter assays
## mpra, "massively parallel reporter assay", "massively parallel reporter assays", "mpra"
## downloaded csv files

library(ComplexHeatmap)
library(data.table)
library(magrittr)
library(workflowr)

wflow_git_config(user.name = "ritakreevan", user.email = "rita.kreevan@gmail.com")
wflow_start("mpra_lit")
wflow_build()

## mpra.csv contains all the PMIDs for differen search tearms
mpra_data = fread('/Users/rita/Documents/PhD/MPRA/MPRA_lit_review/mpra.csv',sep=',',header=T)
mpra_data = as.matrix(mpra_data)
pubmedIDs = c(
  "Massively parellel reporter assay",
  "Massively parellel reporter assays",
  "MPRA",
  "Massively parellel reporter assay WQ",
  "Massively parellel reporter assays WQ",
  "MPRA WQ"
)

## use a "for" loop to store each column of matrix as a single vector in a list
listCols = list()
for( c in 1:ncol(mpra_data)){
  col = mpra_data[,c]
  listCols[[c]] = as.character(col)%>%na.omit()
}
## assign the pubmed IDs as names the set
names(listCols)  = pubmedIDs

## create a binary matrix with presence/absence of elements across sets
binary_mat = list_to_matrix(listCols)

## create combination matrix (input for the upset plot function)
combination_mat =  make_comb_mat(binary_mat,mode='distinct')

## define a set of colors for your pubmed IDs
set_palette = c(
  "violetred4",
  'turquoise4',
  'slateblue4',
  'wheat4',
  '#2a9d8f',
  '#f4a261'
)
names(set_palette) = pubmedIDs

## upset plot
pdf('/Users/rita/Documents/PhD/MPRA/MPRA_lit_review/mpra_rita_out.pdf',width=10,height=7)
UpSet(
  combination_mat,
  pt_size = unit(5, "mm"), ## controls the size of the dots
  lwd = 3, ## controls the width of the line

  top_annotation = upset_top_annotation(
    combination_mat,
    add_numbers = TRUE  ## adds number on top bars
  ),
  right_annotation = upset_right_annotation(
    combination_mat,
    add_numbers = TRUE, ## adds number on right of bars
    gp = gpar(fill = set_palette)
  )
)
dev.off()
