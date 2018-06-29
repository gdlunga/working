package pricing_algorithm;

import finobject.*;

public class CBinomialTree implements IPricing 
{
	public double Execute(COption option) 
	{
		System.out.println("Running Binomial Tree...");
		System.out.println("Number of levels = " + numberOfLevels);
		option.printOut();
		
	    double[][] assetValue = new double [numberOfLevels][numberOfLevels];
	    
	    CPayoff	Payoff        		= option.getPayoff();
	    
	    double expirationTime   	= (option.getExercise()).getExpirationTime();
	    double discountingRate		= (option.getDiscounting()).getDiscountRate();
	    double underlyingVolatility	= (option.getUnderlying()).getVolatility();
	    double underlyingLevel		= (option.getUnderlying()).getLevel();
	    double deltaT				= 0;
	    double discountFactor		= 0;
	    double intrinsicValue       = 0;
	    double continuationValue    = 0;
	    double u					= 0;
	    double d					= 0;
	    double p					= 0;
	    int j						= 0;
	    int n						= 0;
	    
	    deltaT 			=  expirationTime/(numberOfLevels-1);
	    discountFactor 	= Math.exp(-discountingRate*deltaT);
	    u 				= Math.exp(underlyingVolatility * Math.sqrt(deltaT));
	    d 				= 1 / u;
	    p				= ((1/discountFactor)-d)/(u-d);

	    assetValue[0][0]= underlyingLevel;
	    for (n = 1; n < numberOfLevels; n++)
	    {
		    for (j = n; j >= 1; j--)
		    {
			    assetValue[j][n] = (u* assetValue[j-1][n-1]);
		    }
		    assetValue[0][n] = (d*assetValue[0][n-1]);
	    }
	    
	    double[][]optionValue = new double [numberOfLevels][numberOfLevels];
	    
	    for (j = 0; j < numberOfLevels; j++)
	    {
		    optionValue[j][numberOfLevels-1] = Payoff.value(assetValue[j][numberOfLevels-1]); 
	    }
	    for (n = numberOfLevels - 1; n >= 0; n--)
	    {
		    for (j = 0; j <= n - 1; j++)
		    {
		    	intrinsicValue  	=  Payoff.value(assetValue[j][n-1]);
		    	continuationValue	=  (p*optionValue[j+1][n]+(1-p)*optionValue[j][n])*discountFactor;
			    optionValue[j][n-1] =  (option.getExercise()).earlyExerciseValue(intrinsicValue,continuationValue, n*deltaT);
		    }
	    }
		return optionValue[0][0];
	}
	/**
	 * @uml.property  name="numberOfLevels"
	 */
	private int numberOfLevels;

	public int getNumberOfLevels() 
	{
		return numberOfLevels;
	}
	/**
	 */
	public CBinomialTree(){}
	/**
	 */
	public CBinomialTree(int numberOfLevels)
	{
		this.numberOfLevels	=	numberOfLevels;
	}
}
