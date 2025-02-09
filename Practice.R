W = c(8, 21, 15, 21, 21, 22, 14)
L = c(5, 10, 12, 14, 17, 14, 19)

Win.Pct = W*100/(W+L)
Year = seq(1946, 1952)
Year = 1946:1952
Age = Year - 1921

plot(Age, Win.Pct)

mean(Win.Pct)
sd(Win.Pct)
length(Win.Pct)
max(Win.Pct)
sort(Win.Pct)
order(Win.Pct)

sum(W)
cumsum(W)
summary(Win.Pct)

W[c(1,2,5)]
W[1:3]
W[-c(1,5)]

Win.Pct>60
Win.Pct[Win.Pct>60]
(W>20) & (Win.Pct>60)
Win.Pct==max(Win.Pct)
Year[Win.Pct==max(Win.Pct)]
Year[(W+L)>30]

NL=c('FLA','STL','HOU','STL','COL','PHI','PHI','SFG','STL','SFG')
AL=c('NYY','BOS','CHW','DET','BOS','TBR','NYY','TEX','TEX','DET')
Winner=c('NL','AL','AL','NL','NL','NL','AL','NL','NL','NL')
N.Games=c(6,4,4,5,4,5,6,5,7,4)
Year=2003:2012

results=matrix(c(NL,AL),10,2)
results
dimnames(results)[[1]]=Year
dimnames(results)[[2]]=c('NL Teams','AL Teams')
results
table(Winner)
barplot(table(Winner))

table(NL)
NL2=factor(NL, levels=c('FLA','PHI','STL','HOU','SFG','COL'))
str(NL2)
table(NL2)

World.Series=list(Winner=Winner, Number.Games=N.Games, Seasons='2003 to 2012')
World.Series$Number.Games
World.Series[[2]]
World.Series['Number.Games']
World.Series[2]

table(Winner)
barplot(table(Winner))
by(N.Games, Winner, summary)

hr.rates=function(age, hr, ab){
  rates=round(100*hr/ab,1)
  list(x=age, y=rates)
}
Age=19:29
Hr=c(33,45,22,45,46,54,44,46,46,55,54)
AB=c(350,455,340,444,562,541,453,541,451,552,455)
HR.Rates=hr.rates(Age, Hr, AB)
plot(hr.rates(Age,Hr,AB))

getwd()
setwd("C:/Users/allen/Desktop/R/baseballdatabank-master/core")
batting=read.csv("Batting.csv")
batting

Mantle=cbind(Age, Hr, AB, Rates=HR.Rates$y)
write.csv(Mantle, 'mantle.csv', row.names=FALSE)
write.csv(Mantle, 'mantles.csv', row.names=TRUE)

batting[1:5, 1:4]
batting[1,]
batting[1:4, c('playerID','stint')]
batting['RBI']
batting$RBI
summary(batting$RBI)
mean(batting$yearID[batting['stint']==min(batting['stint'])])

pitching=read.csv("Pitching.csv")
pitching$FIP=with(pitching, (13*HR+3*BB-2*SO)/(IPouts/3))
pitching[1,]
pos=order(pitching$FIP)
head(pitching[pos, c('ER','FIP')])

#pcb=subset(pitching, teamID=='PH1'| teamID=='CL1'| teamID=='BS1')
##pcb$teamID=factor(pcb$teamID, levels=c('PH1','CL1'))
#by(pcb[,c('W','L','G')], pcb$teamID, summary)
#pcb.10=subset(pcb, W>10)

#rbind(pitching, batting)
merge(pitching, batting, by='teamID')

install.packages('Lahman')
library(Lahman)
?Batting

Batting.60=subset(Batting, yearID>=1960 & yearID<=1969)
compute.hr=function(pid){
  d=subset(Batting.60, playerID==pid)
  sum(d$HR)
}
players=unique(Batting.60$playerID)
s=sapply(players, compute.hr)
R=data.frame(Player=players, HR=s)
R=R[order(R$HR, decreasing=TRUE), ]
head(R)

library(plyr)
dataframe.AB=ddply(Batting, .(playerID), summarize, Career.AB=sum(AB, na.rm=TRUE))
dataframe.AB
Batting=merge(Batting, dataframe.AB, by='playerID')
Batting.5000=subset(Batting, Career.AB>=5000)

