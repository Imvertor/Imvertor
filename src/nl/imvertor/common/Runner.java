/*

    Copyright (C) 2016 Dienst voor het kadaster en de openbare registers

*/

/*

    This file is part of Imvertor.

    Imvertor is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Imvertor is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Imvertor.  If not, see <http://www.gnu.org/licenses/>.

*/


package nl.imvertor.common;

import java.io.File;
import java.io.IOException;
import java.util.List;

import nl.imvertor.common.exceptions.ConfiguratorException;

import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

/**
 * The Runner is an object that represents all state information of a single run.
 * 
 * A runner is associated with a configurator.  
 * 
 * @author arjan
 *
 */
public class Runner {

	protected static final Logger logger = Logger.getLogger(Runner.class);
	
	public static final String VC_IDENTIFIER = "$Id: Runner.java 7371 2016-01-11 11:07:16Z arjan $";
	
	public static final Integer APPLICATION_PHASE_CONCEPT = 0;
	public static final Integer APPLICATION_PHASE_DRAFT = 1;
	public static final Integer APPLICATION_PHASE_FINALDRAFT = 2;
	public static final Integer APPLICATION_PHASE_FINAL = 3;
	
	private int imvertorErrors = 0;
	private int imvertorWarnings = 0;

	private Boolean debugging = false;
	private Integer appPhase = APPLICATION_PHASE_CONCEPT;
	private Boolean releasing = false;
	private Boolean mayRelease = true;

	private Messenger messenger;
	
	public Runner() {
		super();
	}
	
	/**
	 * Prepare the environment for the run. 
	 * 
	 * Clears the work folder.
	 * 
	 */
	public void prepare() {
		// remove pre-existing work folder; create new one. Keep existing xmi folder!
		File wf = Configurator.getInstance().getWorkFolder();
		if (wf.isDirectory()) {
			FileUtils.deleteQuietly(new File(wf, "imvert"));
			FileUtils.deleteQuietly(new File(wf, "doc"));
			FileUtils.deleteQuietly(new File(wf, "report"));
			FileUtils.deleteQuietly(new File(wf, "parms.xml"));
		} else {
			wf.mkdirs();
		}
	}
	
	/**
	 * Set the messenger for this runner.
	 * 
	 * @param messenger The messenger, usually as configured for the configurator.
	 * 
	 */
	public void setMessenger(Messenger messenger) {
		this.messenger = messenger;
	}
	
	/**
	 * Windup this run.
	 */
	public void windup() {
		if (imvertorErrors < 0)
			info(logger, "Task fails. Please contact your system administrator.");
		else {
			if (imvertorErrors == 0) 
				if (imvertorWarnings == 0)
					info(logger, "Task succeeds.");
				else
					info(logger, "Task succeeds with warnings.");
			else 
				if (imvertorWarnings == 0)
					info(logger, "Task fails with errors.");
				else
					info(logger, "Task fails with errors and warnings.");
		}
	}
	
	/**
	 * Determine if the run up to this point succeeds. 
	 * 
	 * This implies that are are no error conditions.
	 * These are reported in messages within the configuration, typically introduced within XSL stylesheets.  
	 * 
	 * @return
	 * @throws Exception 
	 */
	public boolean succeeds() throws Exception {
		return Configurator.getInstance().forceCompile() || (getFirstErrorText() == null && imvertorErrors <= 0);
	}

	/**
	 * Set the application phase; this is either 0, 1, 2 or 3.
	 * 
	 * @return
	 * @throws ConfiguratorException 
	 * @throws IOException 
	 */
	public Integer getAppPhase() throws IOException, ConfiguratorException {
		String phase = Configurator.getInstance().getParm("appinfo", "phase",false);
		try {appPhase = (phase != null) ? Integer.parseInt(phase) : appPhase;} catch (NumberFormatException e) {};
		return appPhase;
	}
	
	/**
	 * Return true when this is a final release. 
	 * A final release is in release task (i.e. not compile only), the application is in phase 3, and not in debugging mode.
	 * 
	 * @return True when this is a final release.
	 */
	public boolean isFinal() {
		return appPhase == APPLICATION_PHASE_FINAL && !debugging && releasing;
	}		
	
	/**
	 * Return true when debugging
	 * 
	 * @return
	 */
	public boolean getDebug() {
		return debugging;
	}	
	
	/**
	 * 
	 * @throws IOException
	 * @throws ConfiguratorException
	 * @throws ConfigurationException
	 */
	public void setDebug() throws IOException, ConfiguratorException, ConfigurationException {
		debugging = Configurator.getInstance().isTrue("cli","debug");
	}	
	
