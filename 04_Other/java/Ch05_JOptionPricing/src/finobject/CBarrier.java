package finobject;

public class CBarrier 
{
	public static final int up_and_in 			= 0;
	public static final int up_and_out 			= 1;
	public static final int down_and_in 		= 2;
	public static final int down_and_out 		= 3;
	
	public static final int rebate_none			= 0;
	public static final int rebate_activation	= 1;
	public static final int rebate_expiration	= 2;
	
	/* attributes */
	
	private double 	lowerLevel		= 	0;
	private double 	upperLevel		=	0;
    private double 	rebate			=	0;
	private int 	rebateType		=	0;
	private int 	exerciseType	= 	0;

	/* inspectors */

	public double 	getLowerLevel()		{return lowerLevel;}
    public double 	getUpperLevel() 	{return upperLevel;}
	public double 	getRebate()			{return rebate;}
	public int 		getRebateType() 	{return rebateType;}
	public int 		getExerciseType() 	{return exerciseType;}
	
	/* constructors */
		
	public CBarrier(double upperLevel, 
			        double lowerLevel)
	{
		this.upperLevel 	= 	upperLevel;
		this.lowerLevel		=	lowerLevel;
	}
	
	public CBarrier(double upperLevel,
			        double lowerLevel,
			        double rebate,
			        int    rebateType,
			        int    exerciseType)
	{
		this.upperLevel 	=	upperLevel;
		this.lowerLevel		=	lowerLevel;
		this.rebate			=	rebate;
		this.rebateType		=	rebateType;
		this.exerciseType	=	exerciseType;
	}
}
