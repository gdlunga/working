package pricing_algorithm;

import finobject.*;

public class CMonteCarlo implements IPricing {

	/* parameters */
	private int numberOfSimulations;
	private int numberOfSteps;

	/* inspectors */
	
	public int getNumberOfSimulations()	{return numberOfSimulations;}
	public int getNumberOfSteps()		{return numberOfSteps;}

	/* constructors */
	
	public CMonteCarlo(){}
	
	public CMonteCarlo(int numberOfSimulations,
			           int numberOfSteps)
	{
		this.numberOfSimulations	=	numberOfSimulations;
		this.numberOfSteps			=   numberOfSteps;
	}
	
	public CMonteCarlo(int numberOfSimulations)
	{
		this.numberOfSimulations	=	numberOfSimulations;
		this.numberOfSteps			=   1;
	}
	
	/* methods */
	
	public double _Execute(COption option) 
	{
		System.out.println("Running Monte Carlo Simulation...");
		System.out.println("Number of Simulations = " + numberOfSimulations);
		option.printOut();
	
		numberOfSteps++;
		int    i        = 0; 											//counter
		double price    = 0; 											// price
	    double T   		= (option.getExercise()).getExpirationTime();   // expiry
	    double r		= (option.getDiscounting()).getDiscountRate();  // free risk interest rate
	    double stdev	= (option.getUnderlying()).getVolatility();		// underlying volatility	
	    double S		= (option.getUnderlying()).getLevel();			// underlying initial level
	    
		double riskNeutralDrift = r - 0.5*stdev*stdev;					// risk neutral drift
		double sqrtDeltaT 		= Math.sqrt(T/(numberOfSteps-1));	    // time interval square root
		double discount         = Math.exp(-r*T);						// discount function
		
		double[][] 	y				= new double[numberOfSimulations][numberOfSteps]; 	
		
		CPathGenerator generator 	= new CPathGenerator(numberOfSteps, numberOfSimulations); 
		
		generator.gbmUnivariate(S,
                                stdev,
                                sqrtDeltaT,
                                riskNeutralDrift,
                                y);
		
		price = 0;
		for(i = 0; i < numberOfSimulations; i++)
			price  += (option.getPayoff()).value(y[i]);

		price *= discount/numberOfSimulations;
		
		return price;
	}

	public double Execute(COption option) 
	{
		System.out.println("Running Monte Carlo Simulation...");
		System.out.println("Number of Simulations = " + numberOfSimulations);
		option.printOut();
	
		numberOfSteps++;
		int    i        = 0; 											//counter
		double price    = 0; 											// price
	    double T   		= (option.getExercise()).getExpirationTime();   // expiry
	    double r		= (option.getDiscounting()).getDiscountRate();  // free risk interest rate
	    double stdev	= (option.getUnderlying()).getVolatility();		// underlying volatility	
	    double S		= (option.getUnderlying()).getLevel();			// underlying initial level
	    
		double riskNeutralDrift = r - 0.5*stdev*stdev;					// risk neutral drift
		double sqrtDeltaT 		= Math.sqrt(T/(numberOfSteps-1));	    // time interval square root
		double discount         = Math.exp(-r*T);						// discount function
		
		double[] 	y			= new double[numberOfSteps]; 	
		
		CPathGenerator generator 	= new CPathGenerator(numberOfSteps, numberOfSimulations); 
		price = 0;
		for(i = 0; i < numberOfSimulations; i++)
		{
			generator.gbmUnivariate(S,
                    stdev,
                    sqrtDeltaT,
                    riskNeutralDrift,
                    y);

			price  += (option.getPayoff()).value(y);
		}	
		price *= discount/numberOfSimulations;
		
		return price;
	}
}