ab.hr.so=function(d){
  c.AB=sum(d$AB, na.rm=TRUE)
  c.HR=sum(d$HR, na.rm=TRUE)
  c.SO=sum(d$SO, na.rm=TRUE)
  data.frame(AB=c.AB, HR=c.HR, SO=c.SO)
}
d.5000=ddply(Batting.5000, .(playerID), ab.hr.so)
head(d.5000)
with(d.5000, plot(HR/AB, SO/AB))
with(d.5000, lines(lowess(HR/AB, SO/AB)))

Batting$Era=cut(Batting$yearID,
                breaks=c(1800, 1900, 1919, 1941, 1960, 1976, 1993, 2050),
                labels=c('19th Century','Dead Ball','Lively Ball','Integration','Expansion','Free Agency','Long Ball'))
T.Era=table(Batting$Era)
T.Era
barplot(T.Era)
barplot(T.Era, xlab='Era', ylab='Frequency', main='Era of the Batters')
plot(T.Era)
pie(T.Era)
dotchart(as.numeric(T.Era), labels=names(T.Era), xlab='Frequency')

png('Era of the Batters')
barplot(T.Era, xlab='Era', ylab='Frequency', main='Era of the Batters')
dev.off()
getwd()

dataframe.HR=ddply(Batting, .(playerID), summarize, Career.HR=sum(HR, na.rm=TRUE))
Batting=merge(Batting, dataframe.HR, by='playerID')
HR.500=subset(Batting, Career.HR>=500)
HR.500=HR.500[order(HR.500$Career.HR),]

windows(width=7, height=3.5)
dotchart(HR.500$Career.HR, labels=HR.500$playerID, xlab='HR')
stripchart(HR.500$Career.HR, pch=1, xlab='HR')
stripchart(HR.500$Career.HR, method='jitter', pch=2, xlab='HR')
hist(HR.500$Career.HR, xlab='HR', main='', breaks=seq(500, 800, by=50))

with(HR.500, plot(AB, HR))
with(HR.500, lines(lowess(AB, HR, f=0.3))) 
#with(HR.500, identify(AB, HR, labels=playerID, n=3))

with(HR.500, plot(AB, HR, xlim=c(0,650), ylim=c(0,60),
                  pch=19, xlab='At Bat', ylab='Home Run'))
curve(150-x, add=TRUE)
curve(300-x, add=TRUE)
curve(600-x, add=TRUE)
text(100, 40, 'ABHR=100')
text(280, 40, 'ABHR=300')
#with(HR.500, identify(AB, HR, playerID, n=1))

Batting$HR.Rate=with(Batting, HR/AB)
stripchart(HR.Rate~Era, data=Batting)

par(plt=c(0.2, 0.94, 0.145, 0.883))
stripchart(HR.Rate~Era, data=Batting, method='jitter', pch=1, las=2)

par(plt=c(0.2, 0.94, 0.145, 0.883))
with(Batting, boxplot(HR.Rate~Era, las=2, horizontal=TRUE, xlab='HR Rate'))

Master=Master
getinfo=function(firstname, lastname){
  playerline=subset(Master, nameFirst==firstname & nameLast==lastname)
  name.code=as.character(playerline$playerID)
  birthyear=playerline$birthYear
  birthmonth=playerline$birthMonth
  byear=ifelse(birthmonth<=6, birthyear, birthyear+1)
  list(name.code=name.code, byear=byear)
}
ruth.info=getinfo('Babe','Ruth')
aaron.info=getinfo('Hank','Aaron')
bonds.info=getinfo('Barry','Bonds')
arod.info=getinfo('Alex','Rodriguez')
ruth.info
ruth.data=subset(Batting, playerID==ruth.info$name.code)
ruth.data$Age=ruth.data$yearID-ruth.info$byear
aaron.data=subset(Batting, playerID==aaron.info$name.code)
aaron.data$Age=aaron.data$yearID-aaron.info$byear
bonds.data=subset(Batting, playerID==bonds.info$name.code)
bonds.data$Age=bonds.data$yearID-bonds.info$byear
arod.data=subset(Batting, playerID==arod.info$name.code)
arod.data$Age=arod.data$yearID-arod.info$byear

with(ruth.data[order(ruth.data$Age),], plot(Age, cumsum(HR), type='l', lty=3, lwd=2, xlab='Age'
                     , ylab='Career HR', xlim=c(18,45), ylim=c(0,800)))
