proc sgscatter data=HEATCOOL;
   matrix  HeatingLoad
   		   CoolingLoad
   		   RelativeCompactness
   		   SurfaceArea
   		   WallArea
   		   RoofArea
   		   OverallHeight
   		   Orientation
   		   GlazingArea
   		   GlazingAreaDist;
run;

proc corr data=HEATCOOL noprob;
       var HeatingLoad
   		   CoolingLoad
   		   RelativeCompactness
   		   SurfaceArea
   		   WallArea
   		   RoofArea
   		   OverallHeight
   		   Orientation
   		   GlazingArea
   		   GlazingAreaDist;
run;

proc transreg data = HEATCOOL;
model boxcox (CoolingLoad) = 
   		   identity(RelativeCompactness)
   		   identity(WallArea)
   		   identity(OverallHeight)
   		   identity(Orientation)
   		   identity(GlazingArea)
   		   identity(GlazingAreaDist);
run;

*Box-Cox shows reccomends a log transformation (1/2);

*Data sets with log transformation on response;
data logHeatTrans;
set HEATCOOL;
logheat = (HeatingLoad);
run;

data logCoolTrans;
set HEATCOOL;
logcool = log(CoolingLoad);
run;

proc reg data=logHeatTrans outest=fits;
	model logheat =
		   		   RelativeCompactness	   		   
		   		   WallArea		   		   
		   		   OverallHeight
		   		   GlazingArea
		   		   GlazingAreaDist;
run;

proc reg data=logCoolTrans outest=fits;
	model logcool =
		   		   RelativeCompactness	   		   
		   		   WallArea		   		   
		   		   OverallHeight
		   		   GlazingArea;
run;

*Regression models with transformation applied to response;
proc reg data=logHeatTrans outest=fits;
	model logheat =
		   		   RelativeCompactness		   		  
		   		   WallArea		   		   
		   		   OverallHeight
		   		   Orientation
		   		   GlazingArea
		   		   GlazingAreaDist 		   
	/selection=rsquare adjrsq cp aic sbc b best=1 press;
run;

proc reg data=logCoolTrans outest=fits;
	model logcool =
		   		   RelativeCompactness		   		  
		   		   WallArea		   		   
		   		   OverallHeight
		   		   Orientation
		   		   GlazingArea
		   		   GlazingAreaDist 		   
	/selection=rsquare adjrsq cp aic sbc b best=1 press;
run;

proc reg data=logCoolTrans outest=fits;
	model logcool =
		   		   RelativeCompactness		   		  
		   		   WallArea		   		   
		   		   OverallHeight
		   		   Orientation
		   		   GlazingArea
		   		   GlazingAreaDist 		   
	/selection=rsquare adjrsq cp aic sbc b best=1 press;
run;




*Regreession models with no transformation applied;
proc reg data=HEATCOOL outest=fits;
	model HeatingLoad =
		   		   RelativeCompactness		   		  
		   		   WallArea		   		   
		   		   OverallHeight
		   		   Orientation
		   		   GlazingArea
		   		   GlazingAreaDist 		   
	/selection=rsquare adjrsq cp aic sbc b best=1 press;
run;


proc reg data=HEATCOOL outest=fits;
	model CoolingLoad =
		   		   RelativeCompactness	   		   
		   		   WallArea		   		   
		   		   OverallHeight
		   		   Orientation
		   		   GlazingArea
		   		   GlazingAreaDist
	/selection=rsquare adjrsq cp aic sbc b best=1 press;
run;
