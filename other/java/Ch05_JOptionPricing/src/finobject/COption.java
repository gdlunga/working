package finobject;

import pricing_algorithm.*;

public class COption extends CFinancialActivity {

	/* properties */

	private CFinancialActivity 	underlying		= null;
	private CExercise 			exercise		= null;
	private CPayoff 			payoff			= null;
	private CDiscounting 		discounting		= null;
	private IPricing			pricingModel	= null;

	/* inspectors */
	
	public CFinancialActivity getUnderlying()	{return underlying;}
	public CExercise getExercise()				{return exercise;}
	public CPayoff getPayoff()					{return payoff;}
	public CDiscounting getDiscounting()		{return discounting;}

	/* constructors */
	public COption(){
		
	}
	public COption(CDiscounting       discounting, 
		           CFinancialActivity underlying, 
		           CExercise          exercise, 
		           CPayoff            payoff,
		           IPricing           pricingModel)
	{
		this.discounting	=	discounting;
		this.underlying		=	underlying;
		this.exercise		=	exercise;
		this.payoff			=	payoff;
		this.pricingModel	=	pricingModel;

		activityType = CFinancialActivity.OPTION;
	}
	
	/* methods */
	
	public double Pricing()
	{
		return pricingModel.Execute(this);
	}
	
	public void printOut()
	{
		System.out.println("\n");
		payoff.printOut();
		exercise.printOut();
		underlying.printOut();
		discounting.printOut();
		System.out.println("\n");
	}
}