with(aaron.data[order(aaron.data$Age),], lines(Age, cumsum(HR), lty=2, lwd=2))
with(bonds.data[order(bonds.data$Age),], lines(Age, cumsum(HR), lty=1, lwd=2))
with(arod.data[order(arod.data$Age),], lines(Age, cumsum(HR), lty=4, lwd=2))
legend(20, 800, legend=c('Bonds', 'Aaron', 'Ruth', 'Arod'), lty=1:4, lwd=2)

data1998=read.csv('all1998.csv', header=FALSE)
fields=read.csv('fields.csv')
names(data1998)=fields[,'Header']
retro.ids=read.csv('retrosheetIDs.csv')
sosa.id=as.character(subset(retro.ids, FIRST=='Sammy'& LAST=='Sosa')$ID)
mac.id=as.character(subset(retro.ids, FIRST=='Mark'& LAST=='McGwire')$ID)
sosa.data=subset(data1998, BAT_ID==sosa.id)
mac.data=subset(data1998, BAT_ID==mac.id)
createdata=function(d){
  d$Date=as.Date(substr(d$GAME_ID, 4, 11), format='%Y%m%d')
  d=d[order(d$Date),]
  d$HR=ifelse(d$EVENT_CD==23, 1, 0)
  d$cumHR=cumsum(d$HR)
  d[,c('Date','cumHR')]
}
sosa.hr=createdata(sosa.data)
mac.hr=createdata(mac.data)
head(sosa.hr)
plot(mac.hr, type='l', lwd=2, ylab='Home Runs in the Season')
lines(sosa.hr, lwd=2, col='grey')
abline(h=62, lty=3)
text(10440, 65, '62')
legend(10440, 30, legend=c('McGwire(70)', 'Sosa(66)'), 
       lwd=2, col=c('black','grey'))



teams=Teams
tail(teams)
myteams=subset(teams, yearID>=2000)[, c('teamID','yearID','lgID','G','W','L','R','RA')]
tail(myteams)
myteams$RD=with(myteams, R-RA)
myteams$Wpct=with(myteams, W/(W+L))
with(myteams, plot(RD, Wpct, xlab='run differential', ylab='winning percentage'))
linfit=lm(Wpct~RD, data=myteams)
coef(linfit)
abline(a=coef(linfit)[1], b=coef(linfit)[2], lwd=2)

myteams$linWpct=predict(linfit)
myteams$linResiduals=residuals(linfit)
with(myteams, plot(RD, linResiduals, xlab='run differential', ylab='residual'))
abline(h=0, lty=3)
points(x=c(68, 88), y=c(0.0749, -0.0733), pch=19)
text(68, 0.0749, "LAA'08", pos=4, cex=0.8)
text(88, -0.0733, "CLE'06", pos=4, cex=0.8)

mean(myteams$linResiduals)
linRMSE=sqrt(mean(myteams$linResiduals^2))
nrow(subset(myteams, abs(linResiduals)<linRMSE))/nrow(myteams)
nrow(subset(myteams, abs(linResiduals)<2*linRMSE))/nrow(myteams)

myteams$pytWpct=with(myteams, R^2/(R^2+RA^2))
myteams$pytResiduals=myteams$Wpct-myteams$pytWpct
sqrt(mean(myteams$pytResiduals^2))

myteams$logWratio=log(myteams$W/myteams$L)
myteams$logRratio=log(myteams$R/myteams$RA)
pytFit=lm(logWratio~0+logRratio, data=myteams)
pytFit



setwd('C:/Users/allen/Desktop/R/gl1871_2020')
gl2011=read.table('GL2011.txt', sep=',')
setwd('C:/Users/allen/Desktop/R')
glheaders=read.csv('game_log_header.csv')
names(gl2011)=names(glheaders)
BOS2011=subset(gl2011, HomeTeam=='BOS'| VisitingTeam=='BOS')[,c('VisitingTeam',
                                                                'HomeTeam',
                                                                'VisitorRunsScored',
                                                                'HomeRunsScore')]
head(BOS2011)
BOS2011$ScoreDiff=with(BOS2011, ifelse(HomeTeam=='BOS', HomeRunsScore-VisitorRunsScored,
                                       VisitorRunsScored-HomeRunsScore))
BOS2011$W=BOS2011$ScoreDiff>0
aggregate(abs(BOS2011$ScoreDiff), list(W=BOS2011$W), summary)

