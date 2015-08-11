package polyhedron.wileybook.ch02;

/**
 * @uml.dependency   supplier="polyhedron.wileybook.ch01.COption_American.COption_American"
 * @uml.dependency   supplier="polyhedron.wileybook.ch01.CMonteCarlo.Simulation"
 * @uml.dependency   supplier="polyhedron.wileybook.ch01.COption_European.COption_European"
 * @uml.dependency   supplier="polyhedron.wileybook.ch01.CMonteCarlo.CMonteCarlo"
 */
public class Application {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		System.out.println("Start Calculation");
		
		COption_American	american_Option = new COption_American(1.0,1.0,0.02,0.25,0.20,0);
		COption_European    european_Option = new COption_European(1.0,1.0,0.02,0.25,0.20,0);
		
		CMonteCarlo			monte_carlo = new CMonteCarlo();
		
		monte_carlo.Simulation(american_Option);
		monte_carlo.Simulation(european_Option);
		
		System.out.println("End Calculation");
		
	}

}
