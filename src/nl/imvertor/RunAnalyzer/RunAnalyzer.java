package nl.imvertor.RunAnalyzer;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;

import org.apache.log4j.Logger;

/**
 * Analyse the full run results and pass info to the parms file for final processing (reporting).
 * 
 * @author arjan
 *
 */
public class RunAnalyzer extends Step {

	protected static final Logger logger = Logger.getLogger(RunAnalyzer.class);
	
	public static final String STEP_NAME = "RunAnalyzer";
	public static final String VC_IDENTIFIER = "$Id: RunAnalyzer.java 7419 2016-02-09 15:42:49Z arjan $";

	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger, "Analyzing this run");
			
			Transformer transformer = new Transformer();
			transformer.transformStep("system/cur-imvertor-filepath", "properties/WORK_ANALYZER_FILE", "properties/RUN_ANALYZER_XSL"); 
			//TODO general: also provide default empty input, and default empty output files.
			
			configurator.setStepDone(STEP_NAME);
			
		    // save any changes to the work configuration for report and future steps
		    configurator.save();
			
			// generate report
			report();
			
			return runner.succeeds();
			
		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	
}
