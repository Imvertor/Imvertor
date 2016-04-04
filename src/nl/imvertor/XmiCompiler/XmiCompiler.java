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

package nl.imvertor.XmiCompiler;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;
import nl.imvertor.common.exceptions.EnvironmentException;
import nl.imvertor.common.file.AnyFile;
import nl.imvertor.common.file.EapFile;
import nl.imvertor.common.file.XmiFile;
import nl.imvertor.common.file.XmlFile;

import java.io.File;

import org.apache.log4j.Logger;

/**
 * This step-class compiles an XMI file or passes a provides file provided,
 * and places it in the workspace. 
 *  
 * @author arjan
 *
 */
public class XmiCompiler extends Step {

	protected static final Logger logger = Logger.getLogger(XmiCompiler.class);
	
	public static final String STEP_NAME = "XmiCompiler";
	public static final String VC_IDENTIFIER = "$Id: XmiCompiler.java 7473 2016-03-22 07:30:03Z arjan $";

	private AnyFile passedFile;
	private XmlFile activeFile;
	private AnyFile idFile;
	private String activeFileOrigin;
	
	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Compiling XMI");

			// check what file is passed on the command line.
			
			AnyFile umlFile = new AnyFile(configurator.getFile(configurator.getParm("cli", "umlfile")));

			EapFile eapFile = umlFile.getExtension().toLowerCase().equals("eap") ? new EapFile(umlFile) : null;
			XmiFile xmiFile = umlFile.getExtension().toLowerCase().equals("xmi") ? new XmiFile(umlFile) : null;
			
			XmlFile masterFile = new XmlFile(configurator.getParm("properties","WORK_XMI_MASTER_FILE"));
			
			if (activeFileOrigin == null && xmiFile != null) {
				runner.debug(logger, "Try XMI file at: " + xmiFile);
				if (xmiFile.isFile()) {
					passedFile = xmiFile;
					activeFileOrigin = "XMI passed";
				}
			}
			if (activeFileOrigin == null && eapFile != null) {
			    runner.debug(logger,"Try EAP file at: " + eapFile);
			    if (!eapFile.isFile())
			    	throw new Exception("EAP file doesn't exist: " + eapFile);
			    else if (eapFile.isAccessible()) {
					passedFile = eapFile;
					activeFileOrigin = "EAP passed";
				} else 
					throw new EnvironmentException("EAP file found, but cannot access EA (on 32 bit java)");
				
			}	
			if (activeFileOrigin == null) {
				runner.debug(logger,"Try master file at: " + masterFile);
				if (masterFile.exists() && (masterFile.getContent().indexOf("UML:Package name=\"" + configurator.getParm("system","application.name") + "\"")) != -1) {
					passedFile = masterFile;
					activeFileOrigin = "XMI master";
				} 
			}
			if (activeFileOrigin == null) {
				throw new EnvironmentException("No such XMI or EAP file, and master XMI doesn't define the package \"" + configurator.getParm("system","application.name") + "\"");
			}
			
			String filespec = " " + passedFile + " (" + activeFileOrigin + ")";
			// process the EAP file when passed. 
			if (passedFile instanceof EapFile) {
				// IM-108 speed up: do not read same EAP twice
				String f1 = "";
				activeFile = new XmlFile(configurator.getParm("properties","WORK_XMI_FOLDER") + File.separator + passedFile.getName() + ".xmi");
				idFile = new AnyFile(activeFile.getCanonicalPath() + ".id");
				activeFile.getParentFile().mkdirs();
				if (activeFile.exists()) 
					f1 = (idFile.exists()) ? idFile.getContent() : "";
				String f2 = passedFile.getFileInfo();
				if (!f1.equals(f2)) {
					runner.info(logger,"Reading" + filespec);
					exportEapToXmi((EapFile) passedFile, activeFile);
					// and place file info in ID file
					idFile.setContent(passedFile.getFileInfo());
				} else {
					runner.info(logger,"Reusing" + filespec);
				}
			} else {
				runner.info(logger,"Reading" + filespec);
				activeFile = (XmlFile) passedFile;
			}
			
			configurator.setParm("system","xmi-export-file-path",activeFile.getCanonicalPath());
			configurator.setParm("system","xmi-file-path",activeFile.getCanonicalPath() + ".compact.xml");
			
			// now compact the XMI file:remove all irrelevant sections
			runner.debug(logger, "Compacting XMI: " + activeFile.getCanonicalPath());
			Transformer transformer = new Transformer();
		    // transform 
			boolean succeeds = true;
			succeeds = succeeds ? transformer.transformStep("system/xmi-export-file-path", "system/xmi-file-path",  "properties/XMI_COMPACT_XSLPATH") : false ;
						
			configurator.setStepDone(STEP_NAME);
			
			// save any changes to the work configuration for report and future steps
		    configurator.save();
		    
		    report();
		    
			return runner.succeeds();
			
		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	
	private XmlFile exportEapToXmi(EapFile eapFile, XmlFile xmifile) throws Exception {
		eapFile.open();
		String rootPackageGUID = eapFile.getRootPackageGUID();
		XmlFile r = eapFile.exportToXmiFile(xmifile.getCanonicalPath(), rootPackageGUID);
		eapFile.close();
		return r;
	}

}
