/*
 * Copyright (C) 2016 Dienst voor het kadaster en de openbare registers
 * 
 * This file is part of Imvertor.
 *
 * Imvertor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Imvertor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

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
	public static final String VC_IDENTIFIER = "$Id: Validator.java 7475 2016-03-23 10:54:06Z arjan $";

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
					succeeds = succeeds ? transformer.transformStep("system/cur-imvertor-filepath","properties/" + outname, "properties/" + xslname, "system/cur-imvertor-filepath") : false ;
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
