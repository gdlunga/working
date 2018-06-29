package pricing_algorithm;

import finobject.*;

public class CBlackScholes implements IPricing 
{
	static final int	CALL = 1;
	static final int	PUT  = -1;
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	public double Execute(COption option) 
	{
		if(option.getPayoff().getBarrier() != null){
			return BS_Barrier(option);
		}
		else{
			return BS_PlainVanilla(option);
		}
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double BS_Barrier(COption option)
	{
			System.out.println("Running Black & Scholes Algorithm for Barrier Option");
			option.printOut();

			int			Omega 			= 	1;
		   	int			barrierType 	= 	option.getPayoff().getBarrier().getExerciseType();	
		   	int         rebateType		=   option.getPayoff().getBarrier().getRebateType();
		   	int			payoffType		=   0;

		   	double      price   	= 0;
			double      q           = 0;
			double		S   		= (option.getUnderlying()).getLevel();
			double      sigma		= (option.getUnderlying()).getVolatility();
			double      K       	= (option.getPayoff()).getStrike();
			double      r       	= (option.getDiscounting()).getDiscountRate();
			double      T       	= (option.getExercise()).getExpirationTime();
			double      rebate		= (option.getPayoff()).getBarrier().getRebate();
			double      H			= (option.getPayoff()).getBarrier().getLowerLevel();
			
			if((option.getPayoff()).value(K + 1) > 0 )
				payoffType = CALL;
			else
				payoffType = PUT;

			if(option.getUnderlying().getActivityType() == CFinancialActivity.EQUITY){
				q = ((CEquity)option.getUnderlying()).getDividendYield();
			}
			else if (option.getUnderlying().getActivityType() == CFinancialActivity.FOREX){
				q = ((CForex)option.getUnderlying()).getFxRate();
			}
			
		   if(payoffType == PUT) Omega = -1;

		   int Theta = 1;
		   if(barrierType == CBarrier.up_and_in || barrierType == CBarrier.up_and_out) Theta = -1; 	

		   if((payoffType == PUT && barrierType == CBarrier.down_and_out) || (payoffType == CALL && barrierType == CBarrier.up_and_out))
		   {
			   price = UCDPOT(Omega, Theta, r, q, sigma, T, H, K, S);	
			   if(rebateType == CBarrier.rebate_activation)
			   {
				   rebate = ROUT(1, Theta, r, q, sigma, T, H, K, S, rebate);
			   }
			   else if(rebateType == CBarrier.rebate_expiration)
			   {
				   rebate = ROUT(0, Theta, r, q, sigma, T, H, K, S, rebate);
			   }
		   }
		   else if((payoffType == PUT && barrierType == CBarrier.up_and_in) || (payoffType == CALL && barrierType == CBarrier.down_and_in))
		   {

			   /* test values - see Huang "Exotic Options" Example 10.22 p. 247 */
		       /*  
			   S			=	100;
			   K			=	98;
			   H			=	95;
			   sigma		=	0.20;
			   r			=	0.08;
			   q			=	0.03;
			   T			=	0.5;
		       */

			   price	= DCUP(Omega, Theta, r, q, sigma, T, H, K, S);

			   if(rebateType == CBarrier.rebate_expiration)
			   {
				   rebate = RBIN(Theta,r, q, sigma, T, H, K, S,rebate);
			   }
		   }
		   else if((payoffType == PUT && barrierType == CBarrier.down_and_in) || (payoffType == CALL && barrierType == CBarrier.up_and_in))
		   {
			   price = UCDP(Omega, Theta, r, q, sigma, T, H, K, S);
			   if(rebateType == CBarrier.rebate_expiration)
			   {
				   rebate = RBIN(Theta,r, q, sigma, T, H, K, S,rebate);
			   }
		   }
		   else if((payoffType == PUT && barrierType == CBarrier.up_and_out) || (payoffType == CALL && barrierType == CBarrier.down_and_out))
		   {
			   price = DCUPOT(Omega, Theta, r, q, sigma, T, H, K, S);
			   if(rebateType == CBarrier.rebate_activation)
			   {
				   rebate = ROUT(1, Theta, r, q, sigma, T, H, K, S, rebate);
			   }
			   else if(rebateType == CBarrier.rebate_expiration)
			   {
				   rebate = ROUT(0, Theta, r, q, sigma, T, H, K, S, rebate);
			   }
		   }
			
		   if(price < 0) price = 0;
		
		return price;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double UCDPOT(int Omega, 
			              int Theta,
			              double r,
			              double q,
			              double sigma,
			              double T,
			              double H,
			              double K,
			              double S){

		CNormST		N			= new CNormST();
		
		double nu	            = r - q - sigma * sigma / 2.0;
		double Discount			= Math.exp(-r * T);
		double thk				= Theta * (H - K);
		double hy				= Math.pow((H / S),(2 * nu / (sigma * sigma)));

		double b1 = BS_Formula(Omega, S, K, T,r, q, sigma);
		double b2 = BS_Formula(Omega, S, H, T, r, q, sigma);
	    double b3 = BS_Formula(Omega, H * H / S, K, T, r, q, sigma);
	    double b4 = BS_Formula(Omega, H * H / S, H, T, r, q, sigma);

	    double d2_1	= Omega * (Math.log(S/H) + (r - q - sigma*sigma/2.0)*T)/(sigma*Math.sqrt(T));
	    double d2_2	= Omega * (Math.log(H/S) + (r - q - sigma*sigma/2.0)*T)/(sigma*Math.sqrt(T));

	    double n1 = N.Cum(d2_1);
	    double n2 = N.Cum(d2_2);
	    
	    if(Omega * H > Omega * K){
	        return b1 - b2 + thk * Discount * n1 - hy * (b3 - b4 + thk * Discount * n2);
		}
	    else
	    	return 0;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double ROUT(int flag, 
			            int Theta,
    					double r,
    					double q,
    					double sigma,
    					double T,
    					double H,
    					double K,
    					double S,
    					double rebate){

		CNormST		N			= new CNormST();

		double rout = 0.0;

	    double Discount = Math.exp(-r * T);
	    double nu            = r - q - sigma * sigma / 2.0;
	    double hy            = Math.pow((H / S),(2 * nu / (sigma * sigma)));

	    double d2_1	= -Theta * (Math.log(S/H) + (r - q - sigma*sigma/2.0)*T)/(sigma*Math.sqrt(T));
	    double d2_2	= Theta * (Math.log(H/S) + (r - q - sigma*sigma/2.0)*T)/(sigma*Math.sqrt(T));

	    if(flag == 0) /* rebate a scadenza */
		{
	        rout = Discount * rebate * (N.Cum(d2_1) + hy * N.Cum(d2_2));
		}
	    else
		{
	        rout = Math.pow((H / S), small_q(nu, r, sigma, 1)) * N.Cum(Theta * big_q(nu, r, sigma, S, H, T, 1));
	        rout += Math.pow((H / S), small_q(nu, r, sigma, -1)) * N.Cum(Theta * big_q(nu, r, sigma, S, H, T, -1));
	        rout *= rebate;
	    }
	    if(rout < 0) rout = 0.0;
			
		return rout;

	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double DCUP(int Omega, 
            			int Theta,
            			double r,
            			double q,
            			double sigma,
            			double T,
            			double H,
            			double K,
            			double S){

		CNormST		N			= new CNormST();
	
		double dcup = 0.0;

	    if((Omega == 1 && S < H) || (Omega == -1 && S > H))
		{
			dcup = BS_Formula(Omega, S, K, T, r, q, sigma);
			return dcup;
		}

	    double Discount = Math.exp(-r * T);
	    double nu = r - q - sigma * sigma / 2.0;
	    double hy = Math.pow((H / S) , (2 * nu / (sigma * sigma)));
	    double thk = Theta * (H - K);
	    double tok = Theta * (OMax(Omega, H, K) - K);

	    double b1 = BS_Formula(Omega, (H * H) / S, OMax(Omega, H, K), T, r, q, sigma);
	    double b2 = BS_Formula(-Theta, S, K, T, r, q, sigma);
	    double b3 = BS_Formula(-Theta, S, H, T, r, q, sigma);

	    double d2_1 = Omega * BS_d2(H * H / S, OMax(Omega, H, K), T, r, q, sigma);
	    double d2_2 = -Theta * BS_d2(S, H, T, r, q, sigma);

	    dcup = hy * (b1 + tok * Discount * N.Cum(d2_1));
	    if(Theta * H > Theta * K)
		{
			dcup += b2 - b3 + thk * Discount * N.Cum(d2_2);
		}
		
		return dcup;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double OMax(int omega, double H, double K){

		double a = omega * H;
		double b = omega * K;

		double Max = omega * a;
		if (b > a) Max = omega * b;

		return Max;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double RBIN(int Theta,
						double r,
						double q,
						double sigma,
						double T,
						double H,
						double K,
						double S,
						double rebate){

		CNormST		N			= new CNormST();
	
	    double Discount = Math.exp(-r * T);
	    double nu = r - q - sigma * sigma / 2.0;
	    double hy = Math.pow((H / S), (2 * nu / (sigma * sigma)));

	    double d2_1 = Theta * BS_d2(S, H, T, r, q, sigma);
	    double d2_2 = Theta * BS_d2(H, S, T, r, q, sigma);

	    double rbin = Discount * rebate * (N.Cum(d2_1) - hy * N.Cum(d2_2));

	    if(rbin < 0) rbin = 0;
			
		return rbin;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double UCDP(int Omega, 
            			int Theta,
            			double r,
            			double q,
            			double sigma,
            			double T,
            			double H,
            			double K,
            			double S)
	{
		CNormST		N			= new CNormST();

		double Discount = Math.exp(-r * T);
	    double nu = r - q - sigma * sigma / 2.0;
	    double hy = Math.pow((H / S), (2 * nu / (sigma * sigma)));
	    double thk = Omega * (H - K);
	    double tok = Omega * (OMax(Omega, H, K) - K);

	    double b1 = BS_Formula(Theta, (H * H) / S, K, T, r, q, sigma);
	    double b2 = BS_Formula(Theta, (H * H) / S, H, T, r, q, sigma);
	    double b3 = BS_Formula(-Theta, S, OMax(Omega, H, K), T, 
	    		r, q, sigma);

	    double d2_1 = Theta * BS_d2(H, S, T, r, 
	    		q, sigma);
	    double d2_2 = Omega * BS_d2(S, OMax(Omega, H, K), T, 
	    		r, q, sigma);

	    double ucdp = b3 + tok * Discount * N.Cum(d2_2);
	    if(Omega * H > Omega * K){
	    	ucdp += hy * (b1 - b2 + thk * Discount * N.Cum(d2_1));
	    }
		
		return ucdp;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double DCUPOT(	int Omega, 
            				int Theta,
            				double r,
            				double q,
            				double sigma,
            				double T,
            				double H,
            				double K,
            				double S)
	{
		CNormST		N			= new CNormST();

		Boolean Condizione_1 = (Omega == 1 && (S < H));
	    Boolean Condizione_2 = (Omega == -1 && (S > H));

	    if(Condizione_1||Condizione_2)
		{
			return 0;
		}
	    
	    double Discount = Math.exp(-r * T);
	    double nu = r - q - sigma * sigma / 2.0;
	    double hy = Math.pow((H / S) , (2 * nu / (sigma * sigma)));
	    double tok = Theta * (OMax(Omega, H, K) - K);

	    double b1 = BS_Formula(Theta, S, OMax(Omega, H, K), T, r, q, sigma);
	    double b2 = BS_Formula(Theta, (H * H) / S, OMax(Omega, H, K), T, r, q, sigma);

	    double d2_1 = Theta * BS_d2(S, OMax(Omega, H, K), T, r, q, sigma);
	    double d2_2 = Theta * BS_d2((H * H) / S, OMax(Omega, H, K), T, r, q, sigma);
	    
	    double dcupot = b1 - hy * b2 + tok * Discount * (N.Cum(d2_1) - hy * N.Cum(d2_2));

		return dcupot;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double BS_PlainVanilla(COption option)
	{
		System.out.println("Running Black & Scholes Algorithm");
		option.printOut();
		
		int		    theta   	= 0;
		double      q           = 0;
		double		S   		= (option.getUnderlying()).getLevel();
		double      sigma		= (option.getUnderlying()).getVolatility();
		double      K       	= (option.getPayoff()).getStrike();
		double      r       	= (option.getDiscounting()).getDiscountRate();
		double      T       	= (option.getExercise()).getExpirationTime();

		if((option.getPayoff()).value(K + 1) > 0 )
			theta = 1;
		else
			theta = -1;
		
		return BS_Formula(theta,S,K,T,r,q,sigma);
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param  theta = 1 for call options, -1 for put options   
	 * @return 
	 */
	protected double BS_Formula(int theta, 
			                  double S, 
			                  double K, 
			                  double T,
			                  double r, 
			                  double q, 
			                  double sigma){

		CNormST		N			= new CNormST();
		
		double      price		= 0;	
		
		if(T > 0)
		{
			double      d1		= BS_d1(S, K, T, r, q, sigma);
			double      d2      = BS_d2(S, K, T, r, q, sigma);
		
			price = theta*(S*Math.exp(-q*T)*N.Cum(theta*d1) - K*Math.exp(-r*T)*N.Cum(theta*d2));
		}
		else if (T == 0)
		{
			// TO DO: return payoff
			price = 0;
		}
		else{
			price = -1;
		}
		
		return price;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double BS_Delta(int theta, 
			                double S, 
			                double K, 
			                double T,
			                double r, 
			                double q, 
			                double sigma){

		CNormST		N			= new CNormST();
		
		double      delta		= 0;	
		
		if(T > 0)
		{
			double      d1		= BS_d1(S, K, T, r, q, sigma);

			delta = theta*Math.exp(-q*T)*N.Cum(theta*d1);
		}
		else
		{
			delta = 0;
		}
		
		return delta;
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double BS_d1(	double S, 
            				double K, 
            				double T,
            				double r, 
            				double q, 
            				double sigma){
		
		return (Math.log(S/K) + (r + sigma*sigma/2.0)*T)/(sigma*Math.sqrt(T));
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double BS_d2(	double S, 
							double K, 
							double T,
							double r, 
							double q, 
							double sigma){
		
		return BS_d1(S, K, T, r, q, sigma) - sigma*Math.sqrt(T);
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double small_q(double nu, double r, double sigma, int i)
	{
		return (nu + i * psi(nu, r, sigma)) / (sigma * sigma);
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double psi(double nu, double r, double sigma)
	{
		return Math.sqrt(nu * nu + 2 * r * sigma * sigma);
	}
	/**
	 * --------------------------------------------------------------------------------
	 * Function Name
	 * @author Giovanni Della Lunga
	 * @param    
	 * @return 
	 */
	protected double big_q(double nu, double r, double sigma, double y, double H, double t, int i)
	{
		return (Math.log(H / y) + i * t * psi(nu, r, sigma)) / (sigma * Math.sqrt(t));
	}

}
