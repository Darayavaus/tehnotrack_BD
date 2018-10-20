use tehnotrack_db;

-- WAU

with recursive timeslice as
(
    select min(cast(begin_dttm as date)) as dt from sessions
        union all
	select dt + interval 1 week
		from timeslice
		where dt + interval 1 week <= (select max(cast(begin_dttm as date)) from sessions)
)
	select timeslice.dt as week, count(distinct user_id) as wau
        from timeslice left join sessions on 
			cast(begin_dttm as date) >= timeslice.dt
            and
            cast(begin_dttm as date) < (timeslice.dt + interval 1 week)
 	group by week
 	order by week;
    
-- WAU result:

-- +------------+-----+
-- | week       | wau |
-- +------------+-----+
-- | 2018-08-02 |   6 |
-- | 2018-08-09 |  11 |
-- | 2018-08-16 |  17 |
-- | 2018-08-23 |  22 |
-- | 2018-08-30 |  30 |
-- | 2018-09-06 |  35 |
-- | 2018-09-13 |  41 |
-- | 2018-09-20 |  49 |
-- | 2018-09-27 |  51 |
-- +------------+-----+

-- PPU
 
with recursive timeslice as (
    select min(cast(begin_dttm as date)) as dt from sessions
        union all
	select dt + interval 1 day
		from timeslice
		where dt + interval 1 day <= (select max(cast(begin_dttm as date)) from sessions)
), 
pu as (
	select timeslice.dt as day, count(distinct user_id) as cnt
		from timeslice left join payments on timeslice.dt = cast(payments.payment_dttm as date)
			group by timeslice.dt
),
dau as (
	select timeslice.dt as day, count(distinct user_id) as cnt
		from timeslice left join sessions on timeslice.dt = cast(sessions.begin_dttm as date)
			group by timeslice.dt
)
	select pu.day, round(coalesce(pu.cnt, 0) / coalesce(dau.cnt, 1), 2) as ppu
		from dau left join pu on dau.day = pu.day;
		
-- PPU result

-- +------------+------+
-- | day        | ppu  |
-- +------------+------+
-- | 2018-08-02 | 0.00 |
-- | 2018-08-03 | 0.00 |
-- | 2018-08-04 | 0.00 |
-- | 2018-08-05 | 0.00 |
-- | 2018-08-06 | 0.00 |
-- | 2018-08-07 | 0.50 |
-- | 2018-08-08 | 0.00 |
-- | 2018-08-09 | 0.00 |
-- | 2018-08-10 | 0.20 |
-- | 2018-08-11 | 0.40 |
-- | 2018-08-12 | 0.17 |
-- | 2018-08-13 | 0.17 |
-- | 2018-08-14 | 0.22 |
-- | 2018-08-15 | 0.67 |
-- | 2018-08-16 | 0.09 |
-- | 2018-08-17 | 0.29 |
-- | 2018-08-18 | 0.08 |
-- | 2018-08-19 | 0.14 |
-- | 2018-08-20 | 0.13 |
-- | 2018-08-21 | 0.10 |
-- | 2018-08-22 | 0.00 |
-- | 2018-08-23 | 0.13 |
-- | 2018-08-24 | 0.29 |
-- | 2018-08-25 | 0.15 |
-- | 2018-08-26 | 0.00 |
-- | 2018-08-27 | 0.36 |
-- | 2018-08-28 | 0.25 |
-- | 2018-08-29 | 0.07 |
-- | 2018-08-30 | 0.21 |
-- | 2018-08-31 | 0.18 |
-- | 2018-09-01 | 0.22 |
-- | 2018-09-02 | 0.10 |
-- | 2018-09-03 | 0.00 |
-- | 2018-09-04 | 0.13 |
-- | 2018-09-05 | 0.06 |
-- | 2018-09-06 | 0.17 |
-- | 2018-09-07 | 0.08 |
-- | 2018-09-08 | 0.25 |
-- | 2018-09-09 | 0.12 |
-- | 2018-09-10 | 0.15 |
-- | 2018-09-11 | 0.22 |
-- | 2018-09-12 | 0.12 |
-- | 2018-09-13 | 0.12 |
-- | 2018-09-14 | 0.13 |
-- | 2018-09-15 | 0.21 |
-- | 2018-09-16 | 0.29 |
-- | 2018-09-17 | 0.15 |
-- | 2018-09-18 | 0.06 |
-- | 2018-09-19 | 0.25 |
-- | 2018-09-20 | 0.18 |
-- | 2018-09-21 | 0.24 |
-- | 2018-09-22 | 0.13 |
-- | 2018-09-23 | 0.16 |
-- | 2018-09-24 | 0.29 |
-- | 2018-09-25 | 0.24 |
-- | 2018-09-26 | 0.32 |
-- | 2018-09-27 | 0.39 |
-- | 2018-09-28 | 0.32 |
-- | 2018-09-29 | 0.30 |
-- | 2018-09-30 | 0.29 |
-- +------------+------+

