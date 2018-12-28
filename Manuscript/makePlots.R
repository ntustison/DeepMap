library( ggplot2 )
library( ggthemes )
library( scales )
library( dplyr )

library( RColorBrewer )

deepMapBrief <- read.csv( "./DeepMapBrief.csv" )

## Make publishing year histogram

yearPlot <- ggplot( deepMapBrief, aes( YearPublished ) ) +
  geom_bar( aes( fill = factor( YearPublished ) ) ) +
  ggtitle( "Publications per year" ) +
  scale_y_continuous( "Count", breaks = seq( 0, 12, by = 2 ), labels = seq( 0, 12, by = 2 ) ) +
  scale_fill_brewer( palette = "Spectral" ) +
  theme_wsj( color = "white" ) +
  theme( legend.position = "none" )

ggsave( yearPlot, filename = paste0( './Figures/yearPlot.pdf' ),
  width = 6, height = 8, units = 'in' )

## Make publishing venue histogram

getPalette <- colorRampPalette( brewer.pal( 8, "Spectral" ) )
numberOfVenues <- length( unique( deepMapBrief$Venue ) )

venuePlot <- ggplot( deepMapBrief, aes( Venue ) ) +
  geom_bar( aes( fill = factor( Venue ) ) ) +
  ggtitle( "Publishing venue" ) +
  scale_y_continuous( "Count" ) +
  scale_fill_manual( values = getPalette( numberOfVenues ) ) +
  theme_wsj( color = "white" ) +
  theme( legend.position = "none",
         axis.text.x = element_text( angle = 45, hjust = 1 )
       )

ggsave( venuePlot, filename = paste0( './Figures/venuePlot.pdf' ),
  width = 12, height = 4, units = 'in' )

## Make anatomy histogram

anatomy <- c()
for( i in 1:length( deepMapBrief$Anatomy ) )
  {
  if( is.na( deepMapBrief$Anatomy[i] ) )
    {
    next
    }
  if( grepl( '_', deepMapBrief$Anatomy[i] ) )
    {
    tokens <- unlist( strsplit( deepMapBrief$Anatomy[i], '_' ) )
    anatomy <- append( anatomy, c( tokens ) )
    } else {
    anatomy <- append( anatomy, deepMapBrief$Anatomy[i] )
    }
  }
anatomy[is.na( anatomy )] <- 'None'

anatomyDataFrame <- data.frame( Anatomy = as.factor( anatomy ) )
anatomyDataFrame$Anatomy <- factor( anatomyDataFrame$Anatomy,
  levels = rev( c( 'Abdomen', 'Brain', 'Heart', 'Knee', 'Liver', 'Lungs', 'Pelvis', 'Prostate', 'Retina' ) ) )

anatomyPlot <- ggplot( anatomyDataFrame, aes( x = Anatomy ) ) +
  geom_bar( aes( fill = Anatomy ) ) +
  coord_flip() +
  ggtitle( "Anatomy" ) +
  scale_y_continuous( "Count" ) +
  scale_fill_brewer( "", palette = "Spectral" ) +
  theme_wsj( color = "white" )  +
  theme( legend.position = "none" )

ggsave( anatomyPlot, filename = paste0( './Figures/anatomyPlot.pdf' ),
  width = 10, height = 5, units = 'in' )


## Make pie chart

apiDataFrame <- data.frame( API = deepMapBrief$DeepLearningPlatform )
apiDataFrame <- apiDataFrame %>%
  group_by( API ) %>%
  count() %>%
  ungroup() %>%
  mutate( per = `n`/sum( `n` ) ) %>%
  arrange( desc( API ) )
apiDataFrame$label <- scales::percent( apiDataFrame$per )

apiPlot <- ggplot( apiDataFrame, aes( x = factor( 1 ), fill = API ) ) +
  geom_bar( aes( x = "", y = per, fill = API ), stat = "identity" , width = 1 ) +
  ggtitle( "Neural network API" ) +
  coord_polar( "y" ) +
  ylab( "" ) +
  xlab( "" ) +
  scale_fill_brewer( "", palette = "Spectral" ) +
  theme_wsj( color = "white" ) +
  theme( legend.text = element_text( size = 15 ),
         axis.text.x = element_blank(),
         axis.ticks = element_blank(),
         panel.grid = element_blank(),
         panel.border = element_blank() ) +
  geom_text( aes( x = 1, y = cumsum( per ) - per/2, label = label ), size = 8 )

ggsave( apiPlot, filename = paste0( './Figures/apiPlot.pdf' ),
  width = 7, height = 9, units = 'in' )