results=gl2011[,c('VisitingTeam','HomeTeam','VisitorRunsScored','HomeRunsScore')]
results$winner=ifelse(results$VisitorRunsScored>results$HomeRunsScore, 
                      as.character(results$VisitingTeam), as.character(results$HomeTeam))
results$diff=abs(results$VisitorRunsScored-results$HomeRunsScore)
onerungames=subset(results, diff==1)
onerunwins=as.data.frame(table(onerungames$winner))
names(onerunwins)=c('teamID','onerunW')
teams2011=subset(myteams, yearID==2011)
teams2011[teams2011$teamID=='LAA','teamID']='ANA'
teams2011=merge(teams2011, onerunwins)
plot(teams2011$onerunW, teams2011$pytResiduals,
     xlab='one run wins',
     ylab='Pythagorean Residuals')
#identify(teams2011$onerunW, teams2011$pytResiduals, labels=teams2011$teamID, n=2)



pit=Pitching
top_closers=subset(pit, GF>50 & ERA<2.5)[,c('playerID', 'yearID', 'teamID')]
teams_top_closers=merge(myteams, top_closers)
summary(teams_top_closers$pytResiduals)
IR=function(RS=5, RA=5){
  round((RS^2+RA^2)^2/(2*RS*RA^2), 1)
}
IRtable=expand.grid(RS=seq(3, 6, 0.5), RA=seq(3, 6, 0.5))
rbind(head(IRtable), tail(IRtable))
IRtable$IRW=IR(IRtable$RS, IRtable$RA)
xtabs(IRW~RS+RA, data=IRtable)
xtabs(IRW~RA+RS, data=IRtable)



data2011=read.csv('all2011.csv', header=FALSE)
fields=read.csv('fields.csv')
names(data2011)=fields[,'Header']
data2011$RUNS=with(data2011, AWAY_SCORE_CT+HOME_SCORE_CT)
data2011$HALF.INNING=with(data2011, paste(GAME_ID, INN_CT, BAT_HOME_ID))
data2011$RUNS.SCORED=with(data2011, (BAT_DEST_ID>3)+(RUN1_DEST_ID>3)+(RUN2_DEST_ID>3)+
                          (RUN3_DEST_ID>3))
RUNS.SCORED.INNING=aggregate(data2011$RUNS.SCORED, list(HALF.INNING=data2011$HALF.INNING), 
                             sum)
RUNS.SCORED.START=aggregate(data2011$RUNS, list(HALF.INNING=data2011$HALF.INNING), '[', 1)
MAX=data.frame(HALF.INNING=RUNS.SCORED.START$HALF.INNING)
MAX$x=RUNS.SCORED.START$x+RUNS.SCORED.INNING$x
data2011=merge(data2011, MAX)
N=ncol(data2011)
names(data2011)[N]='MAX.RUNS'
data2011$RUNS.ROI=with(data2011, MAX.RUNS-RUNS)
RUNNER1=ifelse(as.character(data2011[,'BASE1_RUN_ID'])=='', 0, 1)
RUNNER2=ifelse(as.character(data2011[,'BASE2_RUN_ID'])=='', 0, 1)
RUNNER3=ifelse(as.character(data2011[,'BASE3_RUN_ID'])=='', 0, 1)
get.state=function(runner1, runner2, runner3, outs){
  runners=paste(runner1, runner2, runner3, sep='')
  paste(runners, outs)
}
data2011$STATE=get.state(RUNNER1, RUNNER2, RUNNER3, data2011$OUTS_CT)
data2011$STATE
NRUNNER1=with(data2011, as.numeric(RUN1_DEST_ID==1|BAT_DEST_ID==1))
NRUNNER2=with(data2011, as.numeric(RUN2_DEST_ID==2|RUN1_DEST_ID==2|BAT_DEST_ID==2))
NRUNNER3=with(data2011, as.numeric(RUN3_DEST_ID==3|RUN2_DEST_ID==3|RUN1_DEST_ID==3|BAT_DEST_ID==3))
NOUTS=with(data2011, OUTS_CT+EVENT_OUTS_CT)
data2011$NEW.STATE=get.state(NRUNNER1, NRUNNER2, NRUNNER3, NOUTS)
data2011=subset(data2011, (STATE!=NEW.STATE)|(RUNS.SCORED>0))       
data2011=subset(data2011, select=-NEWSTATE)
library(plyr)
data.outs=ddply(data2011, .(HALF.INNING), summarize, Outs.Inning=sum(EVENT_OUTS_CT))
data2011=merge(data2011, data.outs)
data2011C=subset(data2011, Outs.Inning==3)
RUNS=with(data2011C, aggregate(RUNS.ROI, list(STATE), mean))
RUNS$Outs=substr(RUNS$Group.1, 5, 5)
RUNS=RUNS[order(RUNS$Outs),]
RUNS.out=matrix(round(RUNS$x, 2), 8, 3)
dimnames(RUNS.out)[[2]]=c('0 outs', '1 out', '2 outs')
dimnames(RUNS.out)[[1]]=c('000', '001', '010', '011', '100', '101', '110', '111')
RUNS.2002=matrix(c(.51, 1.40, 1.14, 1.96, .90, 1.84, 1.51, 2.33,
                   .27, .94, .68, 1.36, .54, 1.18, .94, 1.51,
                   .10, .36, .32, .63, .23, .52, .45, .78), 8, 3)
