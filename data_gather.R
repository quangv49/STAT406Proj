library(covidcast)

#Gathering data from Covidcast

bar_visit_prop <- covidcast_signal(data_source = "safegraph",
                                   start_day = "2021-06-05",
                                   end_day = "2021-09-05",
                                  signal = "bars_visit_prop",
                                  geo_type = "county", geo_values = "36061")

restaurant_visit_prop <- covidcast_signal(data_source = "safegraph",
                                          start_day = "2021-06-05",
                                          end_day = "2021-09-05",
                                          signal = "restaurants_visit_prop",
                                          geo_type = "county", geo_values = "36061")

mask_prop <- covidcast_signal(data_source = "fb-survey",
                              start_day = "2021-06-05",
                              end_day = "2021-09-05",
                              signal = "smoothed_wearing_mask_7d",
                              geo_type = "county", geo_values = "36061")

other_mask_prop <- covidcast_signal(data_source = "fb-survey",
                                    start_day = "2021-06-05",
                                    end_day = "2021-09-05",
                              signal = "smoothed_wothers_masked_public",
                              geo_type = "county", geo_values = "36061")

distancing <- covidcast_signal(data_source = "fb-survey",
                               start_day = "2021-06-05",
                               end_day = "2021-09-05",
                                signal = "smoothed_wothers_distanced_public",
                                geo_type = "county", geo_values = "36061")

public_transit <- covidcast_signal(data_source = "fb-survey",
                                   start_day = "2021-06-05",
                                   end_day = "2021-09-05",
                               signal = "smoothed_wpublic_transit_1d",
                               geo_type = "county", geo_values = "36061")

worked_outside <- covidcast_signal(data_source = "fb-survey",
                                   start_day = "2021-06-05",
                                   end_day = "2021-09-05",
                                signal = "smoothed_wwork_outside_home_indoors_1d",
                                geo_type = "county", geo_values = "36061")

large_events <- covidcast_signal(data_source = "fb-survey",
                                 start_day = "2021-06-05",
                                 end_day = "2021-09-05",
                                 signal = "smoothed_wlarge_event_indoors_1d",
                                 geo_type = "county", geo_values = "36061")

cases <- covidcast_signal(data_source = "indicator-combination",
                          start_day = "2021-06-05",
                          end_day = "2021-09-05",
                          signal = "confirmed_7dav_incidence_num",
                          geo_type = "county", geo_values = "36061")

#This function adds a new feature to the current dataset. It takes
#into account the fact that some feature has missing values for a
#few days
adjoin <- function(dataset, feature, feature_name) {
  match1 <- dataset$date %in% feature$time_value
  match2 <- feature$time_value %in% dataset$date
  dataset <- dataset[match1,]
  dataset <- cbind.data.frame(dataset, feature$value[match2])
  names(dataset)[1] = "date"
  names(dataset)[names(dataset)=="feature$value[match2]"] = feature_name
  
  return(dataset)
}

#Constructing dataset
dataset <- data.frame(date = distancing$time_value)

dataset <- adjoin(dataset, distancing, "distancing")
dataset <- adjoin(dataset, bar_visit_prop, "bar_visit")
dataset <- adjoin(dataset, large_events, "large_events")
dataset <- adjoin(dataset, mask_prop, "mask_prop")
dataset <- adjoin(dataset, other_mask_prop, "other_mask_prop")
dataset <- adjoin(dataset, public_transit, "public_transit")
dataset <- adjoin(dataset, restaurant_visit_prop, "resto_visit")
dataset <- adjoin(dataset, worked_outside, "worked_outside")
dataset <- adjoin(dataset, cases, "cases")

#Write to csv file
write.csv(dataset,".\\pblc_bhv_covid.csv",row.names=F)
