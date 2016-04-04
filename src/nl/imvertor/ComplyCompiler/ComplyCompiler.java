/*
 * Copyright (C) 2016 VNG/KING
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

package nl.imvertor.ComplyCompiler;

import org.apache.log4j.Logger;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.file.AnyFolder;
import nl.imvertor.common.file.XmlFile;
import nl.imvertor.common.file.ZipFile;

public class ComplyCompiler  extends Step {

	protected static final Logger logger = Logger.getLogger(ComplyCompiler.class);
	
	public static final String STEP_NAME = "ComplyCompiler";
	public static final String VC_IDENTIFIER = "$Id: ReleaseCompiler.java 7473 2016-03-22 07:30:03Z arjan $";
	
	/**
	 *  run the step
	 */
	public boolean run() {
		
		try {
			if (configurator.isTrue("cli","createcomplyexcel")) {
				
				// set up the configuration for this step
				configurator.setActiveStepName(STEP_NAME);
				prepare();
				runner.info(logger,"Compiling Compliancy Excel");
				
				// fetch the template file, and serialize it to a folder
				String templateFilepath = configurator.getParm("properties", "IMVERTOR_COMPLY_TEMPLATE_EXCELPATH", true);
				String unzipFolderpath = configurator.getParm("properties", "WORK_COMPLY_TEMPLATE_FOLDERPATH", true);
	
				ZipFile template = new ZipFile(templateFilepath);
				AnyFolder serializeFolder = new AnyFolder(unzipFolderpath);
				template.serializeToXml(serializeFolder);
				
				// in the exported file we find _content.xml, which is the base for all transformations and holds all XML content found.
				// transform the exported folder any way required, on the basis of _content,xml.
				// When done, the results will be compressed back, except for the _content,xml.
				Transformer transformer = new Transformer();
		
				XmlFile contentFile = new XmlFile(serializeFolder,"__content.xml");
				configurator.setParm("system", "comply-content-file", contentFile.getCanonicalPath());
				transformer.transformStep("system/comply-content-file","properties/WORK_COMPLY_FILE", "properties/WORK_COMPLY_XSLPATH");
				
				// replace the __content.xml file by the newly created workfile. 
				// And pack the result.
				// Store in the folder for result compliancy fill-in forms
				
				AnyFolder formFolder = new AnyFolder(configurator.getParm("properties","IMVERTOR_COMPLY_TARGET"));
				formFolder.mkdirs();
				
				String zipname = configurator.getParm("appinfo", "application-name") + ".xlsx";
				ZipFile formFile = new ZipFile(formFolder,zipname);
				
				XmlFile newContentFile = new XmlFile(configurator.getParm("properties","WORK_COMPLY_FILE",true));
				newContentFile.copyFile(contentFile);
				formFile.deserializeFromXml(serializeFolder,true);
				
				configurator.setParm("appinfo","compliancy-result-form-path",formFile.getCanonicalPath());
					
				configurator.setStepDone(STEP_NAME);
				 
				// save any changes to the work configuration for report and future steps
			    configurator.save();
			    
			    report();
			    
			}
			return runner.succeeds();
			
		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	
}
