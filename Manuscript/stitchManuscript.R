library( rmarkdown )

stitchedFile <- "stitched.Rmd";

formatFile <- "format.Rmd"

rmdFiles <- c( formatFile,
               "titlePage.Rmd",
               "abstract.Rmd",
               "intro.Rmd",
               "preliminaries.Rmd",
               "imageRegistrationDeepLearning.Rmd",
               "imageRegistrationFeatureMethods.Rmd",
               "imageRegistrationTwoChannelMethods.Rmd",
               "imageRegistrationSiameseMethods.Rmd",
               "imageRegistrationAdverserialMethods.Rmd",
               "imageRegistrationOtherMethods.Rmd",
               "discussion.Rmd",
               "acknowledgments.Rmd",
               "references.Rmd"
   )

# Figure ideas:
#  * pubmed query showing citations of image registration vs.
#     image segmentation vs. image classification
#  * Convolutional neural network
#  * spatial transformer network diagram
#


for( i in 1:length( rmdFiles ) )
  {
  if( i == 1 )
    {
    cmd <- paste( "cat", rmdFiles[i], ">", stitchedFile )
    } else {
    cmd <- paste( "cat", rmdFiles[i], ">>", stitchedFile )
    }
  system( cmd )
  }

cat( '\n Pandoc rendering', stitchedFile, '\n' )
render( stitchedFile, output_format = c( "pdf_document" ) )
