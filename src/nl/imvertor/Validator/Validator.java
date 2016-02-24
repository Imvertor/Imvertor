package nl.imvertor.Validator;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;

import org.apache.log4j.Logger;


/**
 * Validate an Imvertor file in accordance with a particular Metamodel
 *  
 * 
 * @author arjan
 *
 */
public class Validator extends Step {

	protected static final Logger logger = Logger.getLogger(Validator.class);
	
	public static final String STEP_NAME = "Validator";
	public static final String VC_IDENTIFIER = "$Id: Validator.java 7419 2016-02-09 15:42:49Z arjan $";

	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Validating model");

			String mm = configurator.getParm("cli","metamodel");
					
			// create a transformer
			Transformer transformer = new Transformer();
			    
		    // transform 
			boolean succeeds = true;

			// CANONIZATION IN STEPS; 
			// each second, third... step is known as _2, _3 etc. in the parameter sequence as configured.
			// first step has no sequence number.
			int i = 1;
			while (true) {
				String xslname = "IMVERTOR_METAMODEL_" + mm + "_CANONICAL_XSLPATH" + ((i == 1) ? "" : "_" + i);
				String outname = "WORK_BASE_METAMODEL_FILE" + ((i == 1) ? "" : "_" + i);
				if (configurator.getParm("properties", xslname, false) != null) {
					// curpath is "properties/WORK_BASE_FILE", 
					succeeds = succeeds ? transformer.transformStep("system/cur-imvertor-filepath","properties/" + outname, "properties/" + xslname, "cur-imvertor-filepath") : false ;
					i += 1;
				} else break;
			}

			// VALIDATION IN STEPS
			int j = 1;
			while (true) {
				String xslname = "IMVERTOR_METAMODEL_" + mm + "_VALIDATE_XSLPATH" + ((j == 1) ? "" : "_" + j);
				String outname = "WORK_VALIDATE_FILE" + ((j == 1) ? "" : "_" + j);
				if (configurator.getParm("properties", xslname, false) != null) {
					succeeds = succeeds ? transformer.transformStep("system/cur-imvertor-filepath", "properties/" + outname, "properties/" + xslname) : false ;
					j += 1;
				} else break;
			}
			
			// final validation
			succeeds = succeeds ? transformer.transformStep("system/cur-imvertor-filepath", "properties/WORK_VALIDATE_FILE", "properties/IMVERTOR_VALIDATE_XSLPATH") : false ;

			// we now know the application name and should show it. 
			runner.info(logger, "Compiled name: " + configurator.getParm("appinfo","release-name"));
			
			configurator.setStepDone(STEP_NAME);
			
			// save any changes to the work configuration for report and future steps
		    configurator.save();
		    
		    report();
		    
		    return runner.succeeds() && succeeds;
			
		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	

}
