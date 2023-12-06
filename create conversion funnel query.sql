-- Importing MavenFuzzyFactory library (hypothetical) for potential use in the script
use mavenfuzzyfactory;

-- Selecting relevant metrics for conversion rates by different sources and campaigns
select 
    year(website_sessions.created_at) as y,  -- Extracting the year from the session creation timestamp
    quarter(website_sessions.created_at) as q,  -- Extracting the quarter from the session creation timestamp

    -- Calculating conversion rate for sessions from 'gsearch' with 'nonbrand' campaign
    count(distinct case when website_sessions.utm_source = 'gsearch' and website_sessions.utm_campaign = 'nonbrand' then orders.order_id else null end) /
    count(distinct case when website_sessions.utm_source = 'gsearch' and website_sessions.utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as gsearch_nonbrand_conv_rate,

    -- Calculating conversion rate for sessions from 'bsearch' with 'nonbrand' campaign
    count(distinct case when website_sessions.utm_source = 'bsearch' and website_sessions.utm_campaign = 'nonbrand' then orders.order_id else null end) /
    count(distinct case when website_sessions.utm_source = 'bsearch' and website_sessions.utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as bsearch_nonbrand_conv_rate,

    -- Calculating conversion rate for sessions with 'brand' campaign
    count(distinct case when  website_sessions.utm_campaign = 'brand' then orders.order_id else null end) / 
    count(distinct case when  website_sessions.utm_campaign = 'brand' then website_sessions.website_session_id else null end) as brand_conv_rate,

    -- Calculating conversion rate for sessions with null 'utm_source' and non-null 'http_referer'
    count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is not null then orders.order_id else null end) /
    count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is not null then website_sessions.website_session_id else null end) as organic_conv_rate,

    -- Calculating conversion rate for sessions with null 'utm_source' and null 'http_referer'
    count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is null then orders.order_id else null end) /
    count(distinct case when website_sessions.utm_source is null and website_sessions.http_referer is null then website_sessions.website_session_id else null end) as direct_type_conv_rate

from website_sessions
left join orders
on orders.website_session_id = website_sessions.website_session_id 

-- Filtering sessions created before the year 2015
where year(website_sessions.created_at) < '2015'

-- Grouping results by year and quarter
group by 1,2;