dimnames(RUNS.2002)=dimnames(RUNS.out)
cbind(RUNS.out, RUNS.2002)



RUNS.POTENTIAL=matrix(c(RUNS$x, rep(0, 8)), 32, 1)
dimnames(RUNS.POTENTIAL)[[1]]=c(RUNS$Group.1, '000 3', '001 3', '010 3', '011 3',
                                '100 3', '101 3', '110 3', '111 3')
data2011$RUNS.STATE=RUNS.POTENTIAL[data2011$STATE, ]
data2011$RUNS.NEW.STATE=RUNS.POTENTIAL[data2011$NEW.STATE, ]
data2011$RUNS.VALUE=data2011$RUNS.NEW.STATE-data2011$RUNS.STATE+data2011$RUNS.SCORED



Roster=read.csv('roster2011.csv')
albert.id=subset(Roster, Last.Name=='Pujols' & First.Name=='Albert')$Player.ID
albert.id=as.character(albert.id)
albert=subset(data2011, BAT_ID==albert.id)
albert=subset(albert, BAT_EVENT_FL=TRUE)
albert[1:2, c('STATE', "NEW.STATE", "RUNS.VALUE")]
albert$RUNNERS=substr(albert$STATE, 1, 3)
table(albert$RUNNERS)
with(albert, stripchart(RUNS.VALUE~RUNNERS, vertical=TRUE, jitter=0.2, method='jitter',
                        xlab='RUNNERS',pch=1, cex=0.8))
abline(h=0)
A.runs=aggregate(albert$RUNS.VALUE, list(albert$RUNNERS), sum)
colnames(A.runs)[2]='RUNS'
A.PA=aggregate(albert$RUNS.VALUE, list(albert$RUNNERS), length)
colnames(A.PA)[2]='PA'
A=merge(A.PA, A.runs)
A
sum(A$RUNS)



data2011b=subset(data2011, BAT_EVENT_FL=TRUE)
runs.sums=aggregate(data2011b$RUNS.VALUE, list(data2011b$BAT_ID), sum)
runs.pa=aggregate(data2011b$RUNS.VALUE, list(data2011b$BAT_ID), length)
runs.start=aggregate(data2011b$RUNS.STATE, list(data2011b$BAT_ID), sum)
colnames(runs.sums)=c('Batter', 'Runs')
colnames(runs.pa)=c('Batter', 'PA')
colnames(runs.start)=c('Batter', 'Runs.Start')
runs=merge(runs.sums, runs.pa)
runs=merge(runs, runs.start)
runs400=subset(runs, PA>=400)
with(runs400, plot(Runs.Start, Runs))
with(runs400, lines(lowess(Runs.Start, Runs)))
abline(h=0)
runs400.top=subset(runs400, Runs>=40)
roster2011=read.csv('roster2011.csv')
runs400.top=merge(runs400.top, roster2011, by.x='Batter', by.y='Player.ID')
with(runs400.top, text(Runs.Start, Runs, Last.Name, pos=1))



get.batting.pos=function(batter){
    TB=table(subset(data2011, BAT_ID==batter)$BAT_LINEUP_ID)
    names(TB)[TB==max(TB)][1]}
position=sapply(runs400$Batter, get.batting.pos)
with(runs400, plot(Runs.Start, Runs, type='n'))
with(runs400, lines(lowess(Runs.Start, Runs)))
abline(h=0)
with(runs400, text(Runs.Start, Runs, position))
AP=subset(runs400, Batter==albert.id)
points(AP$Runs.Start, AP$Runs, pch=19, cex=3)



