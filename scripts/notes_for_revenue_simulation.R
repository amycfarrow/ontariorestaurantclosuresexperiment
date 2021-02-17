# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310030401&pickMembers%5B0%5D=2.1&pickMembers%5B1%5D=3.116
# there are 27,885 employers in ontario 2020.

# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310030501&pickMembers%5B0%5D=2.116
# there are 10,054 non-employers in ontario in 2020.

# so 37,939 food service businesses in 2020.




#### 2019:

# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310022201&pickMembers%5B0%5D=2.1&pickMembers%5B1%5D=3.423
# 25,836 employers

# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310022301&pickMembers%5B0%5D=2.423
# 6,968 non-employers

# So 32,804 businesses in 2019

# https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2110017101&pickMembers%5B0%5D=1.7&pickMembers%5B1%5D=2.2&cubeTimeFrame.startYear=2015&cubeTimeFrame.endYear=2019&referencePeriods=20150101%2C20190101
# full-service restaurants have 13,456,600,000 in revenue in 2019.
# https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2110017101&pickMembers%5B0%5D=1.7&pickMembers%5B1%5D=2.3&cubeTimeFrame.startYear=2015&cubeTimeFrame.endYear=2019&referencePeriods=20150101%2C20190101
# limited-service eating places have 14,082,700,000 in revenue in 2019.

# so averaging 839,510 in annual revenue.

# 69,959 average per month.

# This is including non-restaurants, presumably, because caterers would be included in "food services and drinking places"

# From http://www.mbel.io/2019/08/23/kaggle-restaurant-revenue-prediction/
# we can see the distribution looks like an F distribution, or a log normal distribution.
# rf(n, df1, df2, ncp) = rf(num_rest, 10, 5) should have a mean of 5/3
# so we would multiply by 41,975 to get the mean where we want.

# looks like 2% closed permanently: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310025001
# maybe 3%? https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310027601


# based on: https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3310023401
# can see that 1% had an increase of 10 or more
# 2% had an increase between 1 and 10
# 5% had no change
# 4% had revenue decrease 1 to 10
# 11 had revenue decrease 10 to 20
# 12 had revenue decrease 20 to 30
# 

#survey_1 <- survey_1 %>%
#mutate(revenue = 41975 * rf(num_total,10,5))

# from https://www.eater.com/2020/3/24/21184301/restaurant-industry-data-impact-covid-19-coronavirus
# revenues went from +5 to -35 when the shutdowns started. loss of -38. 
# but takeout places need -0, dine-in only places -100, and combo places the right amount to make the weighted average -38.
# then account that closures are only closed for 14 days out of 31. 

#survey_2 <- survey_2 %>%
#mutate(revenue = 34839 * rf(num_total,10,5))