	/**
	 * Return true when this app should be released.
	 * This is determined by the cli parameter "task".
	 * 
	 * @return
	 * @throws ConfiguratorException 
	 * @throws IOException 
	 */
	public Boolean getReleasing() throws IOException, ConfiguratorException {
		return Configurator.getInstance().getParm("cli","task").equals("release");
	}
	
	public void setMayRelease(boolean may) {
		mayRelease = may;
	}
	
	public Boolean getMayRelease() {
		return mayRelease;
	}
	
	/**
	 * The ERROR level designates error events that might still allow the application to continue running.
	 * Pass an Exception which information is added to the log.
	 * 
	 * Such process information is logged and/or show in screen when configured as such.
	 *  
	 * @param logger
	 * @param text
	 * @param e
	 */
	public void error(Logger logger, String text, Exception e) {
		imvertorErrors += 1;
		messenger.writeMsg(logger.getName(), "ERROR", "", text);
		logger.error(text,e);
	}
	/**
	 * The ERROR level designates error events that might still allow the application to continue running.
	 * 
	 * Such process information is logged and/or show in screen when configured as such.
	 *  
	 * @param logger
	 * @param text
	 * @param e
	 */
	public void error(Logger logger, String text) {
		imvertorErrors += 1;
		messenger.writeMsg(logger.getName(), "ERROR", "", text);
		logger.error(text);
	}
	/**
	 * The WARN level designates potentially harmful situations.
	 * 
	 * Such process information is logged and/or show in screen when configured as such.
	 *  
	 * @param logger
	 * @param text
	 */
	public void warn(Logger logger, String text) {
		imvertorWarnings += 1;
		messenger.writeMsg(logger.getName(), "WARN", "", text);
		logger.warn(text);
	}
	/**
	 * The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.
	 * 
	 * Such process information is logged and/or show in screen when configured as such.
	 *  
	 * @param logger
	 * @param text
	 */
	public void info(Logger logger, String text) {
		logger.info(text);
	}
	/**
	 * The DEBUG Level designates fine-grained informational events that are most useful to debug an application.
	 * 
	 * Such process information is logged and/or show in screen when configured as such.
	 *  
	 * @param logger
	 * @param text
	 */
	public void debug(Logger logger, String text) {
		logger.debug(text);
	}
	/**
	 * The TRACE Level designates finer-grained informational events than the DEBUG
	 * 
	 * Such process information is logged and/or show in screen when configured as such.
	 *  
	 * @param logger
	 * @param text
	 */
	public void trace(Logger logger, String text) {
		logger.trace(text);
	}
	/**
	 * The FATAL level designates very severe error events that will presumably lead the application to abort.
	 * 
	 * Such process information is logged and/or show in screen when configured as such.
	 *  
	 * For Imvertor, fatal errors abort all processing.
	 * 
	 * @param logger
	 * @param text
	 */
	public void fatal(Logger logger, String text, Exception e) {
		imvertorErrors += 1;
		messenger.writeMsg(logger.getName(), "FATAL", "", text);
		logger.fatal(text, e);
		info(logger, "Must stop due to previous error.");
		System.exit(-1);
	}

	/*
	 * return a count of all errors found
	 * 
	 */
	public int getErrorCount() throws Exception {
		return getErrorTexts(null).size();
	}
	/**
	 * Return the first transformation error on the last processed stylesheet.
	 * 
	 */
	public String getFirstErrorText() throws Exception {
		return getFirstErrorText(null);
	}
	
	/**
	 * Return the first transformation error on the stylesheet passed by name.
	 * 
	 * The "name" of a stylesheet is the file name.
	 * 
	 */
	public String getFirstErrorText(String stylesheetName) throws Exception {
		List<Object> et = getErrorTexts(stylesheetName);
		return (et.size() == 0) ? null : et.get(0).toString();   
	}
	
	/**
	 * Return all errors (ERROR, FATAL) that originate in the stylesheet passed by name. 
	 * This has the form of an array of strings.
	 * When null stylesheet name passed, return all errors.
	 * 
	 * @throws Exception 
	 */
	private List<Object> getErrorTexts(String stylesheetName) throws Exception {
		String condition = (stylesheetName != null) ? "[src='" + stylesheetName + "']" : "";
		return Configurator.getInstance().getXmlConfiguration().getList("messages/message" + condition + "/type[. = 'ERROR' or . = 'FATAL']");
	}

	// TODO supprsess warnings werkt nog niet; waarom de warnings aan het einde op 0?
	public boolean hasWarnings() {
		return imvertorWarnings > 0;
	}
}
