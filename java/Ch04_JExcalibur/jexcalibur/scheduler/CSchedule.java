package jexcalibur.scheduler;


public class CSchedule {

	/**
	 * @uml.property  name="Dates" multiplicity="(0 -1)" dimension="1"
	 */
	private int[] dates;

	/**
	 * Getter of the property <tt>Dates</tt>
	 * @return  Returns the dates.
	 * @uml.property  name="Dates"
	 */
	public int[] getDates() {
		return dates;
	}

	/**
	 * Setter of the property <tt>Dates</tt>
	 * @param Dates  The dates to set.
	 * @uml.property  name="Dates"
	 */
	public void setDates(int[] dates) {
		this.dates = dates;
	}

	/** 
	 * @uml.property name="Times" multiplicity="(0 -1)" dimension="1"
	 */
	private double[] times;

	/** 
	 * Getter of the property <tt>Times</tt>
	 * @return  Returns the times.
	 * @uml.property  name="Times"
	 */
	public double[] getTimes() {
		return times;
	}

	/** 
	 * Setter of the property <tt>Times</tt>
	 * @param Times  The times to set.
	 * @uml.property  name="Times"
	 */
	public void setTimes(double[] times) {
		this.times = times;
	}

	/**
	 * @uml.property  name="Count"
	 */
	private int count;

	/**
	 * Getter of the property <tt>Count</tt>
	 * @return  Returns the count.
	 * @uml.property  name="Count"
	 */
	public int getCount() {
		return count;
	}

	/**
	 * Setter of the property <tt>Count</tt>
	 * @param Count  The count to set.
	 * @uml.property  name="Count"
	 */
	public void setCount(int count) {
		this.count = count;
	}

}
