package nl.imvertor;

import org.apache.log4j.Logger;

import nl.imvertor.Tester.Tester;
import nl.imvertor.common.Configurator;
import nl.imvertor.common.Release;


public class ChainTester {

	protected static final Logger logger = Logger.getLogger(ChainTester.class);
	
	public static void main(String[] args) {
		
		Configurator configurator = Configurator.getInstance();
		
		try {
			configurator.getRunner().info(logger, "Translate and report - " + Release.getVersionString());
			
			configurator.prepare(); // note that the process config is relative to the step folder path
			configurator.getRunner().prepare();
			
			// parameter processing
			configurator.getCli("common");
			configurator.getCli(Tester.STEP_NAME);
			
			configurator.setParmsFromOptions(args);
			configurator.setParmsFromEnv();
		
		    configurator.save();
		   
		    boolean succeeds = true;
		    		    
			// call single tester step
		    succeeds = (new Tester()).run();
			
			configurator.getRunner().windup();
			configurator.getRunner().info(logger, "Done, chain process " + (succeeds ? "succeeds" : "fails"));
		    if (configurator.getSuppressWarnings() && configurator.getRunner().hasWarnings())
		    	configurator.getRunner().info(logger, "** Warnings have been suppressed");

		} catch (Exception e) {
			configurator.getRunner().fatal(logger,"Please notify your administrator.",e);
		}
	}
}
