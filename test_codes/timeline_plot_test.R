library(tidyverse)
library(lubridate)

Merkel <- data.frame(
  Year = c(rep(c(2018), times =12), rep(c(2019), times =2)), 
  Months = c(1,2,2,3,6,9,9,10,11,11,12,12,1,3), 
  Days = c(1,2,15,2,2,8,29,20,10,27,1,23,15,10),
  Milestones = c("Diagnosed with MCC", "PET-CT (No evidence of metastatic disease)", "WLE and SLNBx", "PET-CT (No evidence of disease)", "PET-CT (No evidence of disease)", "PET-CT (Concerning for Recurrence)", "Cycle 1", "Cycle 2", "Cycle 3","PET-CT (Partial Response)","Cycle 4", "Cycle 5",  "Cycle 6","PET-CT (Complete Response)"), 
  Event_type= c("Biopsy", "Imaging", "Surgery", "Imaging", "Imaging", "Imaging", "Immunotherapy", "Immunotherapy","Immunotherapy","Imaging","Immunotherapy", "Immunotherapy", "Immunotherapy", "Imaging")) #The data set was created with the year, month and day in separate columns. Let's add the complete date column now

Merkel$date <- with(Merkel, ymd(sprintf('%04d%02d%02d', Merkel$Year, Merkel$Months, Merkel$Days))) 
# of note, the ymd() function transforms dates stored in character and numeric vectors to Date
## we are using the code with(df, ymd(sprintf('%04d%02d%02d', year, mon, day))) to take those three columns and merge them into one that is recognized as a date in R

Merkel <- Merkel[with(Merkel, order(date)), ]
# of note, an alternate code to arrange the df in ascending date order would have been: 
## Merkel <- Merkel %>% arrange(date)

# Add a specified order to these event type labeles
Event_type_levels <- c("Biopsy", "Surgery", "Imaging", "Immunotherapy") 

# Define the colors for the event types in the specified order. 
## These hashtagged codes represent the colors (blue, green, yellow, red) as hexadecimal color codes.
Event_type_colors <- c("#C00000", "#FFC000",  "#00B050", "#0070C0" ) 


# Make the Event_type vector a factor using the levels we defined above
Merkel$Event_type <- factor(Merkel$Event_type, levels= Event_type_levels, ordered=TRUE)


# Set the heights we will use for our milestones.
positions <- c(0.5, -0.5, 1.0, -1.0, 1.25, -1.25, 1.5, -1.5) 

# Set the directions we will use for our milestone, for example above and below.
directions <- c(1, -1) 


# Assign the positions & directions to each date from those set above.
line_pos <- data.frame(
  "date"=unique(Merkel$date),
  "position"=rep(positions, length.out=length(unique(Merkel$date))),
  "direction"=rep(directions, length.out=length(unique(Merkel$date))))


# Create columns with the specified positions and directions for each milestone event
Merkel <- merge(x=Merkel, y=line_pos, by="date", all = TRUE) 

# Let's view the new columns.
kable(head(Merkel))


# Create a one month "buffer" at the start and end of the timeline
month_buffer <- 1 

month_date_range <- seq(min(Merkel$date) - months(month_buffer), max(Merkel$date) + months(month_buffer), by='month')


# We are adding one month before and one month after the earliest and latest milestone in the clinical course.
## We want the format of the months to be in the 3 letter abbreviations of each month.
month_format <- format(month_date_range, '%b') 
month_df <- data.frame(month_date_range, month_format)


year_date_range <- seq(min(Merkel$date) - months(month_buffer), max(Merkel$date) + months(month_buffer), by='year')

# We will only show the years for which we have a december to january transition.
year_date_range <- as.Date(
  intersect(
    ceiling_date(year_date_range, unit="year"),
    floor_date(year_date_range, unit="year")),  
  origin = "1970-01-01") 

# We want the format to be in the four digit format for years.
year_format <- format(year_date_range, '%Y') 
year_df <- data.frame(year_date_range, year_format)


# Create timeline coordinates with an x and y axis
timeline_plot<-ggplot(Merkel,aes(x=date,y= position, col=Event_type, label=Merkel$Milestones)) 

# Add the label Milestones
timeline_plot<-timeline_plot+labs(col="Milestones2") 

# Print plot
timeline_plot


# Assigning the colors and order to the milestones
timeline_plot<-timeline_plot+scale_color_manual(values=Event_type_colors, labels=Event_type_levels, drop = FALSE) 

# Using the classic theme to remove background gray
timeline_plot<-timeline_plot+theme_classic() 

# Plot a horizontal line at y=0 for the timeline
timeline_plot<-timeline_plot+geom_hline(yintercept=0, 
                                        color = "black", size=0.3)
# Print plot
timeline_plot


# Plot the vertical lines for our timeline's milestone events
timeline_plot<-timeline_plot+geom_segment(data=Merkel, aes(y=Merkel$position,yend=0,xend=Merkel$date), color='black', size=0.2) 


# Now let's plot the scatter points at the tips of the vertical lines and date
timeline_plot<-timeline_plot+geom_point(aes(y=Merkel$position), size=3) 

# Let's remove the axis since this is a horizontal timeline and postion the legend to the bottom
timeline_plot<-timeline_plot+theme(axis.line.y=element_blank(),
                                   axis.text.y=element_blank(),
                                   axis.title.x=element_blank(),
                                   axis.title.y=element_blank(),
                                   axis.ticks.y=element_blank(),
                                   axis.text.x =element_blank(),
                                   axis.ticks.x =element_blank(),
                                   axis.line.x =element_blank(),
                                   legend.position = "bottom"
) 
# Print plot
timeline_plot

# Let's add the text for each month
timeline_plot<-timeline_plot+geom_text(data=month_df, aes(x=month_date_range,y=-0.15,label=month_format),size=3.5,vjust=0.5, color='black', angle=90) 


# Let's add the years
timeline_plot<-timeline_plot+geom_text(data=year_df, aes(x=year_date_range,y=-0.25,label=year_format, fontface="bold"),size=3.5, color='black') 

# Print plot
print(timeline_plot)





# Lets offset the labels 0.2 away from scatter points
text_offset <- 0.2 

# Let's use the absolute value since we want to add the text_offset and increase space away from the scatter points 
absolute_value<-(abs(Merkel$position)) 
text_position<- absolute_value + text_offset

# Let's keep the direction above or below for the labels to match the scatter points
Merkel$text_position<- text_position * Merkel$direction 

# View head of the table
kable(head(Merkel))


# Now we can add the labels to the timeline for our milestones.
timeline_plot<-timeline_plot+geom_text(aes(y=Merkel$text_position,label=Merkel$Milestones),size=3.5, vjust=0.6)

# Print plot
print(timeline_plot)


# Now we can add the labels to the timeline for our milestones.
timeline_plot<-timeline_plot+geom_text(aes(y=Merkel$text_position,label=Merkel$Milestones),size=3.5, vjust=0.6)

# Print plot
print(timeline_plot)



