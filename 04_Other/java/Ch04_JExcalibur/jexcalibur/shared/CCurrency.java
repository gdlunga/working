package jexcalibur.shared;


public class CCurrency {

	/**
	 * @uml.property  name="unit"
	 */
	public String unit = "";

	/**
	 * Getter of the property <tt>unit</tt>
	 * @return  Returns the unit.
	 * @uml.property  name="unit"
	 */
	public String getUnit() {
		return unit;
	}

	/**
	 * Setter of the property <tt>unit</tt>
	 * @param unit  The unit to set.
	 * @uml.property  name="unit"
	 */
	public void setUnit(String unit) {
		this.unit = unit;
	}

	/**
	 * @uml.property  name="value"
	 */
	public double value;

	/**
	 * Getter of the property <tt>value</tt>
	 * @return  Returns the value.
	 * @uml.property  name="value"
	 */
	public double getValue() {
		return value;
	}

	/**
	 * Setter of the property <tt>value</tt>
	 * @param value  The value to set.
	 * @uml.property  name="value"
	 */
	public void setValue(double value) {
		this.value = value;
	}

}
