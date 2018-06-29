package jexcalibur.scheduler;

import java.util.*;
import java.text.*;

public class CPeriod {

	/* properties */
	private GregorianCalendar 	firstDate;
	private GregorianCalendar 	lastDate;
	private GregorianCalendar 	firstRegularDate;
	private GregorianCalendar 	lastRegularDate;
	
	private int 				codDayCount 	= -1;
	private int 				codAdjustment 	= -1;
	private int 				codFrequency	= -1;
	
	private double              intervalBetweenDates[];
	private ArrayList<GregorianCalendar>		unadjustedDates;
	private ArrayList<GregorianCalendar>   		adjustedDates;
	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * Constructor 
	 * 
	 */
	public CPeriod(String 	firstDate, 
			       String 	lastDate, 
			       String 	firstRegularDate, 
			       String 	lastRegularDate, 
			       int 		codDayCount, 
			       int 		codAdjustment, 
			       int 		codFrequency)
	{
		DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT);
		try
		{
			System.out.println("");
			
			Date _firstDate			= df.parse(firstDate);
			Date _lastDate 			= df.parse(lastDate);
			Date _firstRegularDate 	= df.parse(firstRegularDate);
			Date _lastRegularDate 	= df.parse(lastRegularDate);
			
			this.firstDate			= new GregorianCalendar();
			this.lastDate			= new GregorianCalendar();
			this.firstRegularDate   = new GregorianCalendar();
			this.lastRegularDate	= new GregorianCalendar();
			
			unadjustedDates			= new ArrayList<GregorianCalendar>();
			adjustedDates			= new ArrayList<GregorianCalendar>();
			
			this.firstDate.setTime(_firstDate);
			this.lastDate.setTime(_lastDate);
			this.firstRegularDate.setTime(_firstRegularDate);
			this.lastRegularDate.setTime(_lastRegularDate);
			
			this.codFrequency       = codFrequency;
			this.codDayCount        = codDayCount;
			this.codAdjustment      = codAdjustment;
		}
		catch(ParseException e)
		{
			System.out.println("Unable to parse String Date");
		}
	}
	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * create the schedule. 
	 * 
	 */
	public ArrayList<GregorianCalendar> createSchedule()
	{
		GregorianCalendar currentDate = (GregorianCalendar)firstRegularDate.clone();
        
		/* create an object of type Interval */
		CInterval_Factory	factoryInterval	= new CInterval_Factory();
		IInterval freq = factoryInterval.createInstance(codFrequency);
		
		if(firstDate.before(firstRegularDate))
			unadjustedDates.add(firstDate);

		while(currentDate.before(lastRegularDate))
		{
			unadjustedDates.add((GregorianCalendar)currentDate.clone());
			currentDate.add(freq.period(),freq.periodMultiplier());
		}
		unadjustedDates.add((GregorianCalendar)currentDate.clone());
		
		if(lastDate.after(lastRegularDate))
			unadjustedDates.add(lastDate);
	
		return unadjustedDates;
	}
	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * adjust the schedule. 
	 * 
	 */
	public ArrayList adjustSchedule()
	{
		GregorianCalendar 	date		= null;
		CDateUtility 		dateUtility = new CDateUtility();
		
		Iterator i = unadjustedDates.iterator();
		
		if(codAdjustment > 0)
		{
			/* create an object of type Day Adjustment */
			CDayAdjustment_Factory	factoryDayAdj	= new CDayAdjustment_Factory();
			IDayAdjustment adj = factoryDayAdj.createInstance(codAdjustment);
			
			while(i.hasNext())
			{
				date = (GregorianCalendar)((GregorianCalendar)i.next()).clone();
				if(dateUtility.IsHoliday(date))
					adj.modify(date);
				adjustedDates.add(date);
			}
		}
		else
		{
			while(i.hasNext())
			{
				date = (GregorianCalendar)((GregorianCalendar)i.next()).clone();
				adjustedDates.add(date);
			}
		}
		return adjustedDates;
	}
	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * create intervals between dates. 
	 * 
	 */
	public double[] createIntervals()
	{
		GregorianCalendar 	begin = null;
		GregorianCalendar   end   = null;
		/* create an object of type CDayCount_Factory */
		CDayCount_Factory dayCountFactory = new CDayCount_Factory();
		/* create an instance of the appropriate Day Count object */
		IDayCount dayCount = dayCountFactory.createInstance(codDayCount);
		
		intervalBetweenDates = new double[adjustedDates.size()];
		for(int i = 0;i < adjustedDates.size() - 1;i++)
		{
			begin = (GregorianCalendar)((GregorianCalendar)adjustedDates.get(i)).clone();
			end   = (GregorianCalendar)((GregorianCalendar)adjustedDates.get(i+1)).clone();
			
			double delta = dayCount.Calculate(begin,end);
			
			intervalBetweenDates[i] = delta;
		}
		return intervalBetweenDates;
	}
	/*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * print on file of array list elements. 
	 * 
	 */
	public void printOut()
	{
		GregorianCalendar 	bufferDate 		= null;
		Date				currentDate 	= new Date();
		String              sDate_1      	= new String();
		String              sDate_2	        = new String();
		//DateFormat 			df				= DateFormat.getDateInstance();

		for(int i = 0; i < unadjustedDates.size();i++)
		{
			bufferDate 		= (GregorianCalendar) unadjustedDates.get(i);
			currentDate		= bufferDate.getTime();
			sDate_1         = currentDate.toString();
			//sDate_1       	= DateFormat.getDateInstance(DateFormat.SHORT).format(currentDate);
				
			bufferDate	 	= (GregorianCalendar) adjustedDates.get(i);
			currentDate		= bufferDate.getTime();
			sDate_2         = currentDate.toString();
			//sDate_2       	= DateFormat.getDateInstance(DateFormat.SHORT).format(currentDate);

			System.out.println(sDate_1 + " - " + sDate_2 + " - " + intervalBetweenDates[i]);
		}
	}
}
