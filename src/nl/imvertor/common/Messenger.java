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


//SVN: $Id: Messenger.java 7323 2015-11-25 10:17:17Z arjan $

package nl.imvertor.common;

import org.apache.log4j.Logger;

import net.sf.saxon.event.PipelineConfiguration;
import net.sf.saxon.event.SequenceWriter;
import net.sf.saxon.om.AxisInfo;
import net.sf.saxon.om.Item;
import net.sf.saxon.om.NodeInfo;
import net.sf.saxon.tree.iter.AxisIterator;
import nl.imvertor.common.wrapper.XMLConfiguration;

/**
 * A Messenger passes messages from XSLT of java top the XML configuration file.
 * The messages are subsequently available for processing by any next step.
 * 
 * 
 * @author arjan
 *
 */
public class Messenger extends SequenceWriter {

	public static final Logger logger = Logger.getLogger(Messenger.class);
	public static final String VC_IDENTIFIER = "$Id: Messenger.java 7323 2015-11-25 10:17:17Z arjan $";

	private String fatalValue = "FATAL";
	
	public Messenger(PipelineConfiguration pcfg) {
		super(pcfg);
	}
	
	@Override
	/**
	 * This method implements writing a message to the configuration element "/messages".
	 * This method is called from within XSLT extension function only.
	 * 
	 * Each next step in the chain may pick up this messages, e.g. process them for documentation purposes.
	 * 
	 *  A message sent out takes the form of a single string, in which case the string is sent to the system.out stream, 
	 *  or a sequence of elements with text content, in which case it is appended to the xml configuration.   
	 *  
	 * Messages are written directly to the screen when they do not consist of a single *:message element.
	 * 
	 * A fatal message (FATAL) will result in an exception thrown. This ends the process (and logging).
	 * 
	 */
	public void write(Item item) {
		
		Configurator cfg = Configurator.getInstance();
		Boolean suppresswarnings = cfg.getSuppressWarnings();
		
		Runner runner = cfg.getRunner();

		NodeInfo messageroot = ((NodeInfo) item).getDocumentRoot();
		AxisIterator elements = messageroot.iterateAxis(AxisInfo.CHILD);
		NodeInfo child = (NodeInfo) elements.next();
		NodeInfo sibling = (NodeInfo) elements.next();
		// if only a text string is passed, this is a normal debugging message, and is shown directly
		if (child.getNodeKind() == net.sf.saxon.type.Type.TEXT && sibling == null) {
			System.out.println(child.getStringValue());
		} else {
			// determine the source, text and type of the message.
			String type = "";
			String text = "";
			String name = "";
			String src = "";
			while (child != null) {
				if (child.getNodeKind() == net.sf.saxon.type.Type.ELEMENT) {
					String elementName = child.getLocalPart();
					String elementValue = child.getStringValue();
					if (elementName.equals("type")) type = elementValue;
					if (elementName.equals("name")) name = elementValue;
					if (elementName.equals("text")) text = elementValue;
					if (elementName.equals("src")) src = elementValue;
				}
				child = sibling;
				sibling = (NodeInfo) elements.next();
			}
			
			// then signal to screen if needed, and die if fatal
			String ctext = src + ": [" + name + "] " + text;
			
			switch (type) {
				case "FATAL":
					runner.fatal(logger,ctext,null); // The FATAL level designates very severe error events that will presumably lead the application to abort.
					break;  
				case "ERROR":
					runner.error(logger,ctext); // The ERROR level designates error events that might still allow the application to continue running.
					break;  
				case "WARN":
					if (!suppresswarnings) runner.warn(logger,ctext); // The WARN level designates potentially harmful situations.
					break;  
				case "INFO": 
					runner.info(logger,ctext); // The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.
					break;  
				case "DEBUG": // The DEBUG Level designates fine-grained informational events that are most useful to debug an application.
					runner.debug(logger,ctext);
					break;  
				case "TRACE": // The TRACE Level designates finer-grained informational events than the DEBUG 
					runner.trace(logger,ctext);
					break;  
			}
			if (type.equals(fatalValue))
				runner.fatal(logger,src + " - " + text,null);
		}
	}
	
	/**
	 * Write a message directly to the configuration file.
	 * This is confined to warnings and errors.
	 * 
	 * @param type
	 * @param text
	 * @param src
	 */
	public void writeMsg(String src, String type, String name, String text) {
		if (exists(src) && exists(type) && exists(text)) {
			XMLConfiguration cfg = Configurator.getInstance().getXmlConfiguration();
			int messageIndex = cfg.getMaxIndex("messages/message") + 2;   // -1 when no messages.
			cfg.addProperty("messages/message", "");
			cfg.addProperty("messages/message[" + messageIndex + "]/src", src);
			cfg.addProperty("messages/message[" + messageIndex + "]/type", type);
			cfg.addProperty("messages/message[" + messageIndex + "]/name", name);
			cfg.addProperty("messages/message[" + messageIndex + "]/text", text);
		}
	}
	
	private boolean exists(String v) {
		return (v != null) && !v.equals("");
	}
}
