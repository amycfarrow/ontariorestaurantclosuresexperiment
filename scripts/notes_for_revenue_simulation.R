# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310030401&pickMembers%5B0%5D=2.1&pickMembers%5B1%5D=3.116
# there are 27,885 employers in ontario 2020.

# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310030501&pickMembers%5B0%5D=2.116
# there are 10,054 non-employers in ontario in 2020.

# so 37,939 food service businesses in 2020.




#### 2019:

# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310022201&pickMembers%5B0%5D=2.1&pickMembers%5B1%5D=3.116
# 27,985 employers

# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3310022301&pickMembers%5B0%5D=2.116
# 9,508 non-employers

# So 37,493 businesses in 2019

# From https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2110017101&pickMembers%5B0%5D=1.7&pickMembers%5B1%5D=2.1&cubeTimeFrame.startYear=2015&cubeTimeFrame.endYear=2019&referencePeriods=20150101%2C20190101
# there is 30,999,300,000 in revenue in 2019.

# so averaging 826,802 in annual revenue.

# 68,900 average per month.

# This is including non-restaurants, presumably, because caterers would be included in "food services and drinking places"

# From http://www.mbel.io/2019/08/23/kaggle-restaurant-revenue-prediction/
# we can see the distribution looks like an F distribution, or a log normal distribution.
# rf(n, df1, df2, ncp) = rf(num_rest, 10, 5) should have a mean of 5/3
# so we would multiply by 41,340 to get the mean where we want.

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
#mutate(revenue = 41340 * rf(num_total,10,5))