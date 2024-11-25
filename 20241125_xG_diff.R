# install.packages("devtools")
devtools::install_github("JaseZiv/worldfootballR")

# install essential libraries
library(worldfootballR)
library(dplyr)
library(ggplot2)

# get shooting data from fbref
serie_a_shooting <- fb_season_team_stats(country = "ITA", gender = "M", season_end_year = "2025", tier = "1st", stat_type = "shooting")
dplyr::glimpse(serie_a_shooting)

# new column for goals - xG, to see xG difference
serie_a_shooting$xG_diff <- serie_a_shooting$Gls_Standard - serie_a_shooting$xG_Expected

# view dataframe - check new column seems present and correct!
View(serie_a_shooting)

# want to also look at xG against - to plot biggest under and over performers on each side of the ball
serie_a_league_table <- fb_season_team_stats(country = "ITA", gender = "M", season_end_year = "2025", tier = "1st", stat_type = "league_table")
dplyr::glimpse(serie_a_league_table)

# new column for goals against - xG, to see xG against difference
serie_a_league_table$xG_diff_against <- serie_a_league_table$GA - serie_a_league_table$xGA

# view dataframe - check new second new column seems present and correct!
View(serie_a_league_table)

# merge data
df <- merge(serie_a_league_table, serie_a_shooting, by = "Squad")


# colour key for serie a teams
team_colors <- c("Atalanta" = "darkblue", "Bologna" = "red", "Cagliari" = "blue","Como" ="darkblue", "Empoli" = "blue",
                 "Fiorentina" = "purple",  "Genoa" = "red", "Hellas Verona" = "darkblue", "Inter" = "blue", 
                 "Juventus" = "black", "Lazio" = "skyblue", "Lecce" = "yellow", 
                 "Milan" = "red", "Monza" = "red", "Napoli" = "lightblue", "Parma"= "yellow",
                 "Roma" = "orange", "Spezia" = "black", "Torino" = "maroon",
                 "Udinese" = "black")


# Plot with ggplot
ggplot(df, aes(x = xG_diff_against, y = xG_diff, color = Squad)) +
  geom_point(size = 3) +  # Plot the points
  scale_color_manual(values = team_colors) +  # Apply custom colors
  geom_text(aes(label = Squad), vjust = -1, hjust = 1, size = 3) +  # Add labels for each point
  labs(title = "xG Difference Against vs xG Difference (Serie A 2024-2025, up to 25/11/24)",
       x = "xG Difference Against", y = "xG Difference") +
  theme_minimal() +  # Clean theme
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels for readability
    legend.position = "none"  # Remove the legend
  ) +
  # Add horizontal line at y = 0
  geom_hline(yintercept = 0, color = "black", size = 1.2, linetype = "dashed") +
  # Add vertical line at x = 0
  geom_vline(xintercept = 0, color = "black", size = 1.2, linetype = "dashed") +
  # Reverse the x-axis
  scale_x_reverse() +
  # Add text annotations for quadrant explanations
  annotate("text", x = -5, y = 5, label = "Over performing attack & defence", color = "grey", size = 4, hjust = 1) +  # Top right
  annotate("text", x = -5, y = -5, label = "Under performing attack & over performing defence", color = "grey", size = 4, hjust = 1) +  # Bottom right
  annotate("text", x = 5, y = 5, label = "Over performing attack, & under performing defence", color = "grey", size = 4, hjust = 0) +  # Top left
  annotate("text", x = 5, y = -5, label = "Under performing attack & under performing defence", color = "grey", size = 4, hjust = 0)  # Bottom left


