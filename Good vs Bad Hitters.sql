--identify top 50 great obp guys, 50 terrible, and then the rest avg
--per pa equiv
--compare all metrics and correlate

with
top50 as (
select top 50 *
from sports.dbo.batting_stats_2019
where PA>100
order by OBP desc),

bot50 as (
select top 50*
from sports.dbo.batting_stats_2019
where PA>100
order by OBP),

good_hitters as (
select 'Good' as hitter_type,
Name,
team,
age,
OBP,
h/pa as hit_rate,
"1b"/pa as single_rate,
"2b"/pa as double_rate,
"3b"/pa as triple_rate,
hr/pa as homer_rate,
r/pa as run_rate,
rbi/pa as rbi_rate,
(bb+ibb+hbp)/pa as walk_rate,
so/pa as k_rate,
(sf+sh)/pa as sac_rate,
gb/pa as groundball_rate,
fb/pa as flyball_rate,
ld/pa as line_drive_rate,
iffb/pa as infield_fly_rate,
ifh/pa as inflied_hit_rate,
bu/pa as bunt_opp_rate,
buh/pa as bunt_hit_rate,
BBK as walk_k_ratio,
Clutch,
"fb%(pitch)" as fastballs,
"sl%" as sliders,
"ct%" as cutters,
"cb%" as curveballs,
"ch%" as changeups,
"sf%" as splitters,
"O-Swing%" as outside_zone_swings,
"Z-Swing%" as inside_zone_swings,
"Swing%" as swing_rate,
"contact%" as contact_rate,
"zone%" as pitches_in_zone,
"f-strike%" as first_pitch_strike,
"swstr%" as whiffs,
"pull%" as pull_rate,
"cent%" as center_rate,
"oppo%" as oppo_rate,
"soft%" as soft_hit_rate,
"med%" as med_hit_rate,
"hard%" as hard_hit_rate

from top50),

bad_hitters as (
select 'Bad' as hitter_type,
Name,
team,
age,
OBP,
h/pa as hit_rate,
"1b"/pa as single_rate,
"2b"/pa as double_rate,
"3b"/pa as triple_rate,
hr/pa as homer_rate,
r/pa as run_rate,
rbi/pa as rbi_rate,
(bb+ibb+hbp)/pa as walk_rate,
so/pa as k_rate,
(sf+sh)/pa as sac_rate,
gb/pa as groundball_rate,
fb/pa as flyball_rate,
ld/pa as line_drive_rate,
iffb/pa as infield_fly_rate,
ifh/pa as inflied_hit_rate,
bu/pa as bunt_opp_rate,
buh/pa as bunt_hit_rate,
BBK as walk_k_ratio,
Clutch,
"fb%(pitch)" as fastballs,
"sl%" as sliders,
"ct%" as cutters,
"cb%" as curveballs,
"ch%" as changeups,
"sf%" as splitters,
"O-Swing%" as outside_zone_swings,
"Z-Swing%" as inside_zone_swings,
"Swing%" as swing_rate,
"contact%" as contact_rate,
"zone%" as pitches_in_zone,
"f-strike%" as first_pitch_strike,
"swstr%" as whiffs,
"pull%" as pull_rate,
"cent%" as center_rate,
"oppo%" as oppo_rate,
"soft%" as soft_hit_rate,
"med%" as med_hit_rate,
"hard%" as hard_hit_rate

from bot50),

total as (
select * from good_hitters
union
select * from bad_hitters),

final_data as (
select Name,
avg(obp) as obp,
avg(age) as age,
avg(hit_rate) as hit_rate,
avg(single_rate) as single_rate,
avg(double_rate) as double_rate,
avg(triple_rate) as triple_rate,
avg(homer_rate) as homer_rate,
avg(run_rate) as run_rate,
avg(rbi_rate) as rbi_rate,
avg(walk_rate) as walk_rate,
avg(k_rate) as k_rate,
avg(sac_rate) as sac_rate,
avg(groundball_rate) as groundball_rate,
avg(flyball_rate) as flyball_rate,
avg(line_drive_rate) as line_drive_rate,
avg(infield_fly_rate) as infield_fly_rate,
avg(inflied_hit_rate) as inflied_hit_rate,
avg(bunt_opp_rate) as bunt_opp_rate,
avg(bunt_hit_rate) as bunt_hit_rate,
avg(walk_k_ratio) as walk_k_ratio,
avg(clutch) as Clutch,
avg(fastballs) as fastballs,
avg(sliders) as sliders,
avg(cutters) as cutters,
avg(curveballs) as curveballs,
avg(changeups) as changeups,
avg(splitters) as splitters,
avg(outside_zone_swings) as outside_zone_swings,
avg(inside_zone_swings) as inside_zone_swings,
avg(swing_rate) as swing_rate,
avg(contact_rate) as contact_rate,
avg(pitches_in_zone) as pitches_in_zone,
avg(first_pitch_strike) as first_pitch_strike,
avg(whiffs) as whiffs,
avg(pull_rate) as pull_rate,
avg(center_rate) as center_rate,
avg(oppo_rate) as oppo_rate,
avg(soft_hit_rate) as soft_hit_rate,
avg(med_hit_rate) as med_hit_rate,
avg(hard_hit_rate) as hard_hit_rate

from total

group by Name),

deep_structure as (
select ROW_NUMBER() over (order by Name) as r,
Name,
stat,
stat_value
from final_data
unpivot
(
    stat_value
    for stat in (
	obp,age	,hit_rate,single_rate,double_rate,triple_rate,homer_rate,
run_rate,rbi_rate,walk_rate,k_rate,sac_rate,groundball_rate,flyball_rate,line_drive_rate,
infield_fly_rate,inflied_hit_rate,bunt_opp_rate,bunt_hit_rate,walk_k_ratio,Clutch,
fastballs,sliders,cutters,curveballs,changeups,splitters,outside_zone_swings,
inside_zone_swings,swing_rate,contact_rate,pitches_in_zone,first_pitch_strike,whiffs,
pull_rate,center_rate,oppo_rate,soft_hit_rate,med_hit_rate,hard_hit_rate
)
) u)

select * from total