d.homerun=subset(data2011, EVENT_CD==23)
table(d.homerun$STATE)
round(prop.table(table(d.homerun$STATE)), 3)
library(MASS)
truehist(d.homerun$RUNS.VALUE)
subset(d.homerun, RUNS.VALUE==max(RUNS.VALUE))[1, c('STATE', 'NEW.STATE', 'RUNS.VALUE')]
mean.HR=mean(d.homerun$RUNS.VALUE)
abline(v=mean.HR, lwd=3)
text(1.5, 5, 'Mean Run Value', pos=4)



d.single=subset(data2011, EVENT_CD==20)
truehist(d.single$RUNS.VALUE)
table(d.single$STATE)
subset(d.single, RUNS.VALUE==max(RUNS.VALUE))[, c('STATE', 'NEW.STATE', 'RUNS.VALUE')]
subset(d.single, RUNS.VALUE==min(RUNS.VALUE))[, c('STATE', 'NEW.STATE', 'RUNS.VALUE')]
mean.single=mean(d.single$RUNS.VALUE)
abline(v=mean.single, lwd=3)
text(0.5, 5, 'Mean Run Value', pos=4)



stealing=subset(data2011, EVENT_CD==6|EVENT_CD==4)
table(stealing$EVENT_CD)
table(stealing$STATE)
truehist(stealing$RUNS.VALUE)
stealing.1001=subset(stealing, STATE=='100 1')
table(stealing.1001$EVENT_CD)
with(stealing.1001, table(NEW.STATE))
mean(stealing.1001$RUNS.VALUE)
mean(stealing$RUNS.VALUE)



load("C:/Users/allen/Desktop/R/balls_strikes_count.RData")
library(lattice)
verlander
sampleRows=sample(1:nrow(verlander), 20)
str(sampleRows)
verlander[sampleRows, ]
histogram(~speed, data=verlander)
densityplot(~speed, data=verlander, plot.points=FALSE)
densityplot(~speed|pitch_type, data=verlander, plot.points=FALSE, layout=c(1,5))
densityplot(~speed, data=verlander, groups=pitch_type, plot.points=FALSE, auto.key=TRUE)
F4verl=subset(verlander, pitch_type=='FF')
F4verl$gameDay=as.integer(format(F4verl$gamedate, format='%j'))
dailySpeed=aggregate(speed~season+gameDay, data=F4verl, FUN=mean)
xyplot(speed~gameDay|factor(season), data=dailySpeed, xlab='day of the year', ylab='pitch speed (mph)')
xyplot(speed~gameDay, groups=season, data=dailySpeed)
speedFC=subset(verlander, pitch_type %in% c('FF', 'CH'))
avgspeedFC=aggregate(speed~pitch_type+season, data=speedFC, FUN=mean)
str(avgspeedFC)
droplevels(avgspeedFC)
dotplot(factor(season)~speed, groups=pitch_type, data=avgspeedFC, pch=c('C', 'F'), cex=2)
avgSpeed=aggregate(speed~season+pitches, data=F4verl, FUN=mean)
avgSpeedComb=mean(F4verl$speed)
xyplot(speed~pitches|factor(season), data=avgSpeed, 
  panel=function(...){
  panel.xyplot(...)
  panel.abline(v=100, lty='dotted')
  panel.abline(h=avgSpeedComb)
  panel.text(25, 100, 'avg. speed')
  panel.arrows(25, 99.5, 0, avgSpeedComb, length=0.1)
})



NoHit=subset(verlander, gamedate=='2011-05-07')
pitchnames=c('Changeup', 'Curveball', '4S-Fastball', '2S-Fastball', 'Slider')
myKey=list(space='right',
           border=TRUE,
           title='pitch type',
           cex.title=1.5,
           text=pitchnames,
           padding.text=4)
topKzone=3.5
botKzone=1.6
inKzone=-0.95
outKzone=0.95
xyplot(pz~px|batter_hand, groups=pitch_type, data=NoHit, auto.key=myKey, 
       aspect='iso',
       xlim=c(-2.2, 2.2),
       ylim=c(0, 5),
       xlab='Horizontal location\n(ft. from middle of plate)',
       ylab='Vertical location\n(ft. from ground)',
       panel=function(...){
         panel.xyplot(...)
         panel.rect(inKzone, botKzone, outKzone, topKzone, border='black', lty=3)
       })



