use tehnotrack_db;

select 
	u.login as login
	from users as u join payments as p on u.user_id = p.user_id
    group by u.user_id
    order by sum(p.payment_sum) desc
    limit 3;
    
-- result : 
-- +----------+
-- | login    |
-- +----------+
-- | login_82 |
-- | login_38 |
-- | login_85 |
-- +----------+

 
select sum(subq.sessions)/count(*) from
	(select u.login as login, count(s.session_id) as sessions
		from users as u left join sessions as s on u.user_id = s.user_id
		group by u.login) as subq;
        
-- или: 

select count(s.session_id)/(select count(u.user_id) from users as u) from sessions as s;


-- result: 
-- +-----------------------------+
-- | sum(subq.sessions)/count(*) |
-- +-----------------------------+
-- |                     35.9100 |
-- +-----------------------------+