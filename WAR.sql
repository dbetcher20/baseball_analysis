select name_common,
mlb_ID,
pitcher,
p.TEAM,
sum(G) as games,
sum(PA) as plate_appear,
'$'+FORMAT(sum(salary),'#,0') as salary,
format(sum(WAR),'0.00') as war,
cast(sum(war)/sum(G) as decimal(3,3)) as wpg

from sports.dbo.batting_war_2019 b

left join sports.dbo.player_id_map p
on b.mlb_ID=p.MLBID

group by name_common,mlb_ID,pitcher,team
having sum(PA) between 50 and 150

order by wpg desc