sampleRows=sample(1:nrow(cabrera), 20)
cabrera[sampleRows,]
library(ggplot2)
p0=ggplot(data=cabrera, aes(x=hitx, y=hity))
p1=p0+geom_point(aes(color=hit_outcome))
p2=p1+coord_equal()
p3=p2+facet_wrap(~season)
bases=data.frame(x=c(0, 90/sqrt(2), 0, -90/sqrt(2), 0),
                 y=c(0, 90/sqrt(2), 2*90/sqrt(2), 90/sqrt(2), 0))
p4=p3+geom_path(data=bases, aes(x=x, y=y))
p5=p4+geom_segment(x=0, xend=300, y=0, yend=300)+
  geom_segment(x=0, xend=-300, y=0, yend=300)
p5

cabreraStretch=subset(cabrera, gamedate>'2012-08-31')
p0=ggplot(data=cabreraStretch, aes(x=hitx, y=hity))
p1=p0+geom_point(aes(shape=hit_outcome, colour=pitch_type, size=speed))
p2=p1+coord_equal()
p3=p2+geom_path(data=bases, aes(x=x, y=y))
p4=p3+guides(col=guide_legend(ncol=2))
p4+geom_segment(x=0, xend=300, y=0, yend=300)+geom_segment(x=0, xend=-300, y=0, yend=300)

ggplot(data=F4verl, aes(pitches, speed))+
  facet_wrap(~season)+
  geom_point(data=F4verl[sample(1:nrow(F4verl), 1000),], aes(pitches, speed))+
  geom_smooth(col='black')+
  geom_vline(aes(xintercept=100), col='black', lty=2)+
  geom_hline(aes(yintercept=avgSpeedComb), lty=3)

kZone=data.frame(
  x=c(inKzone, inKzone, outKzone, outKzone, inKzone),
  y=c(botKzone, topKzone, topKzone, botKzone, botKzone)
)
ggplot(data=F4verl, aes(px, pz))+
  geom_point()+
  facet_wrap(~batter_hand)+
  coord_equal()+
  geom_path(data=kZone, aes(x, y), lwd=2, col='white', alpha=0.3)

install.packages('hexbin')
library(hexbin)
ggplot(data=F4verl, aes(px, pz))+
  stat_binhex()+
  facet_wrap(~batter_hand)+
  coord_equal()+
  geom_path(data=kZone, aes(x, y), lwd=2, col='white', alpha=0.3)  

library(jpeg)
diamond=readJPEG('Comerica.jpg')
ggplot(data=cabrera, aes(hitx, hity))+
  coord_equal()+
  annotation_raster(diamond, -310, 305, -100, 480)+
  stat_binhex(alpha=0.9, binwidth=c(5, 5))+
  scale_fill_gradient(low='grey70', high='black')



mussina=expand.grid(ball=0:3, strike=0:2)
mussina$value=c(100, 118, 157, 207, 72, 82, 114, 171, 30, 38, 64, 122)
mussina
install.packages('plotrix')
countmap=function(data){
  require(plotrix)
  data=xtabs(value~., data)
  color2D.matplot(data, show.values=2, axes=FALSE, xlab='', ylab='')
  axis(side=2, at=3.5:0.5, labels=rownames(data), las=1)
  axis(side=3, at=0.5:2.5, labels=colnames(data))
  mtext(text='balls', side=2, line=2, cex.lab=1)
  mtext(text='strikes', side=3, line=2, cex.label=1)
}
countmap(mussina)



sequences=c('BBX', 'C11BBC1S', '1X')
grep('1', sequences)
grepl('1', sequences)
grepl('11', sequences)
gsub('1', '', sequences)
pbp2011=read.csv('all2011.csv')
headers=read.csv('fields.csv')
colnames(pbp2011)=headers$Header
pbp2011$pseq=gsub('[.>123N+*]', '', pbp2011$PITCH_SEQ_TX)
pbp2011$c10=grepl('^[BIPV]', pbp2011$pseq)
pbp2011$c01=grepl('^[CFKLMOQRST]', pbp2011$pseq)
pbp2011[1:10, c('PITCH_SEQ_TX', 'c10', 'c01')]
pbp11rc=read.csv('pbp11rc.csv')
pbp11rc[1:5, c('GAME_ID', 'EVENT_ID', 'c00', 'c10', 'c20', 'c11', 'c01', 'c30', 'c21',
               'c31', 'c02', 'c12', 'c22', 'c32', 'RUNS.VALUE')]

