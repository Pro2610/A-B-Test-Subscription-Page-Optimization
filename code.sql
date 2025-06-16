Conversion Rate								
SELECT								
`group` AS test_group,								
COUNTIF(viewed_sub_page) AS views,								
COUNTIF(subscribed) AS subscriptions,								
ROUND(COUNTIF(subscribed) * 1.0 / COUNTIF(viewed_sub_page), 4) AS conversion_rate								
FROM								
`testpro-458914.ab_test.subscription_test_data`								
GROUP BY								
test_group;								
								
ARPU (Average Revenue Per User)								
SELECT								
`group` AS test_group,								
ROUND(SUM(subscription_amount) / COUNT(user_id), 4) AS ARPU								
FROM								
`testpro-458914.ab_test.subscription_test_data`								
GROUP BY								
test_group;								
								
Revenue per Subscriber								
SELECT								
`group` AS test_group,								
COUNTIF(subscribed) AS total_subscribers,								
ROUND(SUM(subscription_amount) / COUNTIF(subscribed), 4) AS revenue_per_subscriber								
FROM								
`testpro-458914.ab_test.subscription_test_data`								
GROUP BY								
test_group;								
								
Dynamics by day: number of subscriptions in A and B								
SELECT								
session_date,								
`group` AS test_group,								
COUNTIF(subscribed) AS subscriptions								
FROM								
`testpro-458914.ab_test.subscription_test_data`								
GROUP BY								
session_date, test_group								
ORDER BY								
session_date, test_group;								
								
t-test for statistical significance								
WITH conversion_data AS (								
SELECT								
`group`,								
COUNTIF(viewed_sub_page) AS views,								
COUNTIF(subscribed) AS conversions,								
COUNTIF(subscribed) * 1.0 / COUNTIF(viewed_sub_page) AS conversion_rate								
FROM								
`testpro-458914.ab_test.subscription_test_data`								
GROUP BY								
`group`								
),								
								
group_stats AS (								
SELECT								
MAX(CASE WHEN `group` = 'A' THEN conversion_rate END) AS conv_a,								
MAX(CASE WHEN `group` = 'B' THEN conversion_rate END) AS conv_b,								
MAX(CASE WHEN `group` = 'A' THEN views END) AS n_a,								
MAX(CASE WHEN `group` = 'B' THEN views END) AS n_b								
FROM conversion_data								
)								
								
SELECT								
conv_a,								
conv_b,								
n_a,								
n_b,								
ROUND( (conv_b - conv_a) / SQRT( (conv_a * (1 - conv_a)) / n_a + (conv_b * (1 - conv_b)) / n_b ), 4 ) AS t_statistic								
FROM								
group_stats;								
								
								
