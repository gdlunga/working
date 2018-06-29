	package pricing_algorithm;
	
	import finobject.COption;
	
	public class CBlackScholes_Compound extends CBlackScholes {
	
			
			/**
			 * note: this method overwrite the Execute method of the super class
			 * CBlackScholes
			 */
			public double Execute(COption option){
				return BS_Compound(option);
			}
			/**
			 * --------------------------------------------------------------------------------
			 * Function Name
			 * @author Giovanni Della Lunga
			 * @param  option	the option to be evaluated  
			 * @return option fair value
			 */
			private double BS_Compound(COption option)
			{
					System.out.println("Running Black & Scholes Algorithm for Compound Option");
					option.printOut();
					
					CNormST 		N	=	new CNormST();
					CNormBivariate 	M 	= 	new CNormBivariate();
					
					double price = 0;
					
					/* gathering information about the compound and underlying option */
					
					double 		T1 		= option.getExercise().getExpirationTime();
					double 		K1 		= option.getPayoff().getStrike();
					double      r  		= (option.getDiscounting()).getDiscountRate();
					double      q   	= 0;
					int         theta1  = 0;
					if((option.getPayoff()).value(K1 + 1) > 0 )
						theta1 = 1;
					else
						theta1 = -1;
	
					COption underOption = new COption();
					underOption = (COption)option.getUnderlying();
					
					double      T2      = underOption.getExercise().getExpirationTime();
					double      K2      = underOption.getPayoff().getStrike();
					double  	S0		= underOption.getUnderlying().getLevel();
					double		sigma	= underOption.getUnderlying().getVolatility();
					int         theta2  = 0;
					if((underOption.getPayoff()).value(K2 + 1) > 0 )
						theta2 = 1;
					else
						theta2 = -1;
					
					/* first of all we search for the asset price at time T1 for which the underlying option
					 * value at time T1 equals K1 where T1 is the exercise time of  the compound option  and 
					 * K1 its strike value. The computation of this value is performed with a simple Newton-
					 * Rapson algorithm for a more robust procedure we strongly suggest to replace  with the
					 * secant method. 
					 */
					
					double zero			= 0;
					double optionPrice  = 0;
					double delta    	= 0;
					double correction 	= 0;
					double S        	= S0;
					double ERROR 		= 1e-6; 
					
					do{
						optionPrice = BS_Formula(theta2,S, K2, T1, r,q,sigma);
						zero 		= K1 - optionPrice;
						delta 		= BS_Delta(theta2,S, K2, T1, r,q,sigma);			
						correction	= zero/delta;
						S			= S + correction;
					}while(Math.abs(correction) > ERROR);
					
					double a1	=	(Math.log(S0/S) + (r - q + 0.5*sigma*sigma)*T1)/(sigma*Math.sqrt(T1));
					double a2	=	a1 - sigma*Math.sqrt(T1);
					
					double b1	=	(Math.log(S0/K2) + (r - q + 0.5*sigma*sigma)*T2)/(sigma*Math.sqrt(T2));
					double b2	=	b1 - sigma*Math.sqrt(T2);
					
					double ert1 = 	Math.exp(-r*T1);
					double ert2 = 	Math.exp(-r*T2);
					double eqt2 = 	Math.exp(-q*T1);
					double rtt  =   Math.sqrt(T1/T2);
					
					if(theta1 == CALL && theta2 == CALL){
						price	=	S0*eqt2*M.Cum( a1, b1, rtt) - K2*ert2*M.Cum( a2, b2, rtt) - ert1*K1*N.Cum( a2);
					}
					else if(theta1 == CALL && theta2 == PUT){
						price	=	K2*ert2*M.Cum(-a2,-b2, rtt) - S0*eqt2*M.Cum(-a1,-b1, rtt) - ert1*K1*N.Cum(-a2);
					}
					else if(theta1 == PUT && theta2 == CALL){
						price	=	K2*ert2*M.Cum(-a2, b2,-rtt) - S0*eqt2*M.Cum(-a1, b1,-rtt) + ert1*K1*N.Cum(-a2);
					}
					else if(theta1 == PUT && theta2 == PUT){
						price	=	S0*eqt2*M.Cum( a1,-b1,-rtt) - K2*ert2*M.Cum( a2,-b2,-rtt) + ert1*K1*N.Cum( a2);
					}
					
					return price;
			}
	
	}