-- ARPPU

with recursive timeslice as
(
    select min(cast(payment_dttm as date)) as dt from payments
        union all
	select timeslice.dt + interval 1 day
	from timeslice
		where timeslice.dt + interval 1 day <= (select max(cast(payment_dttm as date)) as dt from payments)
),
pay_for_day as
(
    select cast(payment_dttm as date) as dt,
		sum(payment_sum) as pay_sum
		from payments
		group by dt
),
pu as
(
    select cast(payment_dttm as date) as dt,
		count(distinct user_id) as user_cnt
		from payments
		group by dt
)
	select timeslice.dt, round(coalesce(pay.pay_sum, 0) / coalesce(pu.user_cnt, 1), 2) as ARPPU
	  from timeslice
	  left join pay_for_day as pay on timeslice.dt = pay.dt
	  left join pu on timeslice.dt = pu.dt;

-- ARPPU result

-- +------------+---------+
-- | dt         | ARPPU   |
-- +------------+---------+
-- | 2018-08-07 |  902.00 |
-- | 2018-08-08 |    0.00 |
-- | 2018-08-09 |    0.00 |
-- | 2018-08-10 |  317.00 |
-- | 2018-08-11 |  135.00 |
-- | 2018-08-12 |  330.00 |
-- | 2018-08-13 |  615.00 |
-- | 2018-08-14 |  510.00 |
-- | 2018-08-15 |  372.00 |
-- | 2018-08-16 |   28.00 |
-- | 2018-08-17 |  731.50 |
-- | 2018-08-18 |  839.00 |
-- | 2018-08-19 |  381.50 |
-- | 2018-08-20 |  508.00 |
-- | 2018-08-21 |  277.00 |
-- | 2018-08-22 |    0.00 |
-- | 2018-08-23 |  443.50 |
-- | 2018-08-24 |  556.25 |
-- | 2018-08-25 |  528.50 |
-- | 2018-08-26 |    0.00 |
-- | 2018-08-27 |  818.50 |
-- | 2018-08-28 |  633.75 |
-- | 2018-08-29 |  537.00 |
-- | 2018-08-30 |  476.75 |
-- | 2018-08-31 |  348.67 |
-- | 2018-09-01 |  466.00 |
-- | 2018-09-02 |  154.50 |
-- | 2018-09-03 |    0.00 |
-- | 2018-09-04 |  549.00 |
-- | 2018-09-05 |  800.00 |
-- | 2018-09-06 |  665.75 |
-- | 2018-09-07 |  584.00 |
-- | 2018-09-08 |  448.50 |
-- | 2018-09-09 |  510.67 |
-- | 2018-09-10 |  629.75 |
-- | 2018-09-11 |  615.20 |
-- | 2018-09-12 |  731.33 |
-- | 2018-09-13 |  532.00 |
-- | 2018-09-14 |  479.33 |
-- | 2018-09-15 |  586.50 |
-- | 2018-09-16 |  641.44 |
-- | 2018-09-17 |  418.25 |
-- | 2018-09-18 |  350.00 |
-- | 2018-09-19 |  475.38 |
-- | 2018-09-20 |  633.33 |
-- | 2018-09-21 |  553.75 |
-- | 2018-09-22 |  263.00 |
-- | 2018-09-23 |  733.40 |
-- | 2018-09-24 |  776.60 |
-- | 2018-09-25 |  614.22 |
-- | 2018-09-26 | 1056.83 |
-- | 2018-09-27 |  420.79 |
-- | 2018-09-28 |  994.27 |
-- | 2018-09-29 |  837.69 |
-- | 2018-09-30 | 1100.75 |
-- +------------+---------+
