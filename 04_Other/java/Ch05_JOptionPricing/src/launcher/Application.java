package launcher;
import finobject.*;
import pricing_algorithm.*;
import java.util.*;

public class Application 
{
	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		double		S 		= 31500.0; 	// underlying level
		double      sigma	= 0.15000; 	// standard deviation of log ret of underlying
		double      K 		= 31500.0; 	// strike price
		double      T		= 0.25000;	// expiry (years)	
		double      r       = 0.02000;	// risk-free rate 
		
		CDiscounting 		discounting = new CDiscounting(r);
		CFinancialActivity	equity		= new CEquity(S, sigma);

		CPayoff 			payoff 		= new CPayoff_PutPV(K);
		CExercise			exercise	= new CExercise_European(T, GregorianCalendar.YEAR);
		IPricing			priceModel	= new CBlackScholes();
		
		// ----------------------------------------------------------------------------------
		// just to warm up a simple European Option...
          		
		COption 			anEuropeanOption = new COption(discounting,
				                                           equity,
				                                           exercise,
				                                           payoff,
				                                           priceModel);
		
		double price = anEuropeanOption.Pricing();
		
		System.out.println("Fair Value = " + price + "\n");
		
		// ----------------------------------------------------------------------------------
		// American Option
		
		int numberOfTreeLevels	= 1000;
		
		exercise	= new 	CExercise_American(0,T, GregorianCalendar.YEAR);
		priceModel	= new 	CBinomialTree(numberOfTreeLevels);
		
		COption		anAmericanOption = new COption(discounting,
				                                   equity,
				                                   exercise,
				                                   payoff,
				                                   priceModel);
		
		price = anAmericanOption.Pricing();
		System.out.println("Fair Value = " + price + "\n");

		// ----------------------------------------------------------------------------------
		// Bermuda Option 
		
		Hashtable<Double,String>	exerciseTimes = new Hashtable<Double,String>(50,0.75f);
		
		int 	exerciseDatesNumber	    =	 5;
		double  exerciseTimeYear        =    0;
		double  deltaT                  =    T/exerciseDatesNumber;
		for(int i = 1; i <= exerciseDatesNumber; i++){
			exerciseTimeYear = i * deltaT;
			exerciseTimes.put(new Double(exerciseTimeYear),"***");
		}
		
		exercise	= new 	CExercise_Bermuda(T, exerciseTimes);

		COption		aBermudaOption = new COption(discounting,
                								 equity,
                								 exercise,
                								 payoff,
                								 priceModel);
		
		price = aBermudaOption.Pricing();
		System.out.println("Fair Value = " + price + "\n");

		// ----------------------------------------------------------------------------------
		// barrier option 
		
		CBarrier 	barrier = new CBarrier(30000,30000);
		
		exercise	= 	new CExercise_European(T, GregorianCalendar.YEAR);
		payoff		=	new CPayoff_CallDownOut(K, barrier);
		
		priceModel	= new CBlackScholes();
		
		COption aBarrierOption = new COption(discounting,
                                     equity,
                                     exercise,
                                     payoff,
                                     priceModel);

        price = aBarrierOption.Pricing();

        System.out.println("Fair Value = " + price + "\n");
		
		// ----------------------------------------------------------------------------------
        // Compound Option
        
        exercise	= 	new CExercise_European(T, GregorianCalendar.YEAR);
		payoff		=	new CPayoff_PutPV(K);

		COption simpleOption = new COption(discounting,
						                   equity,
                                           exercise,
                                           payoff,
                                           null);
       
        exercise	= 	new CExercise_European(0.5 * T, GregorianCalendar.YEAR);
		payoff		=	new CPayoff_CallPV(900.0);
        priceModel	= 	new CBlackScholes_Compound();
        
		COption compoundOption = new COption(discounting,
                							 simpleOption,
                                             exercise,
                                             payoff,
                                             priceModel);
        
        price = compoundOption.Pricing();

        System.out.println("Fair Value = " + price + "\n");
                
        // ----------------------------------------------------------------------------------
		// Now we price an asian option with Monte Carlo method. 

        S 		= 32450.25; 	// underlying level
		sigma	= 0.198750; 	// standard deviation of log ret of underlying
		K 		= 31750.00; 	// strike price
		T		= 1.000000;	// expiry (years)	
		r       = 0.024091;	// risk-free rate 
		   
		int     numberOfFixingDates	= 12;
		int     numberOfSimulations = 100000;
		int     numberOfSteps       = numberOfFixingDates;
		
		discounting = 	new CDiscounting(r);
		equity		= 	new CEquity(S, sigma);
        exercise	= 	new CExercise_European(1, GregorianCalendar.YEAR);
		payoff		=	new CPayoff_CallAsianAAvRate(K,
				                                     numberOfFixingDates);
		
		priceModel	=  	new CMonteCarlo(numberOfSimulations,
				                        numberOfSteps);
		
		COption		anAsianOption = new COption(discounting,
                                                equity,
                                                exercise,
                                                payoff,
                                                priceModel);
		
		price 		=	anAsianOption.Pricing();

        System.out.println("Fair Value = " + price + "\n");

        // ----------------------------------------------------------------------------------
        // Geometric Average Asian Option with Monte Carlo Method
        
        priceModel	=  	new CMonteCarlo(numberOfSimulations,
                                        numberOfSteps);
	
		payoff		=	new CPayoff_CallAsianGAvRate(K,
                                                     numberOfFixingDates);

		COption		aGeometricAsianOption = new COption(discounting,
                                                        equity,
                                                        exercise,
                                                        payoff,
                                                        priceModel);

		price 		=	aGeometricAsianOption.Pricing();

		System.out.println("Fair Value = " + price + "\n");
        
		// ----------------------------------------------------------------------------------
		// Geometric Average Asian Option Exact Solution
		
		priceModel  = new CBlackScholes_GeometricAsian();
		
		aGeometricAsianOption = new COption(discounting,
                                            equity,
                                            exercise,
                                            payoff,
                                            priceModel);

        price 		=	aGeometricAsianOption.Pricing();
		
		System.out.println("Fair Value = " + price + "\n");
		
//		 ----------------------------------------------------------------------------------
		
		
		
        System.out.println("\n END - Elaboration stop");
	}
}
