package jexcalibur.scheduler;


public interface IInterval {

	public abstract int 	period();
	public abstract int 	periodMultiplier();
	public abstract String 	periodCode();
}