ab10=subset(pbp11rc, c10==1)
ab01=subset(pbp11rc, c01==1)
c(mean(ab10$RUNS.VALUE), mean(ab01$RUNS.VALUE))
runs.by.count=expand.grid(balls=0:3, strikes=0:2)
runs.by.count$value=0
bs.count.run.value=function(b, s){
  column.name=paste('c', b, s, sep='')
  mean(pbp11rc[pbp11rc[, column.name]==1, 'RUNS.VALUE'])
}
runs.by.count$value=mapply(FUN=bs.count.run.value, b=runs.by.count$balls, s=runs.by.count$strikes)
countmap(runs.by.count)

count22=subset(pbp11rc, c22==1)
mean(count22$RUNS.VALUE)
count22$after2=ifelse(count22$c20==1, '2-0', ifelse(count22$c02==1, '0-2', '1-1'))
aggregate(RUNS.VALUE~after2, data=count22, FUN=mean)
count11=subset(pbp11rc, c11==1)
count11$after1=ifelse(count11$c01==1, '0-1', '1-0')
aggregate(RUNS.VALUE~after1, data=count11, FUN=mean)


ls()
sampCabrera=cabrera[sample(1:nrow(cabrera), 500),]
topKzone=3.5
botKzone=1.6
inKzone=-0.95
outKzone=0.95
library(lattice)
xyplot(pz~px, data=sampCabrera, groups=swung,
       aspect='iso',
       xlab='horizontal location (ft.)',
       ylab='vertical location (ft.)',
       auto.key=list(points=TRUE, text=c('not swung', 'swung'), space='right'),
       panel=function(...){
         panel.xyplot(...)
         panel.rect(inKzone, botKzone, outKzone, topKzone, border='black')
       })



miggy.loess=loess(swung~px+pz, data=cabrera,
                  control=loess.control(surface='direct'))
pred.area=expand.grid(px=seq(-2, 2, 0.1), pz=seq(0, 6, 0.1))
pred.area$fit=c(predict(miggy.loess, pred.area))
subset(pred.area, px==0 & pz==2.5)
subset(pred.area, px==0 & pz==0)
subset(pred.area, px==2 & pz==2.5)
contourplot(fit~px+pz, data=pred.area, 
            at=c(.2, .4, .6, .8),
            aspect='iso',
            xlim=c(-2, 2),
            ylim=c(0, 5),
            xlab='horizontal location (ft.)',
            ylab='vertical location (ft.)',
            panel=function(...){
              panel.contourplot(...)
              panel.rect(inKzone, botKzone, outKzone, topKzone, border='black', lty='dotted')
            }
            )

cabrera$bscount=paste(cabrera$balls, cabrera$strikes, sep='-')
miggy00=subset(cabrera, bscount=='0-0')
miggy00loess=loess(swung~px+pz, data=miggy00,
                   control=loess.control(surface='direct'))
pred.area$fit00=c(predict(miggy00loess, pred.area))
miggy02=subset(cabrera, bscount=='0-2')
miggy20=subset(cabrera, bscount=='2-0')
miggy02loess=loess(swung~px+pz, data=miggy02,
                   control=loess.control(surface='direct'))
miggy20loess=loess(swung~px+pz, data=miggy20,
                   control=loess.control(surface='direct'))
pred.area$fit02=c(predict(miggy02loess, pred.area))
pred.area$fit20=c(predict(miggy20loess, pred.area))
contourplot(fit00+fit02+fit20~px+pz, data=pred.area,
            at=c(.2, .4, .6),
            aspect='iso',
            xlim=c(-2, 2),
            ylim=c(0, 5),
            xlab='horizontal location(ft.)',
            ylab='vertical location(ft.)',
            panel=function(...){
              panel.contourplot(...)
              panel.rect(inKzone, botKzone, outKzone, topKzone, lty='dotted', border='black')
            })



table(verlander$pitch_type)
round(100*prop.table(table(verlander$pitch_type)), 0)
type_verlander_hand=with(verlander, table(pitch_type, batter_hand))
round(100*prop.table(type_verlander_hand, margin=2))
verlander$bscount=paste(verlander$balls, verlander$strikes, sep='-')
verl_RHB=subset(verlander, batter_hand=='R')
verl_type_cnt_R=with(verl_RHB, table(bscount, pitch_type))
round(100*prop.table(verl_type_cnt_R, margin=1), 0)
