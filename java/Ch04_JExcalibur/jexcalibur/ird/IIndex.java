package jexcalibur.ird;

import java.util.GregorianCalendar;

public interface IIndex {
		/**
		 */
		public abstract double getValue(double time);
		/**
		 */
		public abstract double getValue(double[] times, double delta);
		/**
		 */
		public abstract double getValue(GregorianCalendar date);
		/**
		 */
		public abstract double getValue(GregorianCalendar[] dates, double delta);
}
