with
sub as (
select Tm,
avg(cast(R as decimal(5,2))) as runs,
avg(cast(RA as decimal(5,2))) as runs_allowed,
avg(cast(R as decimal(5,2))) - avg(cast(RA as decimal(5,2))) as run_diff

from sports.dbo.team_results_2019

where Result!=''

group by Tm),

sub2 as (
select Tm,
Record,
ROW_NUMBER() over (partition by Tm order by rowid) as r

from sports.dbo.team_results_2019

where Result!=''),

sub3 as (
select Tm,
max(r) as games_played

from sub2

group by Tm)

select sub.Tm,
Record,
runs,
runs_allowed,
run_diff,
cast(LEFT(Record,2) as decimal(5,2))/cast(r as decimal(5,2)) as win_per

from sub

inner join sub2
on sub.Tm=sub2.Tm

inner join sub3
on sub3.Tm=sub.Tm
and sub3.games_played=sub2.r

order by win_per desc