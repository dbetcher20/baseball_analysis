with
sub as (
select *,
cast (GETDATE()-BIRTHDATE as int)/365 as age,
ROW_NUMBER() over (partition by game_date, at_bat_number, batter order by pitch_number desc) as end_of_ab,
case when inning_topbot='Top' then away_team else home_team end as hitting_team

from sports.dbo.cubs_2019_08_20_to_2019_08_24 c

left join sports.dbo.player_id_map p
on p.MLBID=c.batter)

select batter,
PLAYERNAME,
age,
events,
hitting_team,
avg(launch_speed) as exit_velocity,
avg(launch_angle) as launch_angle,
avg(effective_speed) as avg_speed,
avg(release_spin_rate) as avg_spin

from sub

where end_of_ab=1
and game_date='2019-08-20'
and events not in ('field_out','walk','strikeout','sac_fly','grounded_into_double_play','force_out')

group by batter,PLAYERNAME,age,events, hitting_team
order by PLAYERNAME,events,exit_velocity desc